@OperatorV2 @Core @AllOrders @RtsandResume
Feature: All Orders - RTS & Resume

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator RTS Failed Delivery Order on All Orders Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    Given API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                 |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                         |
      | routes          | KEY_DRIVER_ROUTES                                                                                  |
      | jobType         | TRANSACTION                                                                                        |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":5}] |
      | jobAction       | FAIL                                                                                               |
      | jobMode         | DELIVERY                                                                                           |
      | failureReasonId | 5                                                                                                  |
      | globalShipperId | {shipper-v4-id}                                                                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders V2 page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator unmask All Orders V2 page
    Then Operator verify all orders in CSV is found on All Orders V2 page with correct info
    And Operator RTS multiple orders on next day on All Orders Page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator unmask edit order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE CONTACT INFORMATION |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | status          | Pending                     |
      | dnrId           | 0                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | rts             | 1                                          |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | En-route to Sorting Hub                    |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |

  @ArchiveRouteCommonV2 @happy-path @HighPriority
  Scenario: Operator RTS Multiple Orders on All Orders Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator go to menu Order -> All Orders
    When Operator find orders by uploading CSV on All Orders V2 page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator RTS multiple orders on next day on All Orders Page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE CONTACT INFORMATION |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE CONTACT INFORMATION |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | rts | 1                                  |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}        |
      | status          | Pending                     |
      | dnrId           | 0                           |
      | startTimeCustom | {KEY_TRANSACTION.startTime} |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}   |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | rts             | 1                                          |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Arrived at Sorting Hub                     |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |

  @HighPriority @update-status
  Scenario: Operator Resume Selected Cancelled Order on All Orders Page - Single Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator go to menu Order -> All Orders
    When Operator resume this order "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" on All Orders page
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESUME |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Cancelled New Pickup Status: Pending Old Delivery Status: Cancelled New Delivery Status: Pending Old Granular Status: Cancelled New Granular Status: Pending Pickup Old Order Status: Cancelled New Order Status: Pending Reason: RESUME_ORDER |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
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
      | status   | Pending                      |
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
      | routeId  | null                         |
      | seqNo    | null                         |
      | status   | Pending                      |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |


  @happy-path @update-status @HighPriority
  Scenario: Operator Resume Selected Cancelled Order on All Orders Page - Multiple Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator go to menu Order -> All Orders
    When Operator resume multiple orders on All Orders page below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESUME |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Cancelled New Pickup Status: Pending Old Delivery Status: Cancelled New Delivery Status: Pending Old Granular Status: Cancelled New Granular Status: Pending Pickup Old Order Status: Cancelled New Order Status: Pending Reason: RESUME_ORDER |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESUME |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
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
      | status   | Pending                      |
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
      | routeId  | null                         |
      | seqNo    | null                         |
      | status   | Pending                      |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
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
      | status   | Pending                      |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | PICKUP                                     |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
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
      | status   | Pending                      |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |

  @MediumPriority
  Scenario: Operator RTS Multiple Orders with Invalid Granular Status
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Completed                          |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | Cancelled                          |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | granularStatus | Returned To Sender                 |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders V2 page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId} |
    And Operator select 'Set RTS to Selected' action for found orders on All Orders page
    Then Operator verify "Return to Sender" process in Selection Error dialog on All Orders page
    And Operator verify orders info in Selection Error dialog on All Orders page:
      | trackingId                                 | reason                   |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | Invalid status to change |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | Invalid status to change |
      | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId} | Invalid status to change |
    When Operator clicks Continue button in Selection Error dialog on All Orders page
    Then Operator verifies that error toast displayed:
      | top    | Unable to apply actions |
      | bottom | No valid selection      |
    Then API Core - Verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus | COMPLETED                                  |
    Then API Core - Verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | granularStatus | CANCELLED                                  |
    Then API Core - Verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId} |
      | granularStatus | RETURNED_TO_SENDER                         |
