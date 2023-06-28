@OperatorV2 @Core @Inbounding @VanInbound @VanInboundPart1
Feature: Van Inbound

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @happy-path
  Scenario: Operator Van Inbounds And Starts Route with Valid Tracking ID
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    Then Operator verify the van inbound process is succeed
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order scan updated
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator go to menu Routing -> Route Logs
    Then Operator verify the route is started after van inbounding using data below:
      | routeDateFrom | {gradle-current-date-yyyy-MM-dd} |
      | routeDateTo   | {gradle-current-date-yyyy-MM-dd} |
      | hubName       | {hub-name}                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER INBOUND SCAN  |
      | routeId | KEY_CREATED_ROUTE_ID |
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER START ROUTE   |
      | routeId | KEY_CREATED_ROUTE_ID |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                        |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Vehicle for Delivery\n\n\nReason: START_ROUTE |
    And DB Operator verifies inbound_scans record with type "4" and correct route_id

  @DeleteOrArchiveRoute
  Scenario: Operator Van Inbounds with Invalid Tracking ID
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the invalid tracking ID INVALID_TRACKING_ID on Van Inbound Page
    Then Operator verify the tracking ID INVALID_TRACKING_ID that has been input on Van Inbound Page is invalid

  @DeleteOrArchiveRoute
  Scenario: Operator Van Inbounds with Empty Tracking ID
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the empty tracking ID on Van Inbound Page
    Then Operator verify the tracking ID that has been input on Van Inbound Page is empty

  @DeleteOrArchiveRoute
  Scenario: Operator Van Inbounds Multiple Orders With Different Order Status And Checks Scanned Parcels
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | On Vehicle for Delivery           |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
      | granularStatus | Arrived at Sorting Hub            |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[3]} |
      | granularStatus | Pending Pickup                    |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | hubId | {hub-id}                                   |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
      | hubId | {hub-id}                                   |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator scan "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" tracking ID on Van Inbound Page
    Then Operator verifies "1/3" scanned parcels displayed on Van Inbound Page
    When Operator scan "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" tracking ID on Van Inbound Page
    Then Operator verifies "2/3" scanned parcels displayed on Van Inbound Page
    When Operator scan "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]}" tracking ID on Van Inbound Page
    Then Operator verifies "3/3" scanned parcels displayed on Van Inbound Page
    When Operator click Scanned Parcels area on Van Inbound Page
    Then Operator verifies Scanned Parcels dialog contains orders info:
      | trackingId                                 | name                                  | contact                                  | address                                             | granularStatus          | status  |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER[1].toName} | {KEY_LIST_OF_CREATED_ORDER[1].toContact} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | On Vehicle for Delivery | Transit |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_ORDER[2].toName} | {KEY_LIST_OF_CREATED_ORDER[2].toContact} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | Arrived at Sorting Hub  | Transit |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | {KEY_LIST_OF_CREATED_ORDER[3].toName} | {KEY_LIST_OF_CREATED_ORDER[3].toContact} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | Pending Pickup          | Pending |

  @DeleteOrArchiveRoute
  Scenario: Operator Van Inbounds And Starts Route Multiple Success, Failed and Pending Pickups In A Route
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | En-route to Sorting Hub           |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
      | granularStatus | Pickup Fail                       |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[3]} |
      | granularStatus | Pending Pickup                    |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | hubId | {hub-id}                                   |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
      | hubId | {hub-id}                                   |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    When Operator scan "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" tracking ID on Van Inbound Page
    When Operator scan "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" tracking ID on Van Inbound Page
    When Operator scan "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]}" tracking ID on Van Inbound Page
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order events are not presented on Edit order page:
      | DRIVER START ROUTE  |
      | DRIVER INBOUND SCAN |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    And Operator verify order status is "Pickup fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page
    And Operator verify order events are not presented on Edit order page:
      | DRIVER START ROUTE  |
      | DRIVER INBOUND SCAN |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[3]}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van en-route to pickup" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER START ROUTE     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Van en-route to pickup\n\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: START_ROUTE |
    And Operator verify order events are not presented on Edit order page:
      | DRIVER INBOUND SCAN |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

  @DeleteOrArchiveRoute
  Scenario: Operator Van Inbounds And Starts Route Multiple Success, Failed and Pending Deliveries In A Route
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Completed                         |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
      | granularStatus | Pending Reschedule                |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[3]} |
      | granularStatus | Arrived At Sorting Hub            |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | hubId | {hub-id}                                   |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
      | hubId | {hub-id}                                   |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    When Operator scan "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" tracking ID on Van Inbound Page
    When Operator scan "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" tracking ID on Van Inbound Page
    When Operator scan "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]}" tracking ID on Van Inbound Page
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify order events are not presented on Edit order page:
      | DRIVER START ROUTE |
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER INBOUND SCAN    |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify order events are not presented on Edit order page:
      | DRIVER START ROUTE |
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER INBOUND SCAN    |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[3]}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER START ROUTE     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER INBOUND SCAN    |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                        |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Vehicle for Delivery\n\n\nReason: START_ROUTE |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |
