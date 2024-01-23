@OperatorV2 @Core @Routing  @RouteMonitoringV2 @RouteMonitoringV2Part3
Feature: Route Monitoring V2

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Reservation
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels | 0                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Reservation
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                  |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                    |
      | routes     | KEY_DRIVER_ROUTES                                                                                                   |
      | jobType    | RESERVATION                                                                                                         |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","shipper_id":{shipper-v4-legacy-id},"action": "SUCCESS"}] |
      | jobAction  | SUCCESS                                                                                                             |
      | jobMode    | PICK_UP                                                                                                             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | successCount | 1                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Reservation - <name>
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | routes          | KEY_DRIVER_ROUTES                                |
      | jobType         | RESERVATION                                      |
      | parcels         | []                                               |
      | jobAction       | FAIL                                             |
      | jobMode         | PICK_UP                                          |
      | failureReasonId | <failureReasonCodeId>                            |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId          | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | numValidFailed   | <numValidFailed>                   |
      | numInvalidFailed | <numInvalidFailed>                 |
    Examples:
      | name         | failureReasonCodeId | numValidFailed | numInvalidFailed |
      | Valid Fail   | 8                   | 1              | 0                |
      | Invalid Fail | 112                 | 0              | 1                |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Reservation
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalWaypoint | 1                                  |
      | pendingCount  | 1                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending Reservation From Route
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Core - Operator remove reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" from route
    And DB Core - verify waypoints record:
      | id      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | status  | Pending                                          |
      | routeId | null                                             |
      | seqNo   | null                                             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalWaypoint | 0                                  |
      | pendingCount  | 0                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery Transactions
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+6595557073 ","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels  | 2                                  |
      | totalWaypoint | 1                                  |
      | pendingCount  | 1                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Pickup Transactions
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+6595557073 ","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator verifies "Pickup" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels  | 2                                  |
      | totalWaypoint | 1                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery & Pickup Transactions
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+6595557073 ","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+6595557073 ","email": "binti@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[4].id} |
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Core - Operator verifies "Pickup" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[4].id} |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[1].waypointId} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels  | 4                                  |
      | totalWaypoint | 2                                  |
      | pendingCount  | 2                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending Delivery From Route
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
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalParcels         | 1                                  |
      | completionPercentage | 0                                  |
      | totalWaypoint        | 1                                  |
      | pendingCount         | 1                                  |
      | successCount         | 0                                  |
      | numInvalidFailed     | 0                                  |
      | numValidFailed       | 0                                  |
    When API Core - Operator pull order from route:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | DELIVERY                           |
    And DB Core - verify waypoints record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status  | Pending                                                    |
      | routeId | null                                                       |
      | seqNo   | null                                                       |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalWaypoint | 0                                  |
      | pendingCount  | 0                                  |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending Pickup From Route
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
      | pendingCount         | 1                                  |
      | successCount         | 0                                  |
      | numInvalidFailed     | 0                                  |
      | numValidFailed       | 0                                  |
    When API Core - Operator pull order from route:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | PICKUP                             |
    And DB Core - verify waypoints record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | status  | Pending                                                    |
      | routeId | null                                                       |
      | seqNo   | null                                                       |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring"
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                         |
      | zones   | {zone-name}                        |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | totalWaypoint | 0                                  |
      | pendingCount  | 0                                  |
