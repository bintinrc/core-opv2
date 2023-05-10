@OperatorV2 @Core @EditOrder @CancelOrder @EditOrder1 @RoutingModules
Feature: Cancel Order

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Cancel Order - On Hold
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Hold                            |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page
    When API Core - cancel order and check error:
      | statusCode | 500               |
      | message    | Order is On Hold! |

  Scenario: Cancel Order - Pending Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    When Operator cancel order on Edit Order V2 page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) cancelled                        |
      | bottom             | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | waitUntilInvisible | true                                        |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify order summary on Edit Order V2 page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Core - verify Pickup transaction of the order:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id     | {KEY_WAYPOINT_ID} |
      | status | Pending           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_WAYPOINT_ID} |
      | number     | 1                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_WAYPOINT_ID} |
      | archived   | 1                 |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And API Core - verify Delivery transaction of the order:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id     | {KEY_WAYPOINT_ID} |
      | status | Pending           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_WAYPOINT_ID} |
      | number     | 1                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_WAYPOINT_ID} |
      | archived   | 1                 |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                     |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Cancelled\n\nOld Order Status: Pending\nNew Order Status: Cancelled\n\nReason: CANCEL |

  @DeleteOrArchiveRoute
  Scenario: Cancel Order - Pickup Fail
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order as "KEY_TRANSACTION"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                 |
      | waypointId      | {KEY_TRANSACTION.waypointId}                                                       |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                  |
      | jobAction       | FAIL                                                                               |
      | jobMode         | PICK_UP                                                                            |
      | failureReasonId | 9                                                                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pickup Fail" on Edit Order V2 page
    And Operator verify order granular status is "Pickup Fail" on Edit Order V2 page
    When Operator cancel order on Edit Order V2 page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) cancelled                        |
      | bottom             | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | waitUntilInvisible | true                                        |
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify order summary on Edit Order V2 page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - verify Pickup transaction of the order:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - verify Delivery transaction of the order:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id     | {KEY_WAYPOINT_ID} |
      | status | Pending           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_WAYPOINT_ID} |
      | number     | 1                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_WAYPOINT_ID} |
      | archived   | 1                 |
      | status     | Pending           |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                      |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pickup fail\nNew Granular Status: Cancelled\n\nOld Order Status: Pickup fail\nNew Order Status: Cancelled\n\nReason: CANCEL |

  @DeleteOrArchiveRoute
  Scenario: Cancel Order - Van En-route to Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Van En-route to Pickup" on Edit Order V2 page
    When Operator cancel order on Edit Order V2 page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) cancelled                        |
      | bottom             | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | waitUntilInvisible | true                                        |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify order summary on Edit Order V2 page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Core - verify Pickup transaction of the order:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id      | {KEY_WAYPOINT_ID} |
      | routeId | null              |
      | status  | Pending           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_WAYPOINT_ID} |
      | number     | 1                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_WAYPOINT_ID} |
      | archived   | 1                 |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_WAYPOINT_ID} |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status  | CANCELLED |
      | routeId |           |
    And API Core - verify Delivery transaction of the order:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id      | {KEY_WAYPOINT_ID} |
      | routeId | null              |
      | seqNo   | null              |
      | status  | Pending           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_WAYPOINT_ID} |
      | number     | 1                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_WAYPOINT_ID} |
      | archived   | 1                 |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                             |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Van en-route to pickup\nNew Granular Status: Cancelled\n\nOld Order Status: Transit\nNew Order Status: Cancelled\n\nReason: CANCEL |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_WAYPOINT_ID} |

  Scenario: Cancel Order - Staging
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Staging" on Edit Order V2 page
    And Operator verify order granular status is "Staging" on Edit Order V2 page
    And Operator cancel order on Edit Order V2 page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) cancelled                        |
      | bottom             | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | waitUntilInvisible | true                                        |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify order summary on Edit Order V2 page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Core - verify Pickup transaction of the order:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And API Core - verify Delivery transaction of the order:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id     | {KEY_WAYPOINT_ID} |
      | status | Pending           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_WAYPOINT_ID} |
      | number     | 1                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_WAYPOINT_ID} |
      | archived   | 1                 |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                              |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Staging\nNew Granular Status: Cancelled\n\nOld Order Status: Staging\nNew Order Status: Cancelled\n\nReason: CANCEL |

  Scenario: Cancel Order - En-route to Sorting Hub
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | En-route to Sorting Hub            |
    When API Core - cancel order and check error:
      | statusCode | 500                               |
      | message    | Order is En-route to Sorting Hub! |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page

  Scenario: Cancel Order - Arrived at Sorting Hub
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When API Core - cancel order and check error:
      | statusCode | 500                              |
      | message    | Order is Arrived at Sorting Hub! |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page

  Scenario: Cancel Order - On Vehicle for Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Vehicle for Delivery            |
    When API Core - cancel order and check error:
      | statusCode | 500                               |
      | message    | Order is On Vehicle for Delivery! |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page

  Scenario: Cancel Order - Returned to Sender
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Returned to Sender                 |
    When API Core - cancel order and check error:
      | statusCode | 500                          |
      | message    | Order is Returned to Sender! |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Returned to Sender" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page

  Scenario: Cancel Order - Arrived at Distribution Point
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Arrived at Distribution Point      |
    When API Core - cancel order and check error:
      | statusCode | 500                                     |
      | message    | Order is Arrived at Distribution Point! |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Distribution Point" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page

  Scenario: Cancel Order - Completed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Completed                          |
    When API Core - cancel order and check error:
      | statusCode | 500                 |
      | message    | Order is Completed! |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page

  Scenario: Cancel Order - Cancelled
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page

  Scenario: Cancel Order - Transferred to 3PL
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | 3plShipperName | {3pl-shipper-name} |
      | 3plShipperId   | {3pl-shipper-id}   |
    When API Core - cancel order and check error:
      | statusCode | 500                          |
      | message    | Order is Transferred to 3PL! |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Transferred to 3PL" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page

  Scenario: Operator Cancel Order From Resolved Recovery Ticket
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    When Operator create new recovery ticket on Edit Order V2 page:
      | entrySource             | CUSTOMER COMPLAINT              |
      | investigatingDepartment | Recovery                        |
      | investigatingHub        | {hub-name}                      |
      | ticketType              | DAMAGED                         |
      | orderOutcomeDamaged     | NV NOT LIABLE - PARCEL DISPOSED |
      | parcelLocation          | DAMAGED RACK                    |
      | liability               | Shipper                         |
      | damageDescription       | GENERATED                       |
      | ticketNotes             | GENERATED                       |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |
      | UPDATE STATUS  |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status  | RESOLVED                        |
      | outcome | NV NOT LIABLE - PARCEL DISPOSED |
    Then Operator verifies that success toast displayed:
      | top                | ^Ticket ID : .* updated |
      | waitUntilInvisible | true                    |
    And Operator refresh page
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP    |
      | status | CANCELLED |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY  |
      | status | CANCELLED |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET RESOLVED |
      | TICKET UPDATED  |
      | CANCEL          |
    When API Operator get order details
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
    And DB Operator verify Jaro Scores of Pickup Transaction waypoint of created order are archived

  @DeleteOrArchiveRoute
  Scenario: Cancel Order - Merged Delivery Waypoints
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+6595557073","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+6595557073","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Operator verifies Delivery transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    When Operator cancel order on Edit Order V2 page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) cancelled                        |
      | bottom             | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | waitUntilInvisible | true                                        |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order as "KEY_TRANSACTION_AFTER"
    And DB Core - verify waypoints record:
      | id       | {KEY_TRANSACTION_AFTER.waypointId} |
      | status   | Pending                            |
      | address1 | Orchard Road central               |
      | country  | SG                                 |
      | postcode | 511200                             |
      | routeId  | null                               |
      | seqNo    | null                               |
    And Operator verify order events on Edit Order V2 page using data below:
      | name              |
      | UPDATE STATUS     |
      | PULL OUT OF ROUTE |
      | CANCEL            |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order as "KEY_TRANSACTION_AFTER"
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Routed                             |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op