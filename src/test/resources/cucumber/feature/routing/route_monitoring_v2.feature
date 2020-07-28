@OperatorV2 @Routing @RouteMonitoringV2 @Core
Feature: Route Monitoring

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Single Transaction
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 1                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Multiple Transactions
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 3                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Reservation
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Empty Route
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 0                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 0                      |
      | pendingCount         | 0                      |
      | numLateAndPending    | 0                      |
      | successCount         | 0                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 0                      |
      | earlyCount           | 0                      |
      | lateCount            | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 1                      |
      | pendingCount         | 1                      |
      | numLateAndPending    | 0                      |
      | successCount         | 0                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 0                      |
      | earlyCount           | 0                      |
      | lateCount            | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Delivery
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver pickup the created parcel successfully
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | 100                    |
      | totalWaypoint        | 1                      |
      | pendingCount         | 0                      |
      | numLateAndPending    | 0                      |
      | successCount         | 1                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 0                      |
      | earlyCount           | 1                      |
      | lateCount            | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Pickup
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver pickup the created parcel successfully
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | 100                    |
      | totalWaypoint        | 1                      |
      | pendingCount         | 0                      |
      | numLateAndPending    | 0                      |
      | successCount         | 1                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 0                      |
      | earlyCount           | 1                      |
      | lateCount            | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Delivery
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonCodeId | 4 |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | 100                    |
      | totalWaypoint        | 1                      |
      | pendingCount         | 0                      |
      | numLateAndPending    | 0                      |
      | successCount         | 0                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 1                      |
      | earlyCount           | 1                      |
      | lateCount            | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Pickup
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup using data below:
      | failureReasonCodeId | 7 |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | 100                    |
      | totalWaypoint        | 1                      |
      | pendingCount         | 0                      |
      | numLateAndPending    | 0                      |
      | successCount         | 0                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 1                      |
      | earlyCount           | 1                      |
      | lateCount            | 0                      |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op