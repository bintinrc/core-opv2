@OperatorV2 @Core @EditOrderV2 @ForceSuccess @ForceSuccessPart1
Feature: Force Success

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Force Success Order on Edit Order Page - End State = Completed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason          | Others (fill in below)                                |
      | reasonForChange | Completed by AT {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that success react notification displayed:
      | top                | The order has been completed |
      | waitUntilInvisible | true                         |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |

  Scenario: Operator Force Success Order on Edit Order Page - End State = Returned to Sender
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason          | Others (fill in below)                                |
      | reasonForChange | Completed by AT {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that success react notification displayed:
      | top                | The order has been completed |
      | waitUntilInvisible | true                         |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed          |
      | granularStatus | Returned to Sender |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Arrived at Sorting Hub New Granular Status: Returned to Sender\n\nOld Order Status: Transit New Order Status: Completed\n\nReason: FORCE_SUCCESS |

  Scenario: Operator Force Success Order on Edit Order Page - Unrouted Order with COD - Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason          | Others (fill in below)                                |
      | reasonForChange | Completed by AT {gradle-current-date-yyyyMMddHHmmsss} |
      | markAll         | true                                                  |
    Then Operator verifies that success react notification displayed:
      | top                | The order has been completed |
      | waitUntilInvisible | true                         |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION.id} |
      | status | Success                 |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION.waypointId} |
      | status | Success                         |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_DD_TRANSACTION.waypointId} |
      | collectedSum | 23.57                           |
      | driverId     | null                            |

  @ArchiveRouteCommonV2
  Scenario: Operator Force Success Order on Edit Order page - Routed Order Delivery with COD - Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason          | Others (fill in below)                                |
      | reasonForChange | Completed by AT {gradle-current-date-yyyyMMddHHmmsss} |
      | markAll         | true                                                  |
    Then Operator verifies that success react notification displayed:
      | top                | The order has been completed |
      | waitUntilInvisible | true                         |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION.id} |
      | status | Success                 |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION.waypointId} |
      | status | Success                         |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_DD_TRANSACTION.waypointId} |
      | collectedSum | 23.57                           |
      | driverId     | {ninja-driver-id}               |

  Scenario: Operator Force Success Order on Edit Order Page - Unrouted Order with COD - Do not Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason          | Others (fill in below)                                |
      | reasonForChange | Completed by AT {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that success react notification displayed:
      | top                | The order has been completed |
      | waitUntilInvisible | true                         |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION.id} |
      | status | Success                 |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION.waypointId} |
      | status | Success                         |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_DD_TRANSACTION.waypointId} |
      | collectedSum | 0                               |
      | driverId     | null                            |

  @ArchiveRouteCommonV2
  Scenario: Operator Force Success Order on Edit Order page - Routed Order Delivery with COD - Do not Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason          | Others (fill in below)                                |
      | reasonForChange | Completed by AT {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that success react notification displayed:
      | top                | The order has been completed |
      | waitUntilInvisible | true                         |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION.id} |
      | status | Success                 |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION.waypointId} |
      | status | Success                         |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_DD_TRANSACTION.waypointId} |
      | collectedSum | 0                               |
      | driverId     | {ninja-driver-id}               |

  Scenario: Operator Force Success Order on Edit Order Page - RTS with COD - Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    Then Operator verify 'COD Collected' checkbox is disabled in Manually complete order dialog on Edit Order V2 page
    And Operator verify Complete order button is disabled in Manually complete order dialog on Edit Order V2 page

  Scenario: Operator Force Success Order on Edit Order Page - RTS with COD - Do not Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    Then Operator verify 'COD Collected' checkbox is disabled in Manually complete order dialog on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason          | Others (fill in below)                                |
      | reasonForChange | Completed by AT {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that success react notification displayed:
      | top                | The order has been completed |
      | waitUntilInvisible | true                         |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed          |
      | granularStatus | Returned to Sender |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION.id} |
      | status | Success                 |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION.waypointId} |
      | status | Success                         |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Arrived at Sorting Hub New Granular Status: Returned to Sender\n\nOld Order Status: Transit New Order Status: Completed\n\nReason: FORCE_SUCCESS |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_DD_TRANSACTION.waypointId} |
      | collectedSum | 0                               |
      | driverId     | null                            |

  @happy-path
  Scenario: Operator Manually Complete Order on Edit Order Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason          | Others (fill in below)                                |
      | reasonForChange | Completed by AT {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that success react notification displayed:
      | top                | The order has been completed |
      | waitUntilInvisible | true                         |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |
