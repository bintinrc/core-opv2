@StationHome @Story-5
Feature: Number of Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Case-1
  Scenario Outline: Case-1
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"<LowerSize>", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And gets the count of the parcel by parcel size from the table: "<TableName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Order Details on Edit Order page
    And updates parcel size from "<LowerSize>" to "<UpperSize>" for the order
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has remained un-changed
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the parcel count for "<LowerSize>" is decreased by 1 in the table: "<TableName>"
    And verifies that the parcel count for "<UpperSize>" is increased by 1 in the table: "<TableName>"
    And verifies that the size is also updated as "<UpperSize>" in station database
    And reloads operator portal to reset the test state

    Examples:
      | TileName                 | ModalName      | TableName      | LowerSize | UpperSize |
      | Number of parcels in hub | Parcels in Hub | By Parcel Size | S         | XXL       |


  @Case-2
  Scenario Outline: Case-2
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"<UpperSize>", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And gets the count of the parcel by parcel size from the table: "<TableName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Order Details on Edit Order page
    And updates parcel size from "<UpperSize>" to "<LowerSize>" for the order
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has remained un-changed
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the parcel count for "<UpperSize>" is decreased by 1 in the table: "<TableName>"
    And verifies that the parcel count for "<LowerSize>" is increased by 1 in the table: "<TableName>"
    And verifies that the size is also updated as "<LowerSize>" in station database
    And reloads operator portal to reset the test state

    Examples:
      | TileName                 | ModalName      | TableName      | UpperSize | LowerSize |
      | Number of parcels in hub | Parcels in Hub | By Parcel Size | XXL       | S       |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op