@OperatorV2 @Core @Routing @AddOrderToRoute @current
Feature: Add Order To Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Add Order to a Route - Pickup, Valid Tracking ID, With Prefix (uid:44589e4d-860b-45ac-a50e-add9f5aedf4a)
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
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints
    And DB Operator verifies waypoints.seq_no is the same as route_waypoint.seq_no for each waypoint
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute
  Scenario: Add Order to a Route - Invalid Tracking ID, With Prefix (uid:ce2a5e6b-f06d-4c6d-9f9c-656ac605b3bb)
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

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Add Order to a Route - Delivery, Valid Tracking ID, No Prefix (uid:777598b1-78a7-4e36-bdc3-7345f32ab40a)
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
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints
    And DB Operator verifies waypoints.seq_no is the same as route_waypoint.seq_no for each waypoint
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute
  Scenario: Add Order to a Route - Invalid Tracking ID, No Prefix (uid:e09d356e-d21f-462a-b26f-a2631203662e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_CREATED_ROUTE_ID}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "INVALIDTRACKINGID" tracking id on Add Order to Route page
    Then Operator verifies that "Order INVALIDTRACKINGID not found!" error toast message is displayed
    And Operator verifies the last scanned tracking id is "INVALIDTRACKINGID"

  @DeleteOrArchiveRoute
  Scenario: Operator Add Marketplace Sort Order To Route via Add Order To Route Page - RTS = 1
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-sort-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-sort-client-secret} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Marketplace Sort","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_CREATED_ROUTE_ID}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that "Order {KEY_CREATED_ORDER_TRACKING_ID} added to route {KEY_CREATED_ROUTE_ID}" success toast message is displayed
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    And API Operator get order details
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
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints
    And DB Operator verifies waypoints.seq_no is the same as route_waypoint.seq_no for each waypoint
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute
  Scenario: Operator Add Marketplace Sort Order To Route via Add Order To Route Page - RTS = 0
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-sort-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-sort-client-secret} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Marketplace Sort","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_CREATED_ROUTE_ID}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                          |
      | bottom | ^.*Error Code: 103093.*Error Message: Marketplace Sort order is not allowed!.* |
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op