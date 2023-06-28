@OperatorV2 @Core @EditOrder @ForceSuccess @ForceSuccessPart1 @EditOrder2
Feature: Force Success

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
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

  @DeleteOrArchiveRoute
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

  @DeleteOrArchiveRoute
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

  Scenario: Show Force Success Order Event Details for Manual Complete Edit Order Page  - Without RTS
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
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |

  Scenario: Show Force Success Order Event Details for Manual Complete Edit Order Page  - With RTS Normal Parcel
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
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          | tags          | description                                                                                                                                                           |
      | UPDATE STATUS | MANUAL ACTION | Old Granular Status: Arrived at Sorting Hub New Granular Status: Returned to Sender\n\nOld Order Status: Transit New Order Status: Completed\n\nReason: FORCE_SUCCESS |

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

  Scenario Outline: Operator Force Success Order by Select Reason on Edit Order Page - <reason>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason | <reason> |
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
      | name | PRICING CHANGE |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           | tags          | description                                                                                                                                           |
      | UPDATE STATUS  | MANUAL ACTION | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |
      | FORCED SUCCESS | MANUAL ACTION | <description>                                                                                                                                         |
    Examples:
      | reason                                | description                                                                                                                                                                                                                                             |
      | 3PL completed delivery                | Reason: 3PL completed delivery RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                |
      | Fraudulent parcels / Prohibited items | Reason: Fraudulent parcels / Prohibited items RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |
      | Requested by shipper                  | Reason: Requested by shipper RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                  |
      | Lazada returns                        | Reason: Lazada returns RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                        |
      | XB fulfilment storage                 | Reason: XB fulfilment storage RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                 |

  Scenario: Operator Force Success Order by Input Reason on Edit Order Page
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
      | name           | tags          | description                                                                                                                                                                                                                                                                     |
      | UPDATE STATUS  | MANUAL ACTION | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS                                                                                                                           |
      | FORCED SUCCESS | MANUAL ACTION | Reason: Other - Completed by AT {gradle-current-date-yyyyMMddHHmmsss} RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |

  Scenario: Disable Force Success On Hold Order with Active PETS Ticket
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Hold                            |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify menu item "Order Settings" > "Manually Complete Order" is disabled on Edit Order V2 page

  Scenario: Show Force Success Order Event Details for Manual Complete Edit Order Page - Resolved PETS Ticket
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | DAMAGED                               |
      | orderOutcomeName   | ORDER OUTCOME (NEW_DAMAGED)           |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | status           | RESOLVED                         |
      | orderOutcomeName | ORDER OUTCOME (DAMAGED)          |
      | customFieldId    | 24292071                         |
      | outcome          | NV NOT LIABLE - PARCEL DELIVERED |
      | reporterId       | {ticketing-creator-user-id}      |
      | reporterName     | {ticketing-creator-user-name}    |
      | reporterEmail    | {ticketing-creator-user-email}   |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
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
      | status | Pending              |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           | tags          | description                                                                                                                                                                                                                                 |
      | UPDATE STATUS  | MANUAL ACTION | Old Granular Status: On Hold New Granular Status: Arrived at Sorting Hub Old Order Status: On Hold New Order Status: Transit Reason: TICKET_RESOLUTION                                                                                      |
      | FORCED SUCCESS | MANUAL ACTION | Reason: TICKET_RESOLUTION RTS: false Old Order Status: Transit New Order Status: Completed Old Order Granular Status: Arrived at Sorting Hub New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |

  Scenario: Show Force Success Order Event Details for Manual Complete Edit Order Page - With RTS PETS Ticket
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | PARCEL ON HOLD                        |
      | subTicketType      | SHIPPER REQUEST                       |
      | orderOutcomeName   | ORDER OUTCOME (SHIPPER REQUEST)       |
      | outcome            | RTS                                   |
      | rtsCustomFieldId   | 24292253                              |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | status           | RESOLVED                         |
      | orderOutcomeName | ORDER OUTCOME (SHIPPER_REQUEST)  |
      | customFieldId    | 24292291                         |
      | outcome          | RTS                              |
      | rtsCustomFieldId | 24292293                         |
      | reporterId       | {ticketing-creator-user-id}      |
      | reporterName     | {ticketing-creator-user-name}    |
      | reporterEmail    | {ticketing-creator-user-email}   |
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
      | status | Pending              |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           | tags          | description                                                                                                                                                                                                                                                                                     |
      | UPDATE STATUS  | MANUAL ACTION | Old Granular Status: Arrived at Sorting Hub New Granular Status: Returned to Sender Old Order Status: Transit New Order Status: Completed Reason: FORCE_SUCCESS                                                                                                                                 |
      | FORCED SUCCESS | MANUAL ACTION | Reason: Other - Completed by AT {gradle-current-date-yyyyMMddHHmmsss} RTS: true Old Order Status: Transit New Order Status: Completed Old Order Granular Status: Arrived at Sorting Hub New Order Granular Status: Returned to Sender Old Delivery Status: Pending New Delivery Status: Success |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op