@OperatorV2 @Core @Routing  @RouteMonitoringV2 @RouteMonitoringV2Part1
Feature: Route Monitoring V2

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Single Transaction
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
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels | 1                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Multiple Transactions
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels | 3                                  |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Empty Route
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 0                                  |
      | completionPercentage | 0                                  |
      | totalWaypoint        | 0                                  |
      | pendingCount         | 0                                  |
      | numLateAndPending    | 0                                  |
      | successCount         | 0                                  |
      | numInvalidFailed     | 0                                  |
      | numValidFailed       | 0                                  |
      | earlyCount           | 0                                  |
      | lateCount            | 0                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 1                                  |
      | completionPercentage | 0                                  |
      | totalWaypoint        | 1                                  |
      | pendingCount         | 1                                  |
      | successCount         | 0                                  |
      | numInvalidFailed     | 0                                  |
      | numValidFailed       | 0                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Delivery
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
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 1                                  |
      | completionPercentage | 0                                  |
      | totalWaypoint        | 1                                  |
      | pendingCount         | 1                                  |
      | successCount         | 0                                  |
      | numInvalidFailed     | 0                                  |
      | numValidFailed       | 0                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Route - set tags to route:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | tagIds  | {route-tag-id}                     |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                      |
      | routes     | KEY_DRIVER_ROUTES                                                               |
      | jobType    | TRANSACTION                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                         |
      | jobMode    | DELIVERY                                                                        |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 1                                  |
      | completionPercentage | 100                                |
      | totalWaypoint        | 1                                  |
      | pendingCount         | 0                                  |
      | numLateAndPending    | 0                                  |
      | successCount         | 1                                  |
      | numInvalidFailed     | 0                                  |
      | numValidFailed       | 0                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                      |
      | routes     | KEY_DRIVER_ROUTES                                                               |
      | jobType    | TRANSACTION                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                         |
      | jobMode    | PICK_UP                                                                         |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 1                                  |
      | completionPercentage | 100                                |
      | totalWaypoint        | 1                                  |
      | pendingCount         | 0                                  |
      | numLateAndPending    | 0                                  |
      | successCount         | 1                                  |
      | numInvalidFailed     | 0                                  |
      | numValidFailed       | 0                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Delivery - <type>
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
    And API Route - set tags to route:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | tagIds  | {route-tag-id}                     |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                             |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobType         | TRANSACTION                                                                                                            |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":<failureReasonCodeId>}] |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | DELIVERY                                                                                                               |
      | failureReasonId | <failureReasonCodeId>                                                                                                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 1                                  |
      | completionPercentage | <completionPercentage>             |
      | totalWaypoint        | 1                                  |
      | pendingCount         | 0                                  |
      | numLateAndPending    | 0                                  |
      | successCount         | 0                                  |
      | numInvalidFailed     | <numInvalidFailed>                 |
      | numValidFailed       | <numValidFailed>                   |
    Examples:
      | type           | failureReasonCodeId | completionPercentage | numInvalidFailed | numValidFailed |
      | Valid Failed   | 2                   | 100                  | 0                | 1              |
      | Invalid Failed | 11                  | 0                    | 1                | 0              |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Pickup - <type>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                             |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobType         | TRANSACTION                                                                                                            |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":<failureReasonCodeId>}] |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | PICK_UP                                                                                                                |
      | failureReasonId | <failureReasonCodeId>                                                                                                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 1                                  |
      | completionPercentage | <completionPercentage>             |
      | totalWaypoint        | 1                                  |
      | pendingCount         | 0                                  |
      | numLateAndPending    | 0                                  |
      | successCount         | 0                                  |
      | numInvalidFailed     | <numInvalidFailed>                 |
      | numValidFailed       | <numValidFailed>                   |
    Examples:
      | type           | failureReasonCodeId | completionPercentage | numInvalidFailed | numValidFailed |
      | Valid Failed   | 7                   | 100                  | 0                | 1              |
      | Invalid Failed | 112                 | 0                    | 1                | 0              |

  @ArchiveRouteCommonV2 @CloseNewWindows @happy-path @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup
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
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
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
    Then Operator check there are 2 Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page
    And Operator verify Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}   |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}         |

  @ArchiveRouteCommonV2 @CloseNewWindows @happy-path @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/route-monitoring-paged"
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
    Then Operator check there are 2 Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page
    And Operator verify Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | customerName | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}         |
