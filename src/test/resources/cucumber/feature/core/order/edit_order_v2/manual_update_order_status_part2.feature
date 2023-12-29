@OperatorV2 @Core @EditOrderV2 @ManualUpdateOrderStatus @ManualUpdateOrderStatusPart2 @update-status @current
Feature: Manual Update Order Status

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority @wip
  Scenario Outline: Operator Manually Update Order Granular Status - Pending Reschedule
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator update order status on Edit Order V2 page:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success react notification displayed:
      | top | Status updated |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | <status>         |
      | granularStatus | <granularStatus> |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <pickupWpStatus>             |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_TRANSACTION.id}                       |
      | txnType        | PICKUP                                     |
      | txnStatus      | SUCCESS                                    |
      | dnrId          | 0                                          |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus | Pending Reschedule                         |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <deliveryWpStatus>           |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_TRANSACTION.id}                       |
      | txnType        | DELIVERY                                   |
      | txnStatus      | FAIL                                       |
      | dnrId          | 0                                          |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus | Pending Reschedule                         |
    Examples:
      | granularStatus     | status        | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                                    |
      | Pending Reschedule | Delivery fail | SUCCESS      | FAIL           | Success        | Fail             | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Delivery Status: Pending\nNew Delivery Status: Fail\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Pending Reschedule\n\nOld Order Status: Pending\nNew Order Status: Delivery fail\n\nReason: Status updated for testing purposes |

  @MediumPriority
  Scenario Outline: Operator Manually Update Order Granular Status - Transferred to 3PL
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator update order status on Edit Order V2 page:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success react notification displayed:
      | top | Status updated |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | <status>         |
      | granularStatus | <granularStatus> |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <pickupWpStatus>             |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <deliveryWpStatus>           |
    Examples:
      | granularStatus     | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                     |
      | Transferred to 3PL | Transit | SUCCESS      | PENDING        | Success        | Pending          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Transferred to 3PL\n\nOld Order Status: Pending\n\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  @MediumPriority
  Scenario Outline: Operator Manually Update Order Granular Status - Arrived at Distribution Point
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator update order status on Edit Order V2 page:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success react notification displayed:
      | top | Status updated |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | <status>         |
      | granularStatus | <granularStatus> |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <pickupWpStatus>             |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <deliveryWpStatus>           |
    Examples:
      | granularStatus                | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                                            |
      | Arrived at Distribution Point | Transit | SUCCESS      | SUCCESS        | Success        | Success          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Delivery Status: Pending\nNew Delivery Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Arrived at Distribution Point\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  @MediumPriority
  Scenario Outline: Operator Manually Update Order Granular Status - On Vehicle for Delivery , Latest Delivery is Unrouted
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Pending Reschedule                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator update order status on Edit Order V2 page:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success react notification displayed:
      | top | Status updated |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | <status>         |
      | granularStatus | <granularStatus> |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <pickupWpStatus>             |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <deliveryWpStatus>           |
    Examples:
      | granularStatus          | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                   |
      | On Vehicle for Delivery | Transit | SUCCESS      | PENDING        | Success        | Pending          | Old Delivery Status: Fail\nNew Delivery Status: Pending\n\nOld Granular Status: Pending Reschedule\nNew Granular Status: On Vehicle for Delivery\n\nOld Order Status: Delivery fail\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Operator Manually Update Order Granular Status - On Vehicle for Delivery, Latest Delivery is Routed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Pending Reschedule                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator update order status on Edit Order V2 page:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success react notification displayed:
      | top | Status updated |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | <status>         |
      | granularStatus | <granularStatus> |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <pickupWpStatus>             |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <deliveryWpStatus>           |
    Examples:
      | granularStatus          | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                   |
      | On Vehicle for Delivery | Transit | SUCCESS      | PENDING        | Success        | Routed           | Old Delivery Status: Fail\nNew Delivery Status: Pending\n\nOld Granular Status: Pending Reschedule\nNew Granular Status: On Vehicle for Delivery\n\nOld Order Status: Delivery fail\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  @MediumPriority
  Scenario: Operator Not Allowed to Manually Update Normal Order Granular Status - Pickup Fail
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator update order status on Edit Order V2 page:
      | granularStatus | Pickup fail                         |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                              |
      | bottom | ^.*Error Message: Pickup fail status is only for return orders.* |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |

  @MediumPriority
  Scenario: Disable Manual Update Status for On Hold Order with Active PETS Ticket
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
    Then Operator verify menu item "Order Settings" > "Update Status" is disabled on Edit Order V2 page

  @MediumPriority
  Scenario: Disable Manual Update Status for Returned To Sender Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "false"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify menu item "Order Settings" > "Update Status" is disabled on Edit Order V2 page

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Operator Manually Update Order Granular Status - Pending Reschedule to Arrived at Sorting Hub
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Pending Reschedule                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator update order status on Edit Order V2 page:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success react notification displayed:
      | top | Status updated |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | <status>         |
      | granularStatus | <granularStatus> |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <pickupWpStatus>             |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | <deliveryWpStatus>           |
    Examples:
      | granularStatus         | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                  |
      | Arrived at Sorting Hub | Transit | SUCCESS      | PENDING        | Success        | Routed           | Old Delivery Status: Fail\nNew Delivery Status: Pending\n\nOld Granular Status: Pending Reschedule\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: Delivery fail\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |