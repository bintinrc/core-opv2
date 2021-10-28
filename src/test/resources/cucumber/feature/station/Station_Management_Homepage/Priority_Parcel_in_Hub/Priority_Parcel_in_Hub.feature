@StationManagement @StationHome
Feature: Priority Parcel in Hub


  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: View Priority Parcel in Hub (uid:4e760809-5688-407c-83c5-32f2fe53e368)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID          |
      | Address              |
      | Order Tags           |
      | Size                 |
      | Timeslot             |
      | Committed ETA        |
      | Recovery Ticket Type |
      | Ticket Status        |
    And searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     | Order Tags |
      | {KEY_CREATED_ORDER_TRACKING_ID} | PRIOR      |
    And verifies that Edit Order page is opened on clicking tracking id
    And reloads operator portal to reset the test state

    Examples:
      | TileName                | ModalName               |
      | Priority parcels in hub | Priority Parcels in Hub |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op