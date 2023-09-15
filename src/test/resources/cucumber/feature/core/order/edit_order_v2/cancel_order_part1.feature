@OperatorV2 @Core @EditOrderV2 @CancelOrder @CancelOrderPart1
Feature: Cancel Order

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Cancel Order - On Hold
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Hold                            |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page
    When API Core - cancel order and check error:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | statusCode | 500                                |
      | message    | Order is On Hold!                  |

  @happy-path
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
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify order summary on Edit Order V2 page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Core - verify Pickup transaction of the order:
      | ordersListKey | KEY_LIST_OF_CREATED_ORDERS                                                         |
      | status        | CANCELLED                                                                          |
      | comments      | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id     | {KEY_CORE_TRANSACTION.waypointId} |
      | status | Pending                           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | number     | 1                                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | archived   | 1                                 |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And API Core - verify Delivery transaction of the order:
      | ordersListKey | KEY_LIST_OF_CREATED_ORDERS                                                         |
      | status        | CANCELLED                                                                          |
      | comments      | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id     | {KEY_CORE_TRANSACTION.waypointId} |
      | status | Pending                           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | number     | 1                                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | archived   | 1                                 |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                     |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Cancelled\n\nOld Order Status: Pending\nNew Order Status: Cancelled\n\nReason: CANCEL |

  @ArchiveRouteCommonV2
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
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
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
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify order summary on Edit Order V2 page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - verify Pickup transaction of the order:
      | ordersListKey | KEY_LIST_OF_CREATED_ORDERS         |
      | status        | FAIL                               |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - verify Delivery transaction of the order:
      | ordersListKey | KEY_LIST_OF_CREATED_ORDERS                                                         |
      | status        | CANCELLED                                                                          |
      | comments      | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id     | {KEY_CORE_TRANSACTION.waypointId} |
      | status | Pending                           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | number     | 1                                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | archived   | 1                                 |
      | status     | Pending                           |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                      |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pickup fail\nNew Granular Status: Cancelled\n\nOld Order Status: Pickup fail\nNew Order Status: Cancelled\n\nReason: CANCEL |

  @ArchiveRouteCommonV2
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
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify order summary on Edit Order V2 page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Core - verify Pickup transaction of the order:
      | ordersListKey | KEY_LIST_OF_CREATED_ORDERS                                                         |
      | status        | CANCELLED                                                                          |
      | comments      | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id      | {KEY_CORE_TRANSACTION.waypointId} |
      | routeId | null                              |
      | status  | Pending                           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | number     | 1                                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | archived   | 1                                 |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_CORE_TRANSACTION.waypointId} |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status  | CANCELLED |
      | routeId |           |
    And API Core - verify Delivery transaction of the order:
      | ordersListKey | KEY_LIST_OF_CREATED_ORDERS                                                         |
      | status        | CANCELLED                                                                          |
      | comments      | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id      | {KEY_CORE_TRANSACTION.waypointId} |
      | routeId | null                              |
      | seqNo   | null                              |
      | status  | Pending                           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | number     | 1                                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | archived   | 1                                 |
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
      | {KEY_CORE_TRANSACTION.waypointId} |

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
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify order summary on Edit Order V2 page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Core - verify Pickup transaction of the order:
      | ordersListKey | KEY_LIST_OF_CREATED_ORDERS                                                         |
      | status        | CANCELLED                                                                          |
      | comments      | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | CANCELLED |
    And API Core - verify Delivery transaction of the order:
      | ordersListKey | KEY_LIST_OF_CREATED_ORDERS                                                         |
      | status        | CANCELLED                                                                          |
      | comments      | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Core - verify waypoints record:
      | id     | {KEY_CORE_TRANSACTION.waypointId} |
      | status | Pending                           |
    And DB Core - verify number of records in order_jaro_scores_v2:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | number     | 1                                 |
    And DB Core - verify order_jaro_scores_v2 record:
      | waypointId | {KEY_CORE_TRANSACTION.waypointId} |
      | archived   | 1                                 |
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
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | En-route to Sorting Hub            |
    When API Core - cancel order and check error:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | statusCode | 500                                |
      | message    | Order is En-route to Sorting Hub!  |
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
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | statusCode | 500                                |
      | message    | Order is Arrived at Sorting Hub!   |
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
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Vehicle for Delivery            |
    When API Core - cancel order and check error:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | statusCode | 500                                |
      | message    | Order is On Vehicle for Delivery!  |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit Order V2 page