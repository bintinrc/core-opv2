@OperatorV2 @Core @Inbounding @RouteInbound @RouteInboundExpectedScans @RouteInboundExpectedScansPart1
Feature: Route Inbound Expected Scans

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @happy-path @HighPriority @update-status
  Scenario: Route Inbound Expected Scans : Pending Deliveries
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName             | {ninja-driver-name}                       |
      | hubName                | {hub-name}                                |
      | routeDate              | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | parcelProcessedScans   | 0                                         |
      | parcelProcessedTotal   | 2                                         |
      | pendingDeliveriesScans | 0                                         |
      | pendingDeliveriesTotal | 2                                         |
    When Operator open Pending Deliveries dialog on Route Inbound page
    Then Operator verify Shippers Info in Pending Deliveries Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Pending Deliveries Waypoints dialog
    Then Operator verify Orders table in Pending Deliveries Waypoints dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Return) | Pending | 0        |                    |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |         | {KEY_LIST_OF_CREATED_ORDERS[2].to1LineToAddress} | Delivery (Normal) | Pending | 0        |                    |
    When Operator close Pending Deliveries dialog on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans   | 1 |
      | parcelProcessedTotal   | 2 |
      | pendingDeliveriesScans | 1 |
      | pendingDeliveriesTotal | 2 |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ROUTE INBOUND SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | hubName | {hub-name}                         |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                   |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Pending New Pickup Status: Success Old Granular Status: Pending Pickup New Granular Status: Arrived at Sorting Hub Old Order Status: Pending New Order Status: Transit Reason: HUB_INBOUND |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id}                           |
      | type    | 2                                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id} |
      | txnType        | PICKUP                                             |
      | txnStatus      | SUCCESS                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | Arrived at Sorting Hub                             |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
      | txnType        | DELIVERY                                           |
      | txnStatus      | PENDING                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | Arrived at Sorting Hub                             |


  @ArchiveRouteCommonV2 @MediumPriority @update-status
  Scenario: Route Inbound Expected Scans : Failed Deliveries (Invalid)
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":11}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 11                                                                                                  |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                      | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName                   | {ninja-driver-name}                       |
      | hubName                      | {hub-name}                                |
      | routeDate                    | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | parcelProcessedScans         | 0                                         |
      | parcelProcessedTotal         | 2                                         |
      | failedDeliveriesInvalidScans | 0                                         |
      | failedDeliveriesInvalidTotal | 1                                         |
    When Operator open Failed Deliveries Invalid dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Deliveries Invalid Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Deliveries Invalid Waypoints dialog
    Then Operator verify Orders table in Failed Deliveries Invalid Waypoints dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |         | {KEY_LIST_OF_CREATED_ORDERS[2].to1LineToAddress} | Delivery (Normal) | Failed | 1        |                    |
    When Operator close Failed Deliveries Invalid dialog on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans         | 1 |
      | parcelProcessedTotal         | 2 |
      | failedDeliveriesInvalidScans | 1 |
      | failedDeliveriesInvalidTotal | 1 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ROUTE INBOUND SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | hubName | {hub-name}                         |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                   |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Fail New Delivery Status: Pending Old Granular Status: Pending Reschedule New Granular Status: Arrived at Sorting Hub Old Order Status: Delivery fail New Order Status: Transit Reason: RESCHEDULE_ORDER |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | hubId   | {hub-id}                           |
      | type    | 2                                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_NEW_TRANSACTION"
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_DD_NEW_TRANSACTION.id}                |
      | txnType        | DELIVERY                                   |
      | txnStatus      | PENDING                                    |
      | dnrId          | 0                                          |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | granularStatus | Arrived at Sorting Hub                     |

  @ArchiveRouteCommonV2 @happy-path @MediumPriority
  Scenario: Route Inbound Expected Scans : Failed Deliveries (Valid)
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":84}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 84                                                                                                  |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                    | "{KEY_LIST_OF_CREATED_ROUTES[1].id}       |
      | driverName                 | {ninja-driver-name}                       |
      | hubName                    | {hub-name}                                |
      | routeDate                  | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | parcelProcessedScans       | 0                                         |
      | parcelProcessedTotal       | 2                                         |
      | failedDeliveriesValidScans | 0                                         |
      | failedDeliveriesValidTotal | 1                                         |
    When Operator open Failed Deliveries Valid dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Deliveries Valid Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Deliveries Valid Waypoints dialog
    Then Operator verify Orders table in Failed Deliveries Valid Waypoints dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |         | {KEY_LIST_OF_CREATED_ORDERS[2].to1LineToAddress} | Delivery (Normal) | Failed | 0        |                    |
    When Operator close Failed Deliveries Valid dialog on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans       | 1 |
      | parcelProcessedTotal       | 2 |
      | failedDeliveriesValidScans | 1 |
      | failedDeliveriesValidTotal | 1 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "Delivery Fail" on Edit Order V2 page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ROUTE INBOUND SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | hubName | {hub-name}                         |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | hubId   | {hub-id}                           |
      | type    | 2                                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2 @happy-path @HighPriority @update-status
  Scenario: Route Inbound Expected Scans : Return Pickups
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                              |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                              |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                                                                                     |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                    |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId},{KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                      |
      | routes     | KEY_DRIVER_ROUTES                                                               |
      | jobType    | TRANSACTION                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                         |
      | jobMode    | PICK_UP                                                                         |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                      |
      | routes     | KEY_DRIVER_ROUTES                                                               |
      | jobType    | TRANSACTION                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                         |
      | jobMode    | PICK_UP                                                                         |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId               | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName            | {ninja-driver-name}                       |
      | hubName               | {hub-name}                                |
      | routeDate             | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | parcelProcessedScans  | 0                                         |
      | parcelProcessedTotal  | 2                                         |
      | c2cReturnPickupsScans | 0                                         |
      | c2cReturnPickupsTotal | 2                                         |
    When Operator open C2C Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C / Return Pickups Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                            | stampId | location                                           | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineFromAddress} | Pick Up (Return) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |         | {KEY_LIST_OF_CREATED_ORDERS[2].to1LineFromAddress} | Pick Up (Return) | Success | 0        |                    |
    When Operator close C2C / Return Pickups dialog on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans  | 1 |
      | parcelProcessedTotal  | 2 |
      | c2cReturnPickupsScans | 1 |
      | c2cReturnPickupsTotal | 2 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ROUTE INBOUND SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | hubName | {hub-name}                         |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | hubId   | {hub-id}                           |
      | type    | 2                                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: En-route to Sorting Hub New Granular Status: Arrived at Sorting Hub Reason: HUB_INBOUND |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id} |
      | txnType        | PICKUP                                             |
      | txnStatus      | SUCCESS                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}         |
      | granularStatus | Arrived at Sorting Hub                             |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id} |
      | txnType        | DELIVERY                                           |
      | txnStatus      | PENDING                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}         |
      | granularStatus | Arrived at Sorting Hub                             |


  @ArchiveRouteCommonV2 @happy-path @HighPriority
  Scenario: Route Inbound Expected Scans : Pending Return Pickups
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                              |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                      | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName                   | {ninja-driver-name}                       |
      | hubName                      | {hub-name}                                |
      | routeDate                    | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | parcelProcessedScans         | 0                                         |
      | parcelProcessedTotal         | 1                                         |
      | pendingC2cReturnPickupsScans | 0                                         |
      | pendingC2cReturnPickupsTotal | 1                                         |
    When Operator open Pending C2C Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in Pending C2C / Return Pickups Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Pending C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in Pending C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                            | stampId | location                                           | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineFromAddress} | Pick Up (Return) | Pending | 0        |                    |
    When Operator close Pending C2C / Return Pickups dialog on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans         | 1 |
      | parcelProcessedTotal         | 1 |
      | pendingC2cReturnPickupsScans | 1 |
      | pendingC2cReturnPickupsTotal | 1 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ROUTE INBOUND SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | hubName | {hub-name}                         |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id}                           |
      | type    | 2                                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2 @happy-path @HighPriority @update-status
  Scenario: Route Inbound Expected Scans : Reservation Pickups
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                               |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                 |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                |
      | jobType    | RESERVATION                                                                      |
      | jobAction  | SUCCESS                                                                          |
      | jobMode    | PICK_UP                                                                          |

    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                 | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName              | {ninja-driver-name}                       |
      | hubName                 | {hub-name}                                |
      | routeDate               | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | parcelProcessedScans    | 0                                         |
      | parcelProcessedTotal    | 1                                         |
      | reservationPickupsScans | 0                                         |
      | reservationPickupsTotal | 1                                         |
    When Operator open Reservation Pickups dialog on Route Inbound page
    And Operator close Reservation Pickups dialog on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans    | 1 |
      | parcelProcessedTotal    | 1 |
      | reservationPickupsScans | 1 |
      | reservationPickupsTotal | 1 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ROUTE INBOUND SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | hubName | {hub-name}                         |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id}                           |
      | type    | 2                                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: En-route to Sorting Hub New Granular Status: Arrived at Sorting Hub Reason: HUB_INBOUND |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
      | txnType        | DELIVERY                                           |
      | txnStatus      | PENDING                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | Arrived at Sorting Hub                             |


  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Route Inbound Expected Scans : Reservation Extra Orders
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
    And API Driver - Driver submit POD:
      | routeId                  | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | waypointId               | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | parcels                  | []                                               |
      | routes                   | KEY_DRIVER_ROUTES                                |
      | jobType                  | RESERVATION                                      |
      | jobAction                | SUCCESS                                          |
      | jobMode                  | PICK_UP                                          |
      | totalUnmanifestedParcels | 1                                                |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                 | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName              | {ninja-driver-name}                       |
      | hubName                 | {hub-name}                                |
      | routeDate               | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | reservationPickupsScans | 0                                         |
      | reservationPickupsTotal | 1                                         |
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Reservation Pickup                    |
      | reason     | ^.*Extra Order                        |
    Then Operator verify the Route Inbound Details is correct using data below:
      | reservationPickupsScans       | 0 |
      | reservationPickupsTotal       | 1 |
      | reservationPickupsExtraOrders | 1 |
    When Operator open Reservation Pickups dialog on Route Inbound page
    Then Operator verify Extra Orders record using data below:
      | trackingId  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | shipperName | {shipper-v4-name}                     |
    When Operator close Reservation Pickups dialog on Route Inbound page
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ROUTE INBOUND SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | hubName | {hub-name}                         |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id}                           |
      | type    | 2                                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
