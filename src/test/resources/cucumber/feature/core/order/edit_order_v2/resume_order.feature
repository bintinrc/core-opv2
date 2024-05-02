@OperatorV2 @Core @EditOrderV2 @ResumeOrder
Feature: Resume Order

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path @HighPriority @update-status
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Pickup Cancelled, Delivery Cancelled
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Cancelled                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator resume order on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top    | 1 order(s) resumed                          |
      | bottom | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                       |
      | MANUAL ACTION | RESUME        |                                                                                                                                                                                                                                                                   |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Cancelled New Pickup Status: Pending Old Delivery Status: Cancelled New Delivery Status: Pending Old Granular Status: Cancelled New Granular Status: Pending Pickup Old Order Status: Cancelled New Order Status: Pending Reason: RESUME_ORDER |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | dnrId           | 0                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | routeId  | null                         |
      | seqNo    | null                         |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | PICKUP                                     |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | dnrId           | 0                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | routeId  | null                         |
      | seqNo    | null                         |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |

  @MediumPriority
  Scenario: Operator Resume an Order on Edit Order page - Non-Cancelled Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator verify menu item "Order Settings" > "Resume Order" is disabled on Edit Order V2 page
    When API Core - resume order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Success              |
      | dnrId  | 0                    |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Pending              |
      | dnrId  | 0                    |

  @ArchiveRouteCommonV2 @HighPriority @update-status
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Return Pickup Fail With Waypoint
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
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    When Operator resume order on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top    | 1 order(s) resumed                          |
      | bottom | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                  |
      | MANUAL ACTION | RESUME        |                                                                                                                                                                                                                                                              |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Fail New Pickup Status: Pending Old Delivery Status: Cancelled New Delivery Status: Pending Old Granular Status: Cancelled New Granular Status: Pending Pickup Old Order Status: Cancelled New Order Status: Pending Reason: RESUME_ORDER |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | status          | Pending                     |
      | dnrId           | 0                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | status   | Pending                      |
      | routeId  | null                         |
      | seqNo    | null                         |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | PICKUP                                     |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | status          | Pending                     |
      | dnrId           | 0                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | status   | Pending                      |
      | routeId  | null                         |
      | seqNo    | null                         |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Delivery is Not Cancelled
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_TRANSACTION.waypointId}                                                                        |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    And API Core - force cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    When Operator resume order on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top    | 1 order(s) resumed                          |
      | bottom | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                           |
      | MANUAL ACTION | RESUME        |                                                                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Cancelled New Pickup Status: Pending Old Granular Status: Cancelled New Granular Status: Pending Pickup Old Order Status: Cancelled New Order Status: Pending Reason: RESUME_ORDER |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | status          | Pending                     |
      | dnrId           | 0                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
    And DB Routing Search - verify transactions record is hard deleted:
      | txnId   | {KEY_TRANSACTION.id} |
      | txnType | PICKUP               |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | status          | Fail                        |
      | dnrId           | 2                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | FAIL                                       |
      | dnrId           | 2                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |

  #  TODO Uncomment the verification step when bug ticket ROUTE-1367 is solved
  @MediumPriority @update-status
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Return Pickup Fail With NO Waypoint
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Pickup fail                        |
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    When Operator resume order on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top    | 1 order(s) resumed                          |
      | bottom | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                  |
      | MANUAL ACTION | RESUME        |                                                                                                                                                                                                                                                              |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Fail New Pickup Status: Pending Old Delivery Status: Cancelled New Delivery Status: Pending Old Granular Status: Cancelled New Granular Status: Pending Pickup Old Order Status: Cancelled New Order Status: Pending Reason: RESUME_ORDER |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | status          | Pending                     |
      | dnrId           | 0                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
#    And DB Routing Search - verify transactions record is hard deleted:
#      | txnId   | {KEY_TRANSACTION.id} |
#      | txnType | PICKUP               |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | status          | Pending                     |
      | dnrId           | 0                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | routeId  | null                         |
      | seqNo    | null                         |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |
