@OperatorV2 @Core @Routing @RoutingJob3 @AddOrderToRoute @RoutingModules
Feature: Add Order To Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Add Order to a Route - Pickup, Valid Tracking ID, With Prefix
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_CREATED_ROUTE_ID}" route id on Add Order to Route page
    And Operator set "Pickup" transaction type on Add Order to Route page
    And Operator add prefix of the created order on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER.requestedTrackingId}" tracking id on Add Order to Route page
    Then Operator verifies that "Order {KEY_CREATED_ORDER.requestedTrackingId} added to route {KEY_CREATED_ROUTE_ID}" success toast message is displayed
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE           |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id

    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly

    And DB Operator verifies route_monitoring_data record
    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    Then Verify that waypoints are shown on driver "{ninja-driver-id}" list route correctly

  @DeleteOrArchiveRoute
  Scenario: Add Order to a Route - Invalid Tracking ID, With Prefix
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_CREATED_ROUTE_ID}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    When Operator add "TEST" prefix on Add Order to Route page
    And Operator enters "INVALIDTRACKINGID" tracking id on Add Order to Route page
    Then Operator verifies that "Order TESTINVALIDTRACKINGID not found!" error toast message is displayed
    And Operator verifies the last scanned tracking id is "TESTINVALIDTRACKINGID"

  @DeleteOrArchiveRoute @routing-refactor @happy-path
  Scenario: Add Order to a Route - Delivery, Valid Tracking ID, No Prefix
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_CREATED_ROUTE_ID}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that "Order {KEY_CREATED_ORDER_TRACKING_ID} added to route {KEY_CREATED_ROUTE_ID}" success toast message is displayed
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE           |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies route_monitoring_data record
    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    Then Verify that waypoints are shown on driver "{ninja-driver-id}" list route correctly

  @DeleteOrArchiveRoute
  Scenario: Add Order to a Route - Invalid Tracking ID, No Prefix
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_CREATED_ROUTE_ID}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "INVALIDTRACKINGID" tracking id on Add Order to Route page
    Then Operator verifies that "Order INVALIDTRACKINGID not found!" error toast message is displayed
    And Operator verifies the last scanned tracking id is "INVALIDTRACKINGID"

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Not Allowed to Add Delivery Routed Order to a New Route - Non-ID Country
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                   |
      | bottom | ^.*Error Code: 103024.*Error Message: Delivery is already routed to {KEY_LIST_OF_CREATED_ROUTE_ID[2]}.* |
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id

    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly

    And DB Operator verifies route_monitoring_data record
    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    Then Verify that waypoints are shown on driver "{ninja-driver-id}" list route correctly
