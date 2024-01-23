@OperatorV2 @Core @Routing  @RouteMonitoringV2 @RouteMonitoringV2Part2
Feature: Route Monitoring V2

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels on NON-PRIOR Waypoints
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId                | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels           | 1                                  |
      | pendingPriorityParcels | 0                                  |
    When Operator open Pending Priority modal of a route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Monitoring V2 page
    Then Operator check there are 0 Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page
    And Operator check there are 0 Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page

  @ArchiveRouteCommonV2 @CloseNewWindows @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup & Delivery Under the Same Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
     When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId                | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels           | 2                                  |
      | totalWaypoint          | 2                                  |
      | pendingPriorityParcels | 2                                  |
    When Operator open Pending Priority modal of a route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Monitoring V2 page
    Then Operator check there are 1 Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page
    And Operator verify Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}   |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
    Then Operator close current window and switch to Route Monitoring V2 page
    Then Operator check there are 1 Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page
    And Operator verify Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[2].toName}     |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}         |

  @ArchiveRouteCommonV2 @CloseNewWindows @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order Has PRIOR Tag
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":11}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 11                                                                                                  |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":11}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 11                                                                                                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 2                                  |
      | completionPercentage | 0                                  |
      | totalWaypoint        | 2                                  |
      | numInvalidFailed     | 2                                  |
      | numValidFailed       | 0                                  |
    When Operator open Invalid Failed WP modal of a route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Monitoring V2 page
    Then Operator check there are 2 Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | tags         | PRIOR                                      |
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[2].toName}     |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}         |

  @ArchiveRouteCommonV2 @CloseNewWindows @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order with NO Tags
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":11}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 11                                                                                                  |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":11}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 11                                                                                                  |
     When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 2                                  |
      | completionPercentage | 0                                  |
      | totalWaypoint        | 2                                  |
      | numInvalidFailed     | 2                                  |
      | numValidFailed       | 0                                  |
    When Operator open Invalid Failed WP modal of a route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Monitoring V2 page
    Then Operator check there are 2 Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | tags         | -                                          |
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[2].toName}     |
      | tags         | -                                          |
    When Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}         |

  @ArchiveRouteCommonV2 @CloseNewWindows @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order Has PRIOR Tag
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":112}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 112                                                                                                  |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":112}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 112                                                                                                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 2                                  |
      | completionPercentage | 0                                  |
      | totalWaypoint        | 2                                  |
      | numInvalidFailed     | 2                                  |
      | numValidFailed       | 0                                  |
    When Operator open Invalid Failed WP modal of a route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Monitoring V2 page
    Then Operator check there are 2 Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}   |
      | tags         | PRIOR                                      |
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[2].fromName}   |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}         |

  @ArchiveRouteCommonV2 @CloseNewWindows @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order with NO Tags
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":112}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 112                                                                                                  |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":112}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 112                                                                                                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 2                                  |
      | completionPercentage | 0                                  |
      | totalWaypoint        | 2                                  |
      | numInvalidFailed     | 2                                  |
      | numValidFailed       | 0                                  |
    When Operator open Invalid Failed WP modal of a route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Monitoring V2 page
    Then Operator check there are 2 Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}   |
      | tags         | -                                          |
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[2].fromName}   |
      | tags         | -                                          |
    When Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}         |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed on NON-Failed Waypoints
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 1                                  |
      | completionPercentage | 0                                  |
      | totalWaypoint        | 1                                  |
      | numInvalidFailed     | 0                                  |
      | numValidFailed       | 0                                  |
    When Operator open Invalid Failed WP modal of a route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Monitoring V2 page
    Then Operator check there are 0 Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 0 Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 0 Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page

  @ArchiveRouteCommonV2 @CloseNewWindows @happy-path @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Waypoints - Pickup, Delivery & Reservation Under the Same Route
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":112}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 112                                                                                                  |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":11}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 11                                                                                                  |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                  |
      | routes          | KEY_DRIVER_ROUTES                                                                                                 |
      | jobType         | RESERVATION                                                                                                       |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[3]}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | jobAction       | FAIL                                                                                                              |
      | jobMode         | PICK_UP                                                                                                           |
      | failureReasonId | 112                                                                                                               |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId          | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalWaypoint    | 3                                  |
      | numInvalidFailed | 3                                  |
    When Operator open Invalid Failed WP modal of a route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Monitoring V2 page
    Then Operator check there are 1 Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 1 Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 1 Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[2].toName}     |
      | tags         | -                                          |
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}   |
      | tags         | -                                          |

  @ArchiveRouteCommonV2 @CloseNewWindows @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Reservation
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                  |
      | routes          | KEY_DRIVER_ROUTES                                                                                                 |
      | jobType         | RESERVATION                                                                                                       |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | jobAction       | FAIL                                                                                                              |
      | jobMode         | PICK_UP                                                                                                           |
      | failureReasonId | 112                                                                                                               |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    And Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId          | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels     | 1                                  |
      | totalWaypoint    | 2                                  |
      | numInvalidFailed | 1                                  |
    When Operator open Invalid Failed WP modal of a route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Monitoring V2 page
    Then Operator check there are 1 Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page

  @ArchiveRouteCommonV2 @DeleteDriverV2 @HighPriority
  Scenario: Show Updated Driver Name & Hub in Route Monitoring V2
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name-2}                       |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | driverName | {ninja-driver-name}                |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY    |
      | routeDateTo   | TODAY        |
      | hubName       | {hub-name-2} |
    And Operator edits details of created route using data below:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}      |
      | date       | {date: 0 days next, yyyy-MM-dd}         |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name}                             |
      | hub        | {hub-name}                              |
      | driverName | {ninja-driver-2-name}                   |
      | comments   | Route has been edited by automated test |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | driverName | {ninja-driver-2-name}              |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
