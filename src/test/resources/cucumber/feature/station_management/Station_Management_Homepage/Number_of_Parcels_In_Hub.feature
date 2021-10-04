@NumberOfParcels @StationHome @StationManagement
Feature: Number of Parcels In Hub


  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @coverage-manual @coverage-operator-manual @step-done @station-happy-path
  Scenario Outline: View Number of Parcels in Hub (uid:34b4182d-ee92-4936-b4b8-fbc3890be67d)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the table:"<TableName1>" is displayed with following columns:
      | Size  |
      | Count |
    And verifies that the table:"<TableName2>" is displayed with following columns:
      | Zones |
      | Count |
    And reloads operator portal to reset the test state

    Examples:
      | TileName                 | ModalName      | TableName1     | TableName2 |
      | Number of parcels in hub | Parcels in Hub | By Parcel Size | By Zones   |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op