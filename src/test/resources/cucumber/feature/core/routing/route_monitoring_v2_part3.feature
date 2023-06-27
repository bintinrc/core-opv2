@OperatorV2 @Core @Routing @RoutingJob3 @RouteMonitoringV2 @RouteMonitoringV2Part3
Feature: Route Monitoring V2

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Reservation
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Reservation
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | successCount | 1                      |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Reservation - <name>
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance           |
      | failureReasonCodeId    | <failureReasonCodeId> |
      | failureReasonIndexMode | FIRST                 |
    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId          | {KEY_CREATED_ROUTE_ID} |
      | numValidFailed   | <numValidFailed>       |
      | numInvalidFailed | <numInvalidFailed>     |
    Examples:
      | name         | failureReasonCodeId | numValidFailed | numInvalidFailed |
      | Valid Fail   | 8                   | 1              | 0                |
      | Invalid Fail | 9                   | 0              | 1                |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Reservation
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalWaypoint | 1                      |
      | pendingCount  | 1                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending Reservation From Route
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Core - Operator remove reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" from route
    And DB Operator verifies "{KEY_CREATED_RESERVATION.waypointId}" waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalWaypoint | 0                      |
      | pendingCount  | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery Transactions
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+6595557073 ","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Operator get order details
    And API Operator verifies that each "Delivery" transaction of created orders has the same waypoint_id
    And API Operator gets orphaned "Delivery" transaction waypoint ids of created orders
    And DB Operator verifies there are 1 route_monitoring_data records for route "KEY_CREATED_ROUTE_ID"
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted


    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalParcels  | 2                      |
      | totalWaypoint | 1                      |
      | pendingCount  | 1                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Pickup Transactions
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+6595557073 ","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator get order details
    And API Operator gets "Pickup" transaction waypoint ids of created orders
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Operator get order details
    And API Operator verifies that each "Pickup" transaction of created orders has the same waypoint_id
    And API Operator gets orphaned "Pickup" transaction waypoint ids of created orders
    And DB Operator verifies there are 1 route_monitoring_data records for route "KEY_CREATED_ROUTE_ID"
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted


    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalParcels  | 2                      |
      | totalWaypoint | 1                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery & Pickup Transactions
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+6595557073 ","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+6595557073 ","email": "binti@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | { "type":"PP" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | { "type":"PP" }         |
    And API Operator get order details
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    And API Operator gets "Pickup" transaction waypoint ids of created orders
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Operator get order details
    And API Operator verifies that each "Delivery" transaction of orders has the same waypoint_id:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And API Operator verifies that each "Pickup" transaction of orders has the same waypoint_id:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} |
    And DB Operator verifies there are 2 route_monitoring_data records for route "KEY_CREATED_ROUTE_ID"
    And API Operator gets orphaned "Delivery" transaction waypoint ids of created orders
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted

    And API Operator gets orphaned "Pickup" transaction waypoint ids of created orders
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted

    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalParcels  | 4                      |
      | totalWaypoint | 2                      |
      | pendingCount  | 2                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending Delivery From Route
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 1                      |
      | pendingCount         | 1                      |
      | successCount         | 0                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 0                      |
    When API Operator pulled out parcel "DELIVERY" from route
    And API Operator get order details
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies waypoints.route_id & seq_no is NULL

    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalWaypoint | 0                      |
      | pendingCount  | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending Pickup From Route
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 1                      |
      | pendingCount         | 1                      |
      | successCount         | 0                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 0                      |
    When API Operator pulled out parcel "PICKUP" from route
    And API Operator get order details
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies waypoints.route_id & seq_no is NULL

    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalWaypoint | 0                      |
      | pendingCount  | 0                      |
