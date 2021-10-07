@PriorityParcelOnVehicle @StationHome @StationManagement
Feature: Priority Parcels On Vehicle for Delivery

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @coverage-manual @coverage-operator-manual @step-done @station-happy-path
  Scenario Outline: View Priority Parcel on Vehicle for Delivery (uid:bd22c933-b02b-4302-b086-9336148dc9a8)
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
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-1}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order scan updated
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator go to menu Routing -> Route Logs
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID |
      | Timeslot    |
      | Driver Name |
      | Route ID    |
      | Address     |
    And searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     | Route ID               |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_CREATED_ROUTE_ID} |
    And verifies that Edit Order page is opened on clicking tracking id
    And verifies that Route Manifest page is opened on clicking route id
    And reloads operator portal to reset the test state

    Examples:
      | TileName                                 | ModalName                   |
      | Priority parcels on vehicle for delivery | Priority Parcels on Vehicle |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op