@OperatorV2 @Core @Routing  @RouteManifest @RouteManifestPart1
Feature: Route Manifest

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority
  Scenario: Operator Load Route Manifest of a Driver Success Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    |expectedWaypointIds| {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}  |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                      |
      | routes     | KEY_DRIVER_ROUTES                                                               |
      | jobType    | TRANSACTION                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                         |
      | jobMode    | DELIVERY                                                                        |
      | globalShipperId | {shipper-v4-id} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 0       | 1       | 0       | 1   |
      | Total      | 0       | 1       | 0       | 1   |
    And Operator verify Route summary Waypoint type on Route Manifest page:
      |        | Pending | Success | Failure | All |
      | Normal | 0       | 1       | 0       | 1   |
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Success                               |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  @HighPriority
  Scenario: Operator Load Route Manifest of a Driver Failed Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                 |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                         |
      | routes          | KEY_DRIVER_ROUTES                                                                                  |
      | jobType         | TRANSACTION                                                                                        |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":6}] |
      | jobAction       | FAIL                                                                                               |
      | jobMode         | DELIVERY                                                                                           |
      | failureReasonId | 6                                                                                                  |
      | globalShipperId | {shipper-v4-id} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 0       | 0       | 1       | 1   |
      | Total      | 0       | 0       | 1       | 1   |
    And Operator verify Route summary Waypoint type on Route Manifest page:
      |        | Pending | Success | Failure | All |
      | Normal | 0       | 0       | 1       | 1   |
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Fail                                  |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  @happy-path @HighPriority @update-status
  Scenario: Operator Admin Manifest Force Fail Pickup Transaction on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator verify Route summary Parcel count on Route Manifest page:
      |         | Pending | Success | Failure | All |
      | Pickups | 1       | 0       | 0       | 1   |
      | Total   | 1       | 0       | 0       | 1   |
    And Operator fail pickup waypoint from Route Manifest page
      | failureReasonDescription    | I didn't attempt the pick up - Return |
      | failureReasonSubDescription | Cannot Make It (CMI) - Return         |
      | replace                     | - Return                              |
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} successfully |
    And Operator refresh page
    And Operator verify Route summary Parcel count on Route Manifest page:
      |         | Pending | Success | Failure | All |
      | Pickups | 0       | 0       | 1       | 1   |
      | Total   | 0       | 0       | 1       | 1   |
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Fail                                  |
      | deliveriesCount | 0                                     |
      | pickupsCount    | 1                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | comments        | {KEY_SELECTED_FAILURE_REASON}         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pickup fail |
      | granularStatus | Pickup fail |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | FAIL |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | status   | Fail                                                       |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status   | Pending                                                    |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | FORCED FAILURE         |
      | description | Failure reason ID: 131 |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Pending New Pickup Status: Fail Old Granular Status: Van en-route to pickup New Granular Status: Pickup fail Old Order Status: Transit New Order Status: Pickup fail Reason: ADMIN_UPDATE_WAYPOINT |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id} |
      | txnType        | PICKUP                                             |
      | txnStatus      | FAIL                                               |
      | dnrId          | 2                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | Pickup fail                                        |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
      | txnStatus      | PENDING                                            |
      | txnType        | DELIVERY                                           |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | Pickup fail                                        |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @happy-path @HighPriority @update-status
  Scenario: Operator Admin Manifest Force Success Pickup Transaction on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator verify Route summary Parcel count on Route Manifest page:
      |         | Pending | Success | Failure | All |
      | Pickups | 1       | 0       | 0       | 1   |
      | Total   | 1       | 0       | 0       | 1   |
    And Operator success pickup waypoint from Route Manifest page
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} successfully |
    And Operator refresh page
    And Operator verify Route summary Parcel count on Route Manifest page:
      |         | Pending | Success | Failure | All |
      | Pickups | 0       | 1       | 0       | 1   |
      | Total   | 0       | 1       | 0       | 1   |
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Success                               |
      | deliveriesCount | 0                                     |
      | pickupsCount    | 1                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | status   | Success                                                    |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status   | Pending                                                    |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Pending New Pickup Status: Success Old Granular Status: Van en-route to pickup New Granular Status: En-route to Sorting Hub Reason: ADMIN_UPDATE_WAYPOINT |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id} |
      | txnType        | PICKUP                                             |
      | txnStatus      | SUCCESS                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | En-route to Sorting Hub                            |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
      | txnType        | DELIVERY                                           |
      | txnStatus      | PENDING                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | En-route to Sorting Hub                            |

  @happy-path @HighPriority @update-status
  Scenario: Operator Admin Manifest Force Fail Delivery Transaction on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                  |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY "} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 1       | 0       | 0       | 1   |
      | Total      | 1       | 0       | 0       | 1   |
    And Operator fail delivery waypoint from Route Manifest page
      | failureReasonDescription    | Attempting failure at doorstep - Normal     |
      | failureReasonSubDescription | Non-residential location is closed - Normal |
      | replace                     | - Normal                                    |
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} successfully |
    And Operator refresh page
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 0       | 0       | 1       | 1   |
      | Total      | 0       | 0       | 1       | 1   |
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Fail                                  |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | comments        | {KEY_SELECTED_FAILURE_REASON}         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | FAIL |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status   | Fail                                                       |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | FORCED FAILURE          |
      | description | Failure reason ID: 2767 |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                        |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Pending New Delivery Status: Fail Old Granular Status: Arrived at Sorting Hub New Granular Status: Pending Reschedule Old Order Status: Transit New Order Status: Delivery fail Reason: ADMIN_UPDATE_WAYPOINT |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
      | txnStatus      | FAIL                                               |
      | txnType        | DELIVERY                                           |
      | dnrId          | 2                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | Pending Reschedule                                 |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @happy-path @HighPriority @update-status
  Scenario: Operator Admin Manifest Force Success Delivery Transaction on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                  |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY "} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 1       | 0       | 0       | 1   |
      | Total      | 1       | 0       | 0       | 1   |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success delivery waypoint from Route Manifest page
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} successfully |
    And Operator refresh page
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 0       | 1       | 0       | 1   |
      | Total      | 0       | 1       | 0       | 1   |
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Success                               |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status   | Success                                                    |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                              |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Pending New Delivery Status: Success Old Granular Status: Arrived at Sorting Hub New Granular Status: Completed Old Order Status: Transit New Order Status: Completed Reason: ADMIN_UPDATE_WAYPOINT |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
      | txnType        | DELIVERY                                           |
      | txnStatus      | SUCCESS                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | Completed                                          |

