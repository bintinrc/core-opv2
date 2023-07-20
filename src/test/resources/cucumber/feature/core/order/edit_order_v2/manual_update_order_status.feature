@OperatorV2 @Core @EditOrderV2 @ManualUpdateOrderStatus @ManualUpdateOrderStatusPart1 @EditOrder1
Feature: Manual Update Order Status

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Manually Update Order Granular Status - Staging
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                      |
      | Staging        | Staging | STAGING      | STAGING        | Pending        | Pending          | Old Pickup Status: Pending\nNew Pickup Status: Staging\n\nOld Delivery Status: Pending\nNew Delivery Status: Staging\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Staging\n\nOld Order Status: Pending\nNew Order Status: Staging\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Pending Pickup, Latest Pickup is Unrouted
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator update order status on Edit Order V2 page:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success react notification displayed:
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                       |
      | Pending Pickup | Pending | PENDING      | PENDING        | Pending        | Pending          | Old Pickup Status: Success\nNew Pickup Status: Pending\n\nOld Granular Status: Arrived at Sorting Hub\nNew Granular Status: Pending Pickup\n\nOld Order Status: Transit\nNew Order Status: Pending\n\nReason: Status updated for testing purposes |

  @DeleteRoutes
  Scenario Outline: Operator Manually Update Order Granular Status - Pending Pickup, Latest Pickup is Routed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator update order status on Edit Order V2 page:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success react notification displayed:
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                       |
      | Pending Pickup | Pending | PENDING      | PENDING        | Pending        | Routed           | Old Pickup Status: Success\nNew Pickup Status: Pending\n\nOld Granular Status: Arrived at Sorting Hub\nNew Granular Status: Pending Pickup\n\nOld Order Status: Transit\nNew Order Status: Pending\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Van En-route to Pickup
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus         | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                             |
      | Van en-route to pickup | Transit | PENDING      | PENDING        | Pending        | Pending          | Old Granular Status: Pending Pickup\nNew Granular Status: Van en-route to pickup\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - En-route to Sorting Hub
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus          | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                        |
      | En-route to Sorting Hub | Transit | SUCCESS      | PENDING        | Success        | Pending          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: En-route to Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Pickup Fail
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus | status      | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                             |
      | Pickup fail    | Pickup fail | FAIL         | PENDING        | Fail           | Pending          | Old Pickup Status: Pending\nNew Pickup Status: Fail\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Pickup fail\n\nOld Order Status: Pending\nNew Order Status: Pickup fail\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Arrived at Sorting Hub
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus         | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                       |
      | Arrived at Sorting Hub | Transit | SUCCESS      | PENDING        | Success        | Pending          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Arrived at Origin Hub
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus        | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                      |
      | Arrived at Origin Hub | Transit | SUCCESS      | PENDING        | Success        | Pending          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Arrived at Origin Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Pending Pickup at Distribution Point
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus                       | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                   |
      | Pending Pickup at Distribution Point | Pending | PENDING      | PENDING        | Pending        | Pending          | Old Granular Status: Pending Pickup\nNew Granular Status: Pending Pickup at Distribution Point\n\nReason: Status updated for testing purposes |

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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | granularStatus     | status        | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                                    |
      | Pending Reschedule | Delivery fail | SUCCESS      | FAIL           | Success        | Fail             | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Delivery Status: Pending\nNew Delivery Status: Fail\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Pending Reschedule\n\nOld Order Status: Pending\nNew Order Status: Delivery fail\n\nReason: Status updated for testing purposes |

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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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

  @DeleteRoutes
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
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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

  @DeleteRoutes
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
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
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
      | top                | Status updated |
      | waitUntilInvisible | true           |
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