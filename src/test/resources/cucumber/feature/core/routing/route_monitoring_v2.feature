@OperatorV2 @Routing @RouteMonitoringV2 @Core
Feature: Route Monitoring

  @LaunchBrowser @ShouldAlwaysRun @Debug @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Single Transaction (uid:70b113d9-c272-40e8-a637-7489236f93ec)
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
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Multiple Transactions (uid:2fa49a65-3398-4c1d-b1f2-f339a6565486)
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
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Reservation (uid:4b9a22ee-afa2-46d7-b5c9-62c63b73f81a)
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
  Scenario: Operator Filter Route Monitoring Data And Checks Empty Route (uid:928d4d63-c3f3-468c-a565-3f0c6d68db35)
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
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Pickup (uid:1e195c8b-3569-4ed4-bb71-72ab94701c69)
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
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Delivery (uid:7338b163-ed9a-4094-b83f-5fea211202a9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Delivery (uid:99109042-790f-49cb-a2a0-f39f9d99b788)
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
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Pickup (uid:7071c04a-8e7e-4cd8-8c8b-446e3e9798d9)
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
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Delivery - <type> (<hiptest-uid>)
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
      | failureReasonFindMode  | findAdvance           |
      | failureReasonCodeId    | <failureReasonCodeId> |
      | failureReasonIndexMode | FIRST                 |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | <completionPercentage> |
      | totalWaypoint        | 1                      |
      | pendingCount         | 0                      |
      | numLateAndPending    | 0                      |
      | successCount         | 0                      |
      | numInvalidFailed     | <numInvalidFailed>     |
      | numValidFailed       | <numValidFailed>       |
      | earlyCount           | 1                      |
      | lateCount            | 0                      |
    Examples:
      | type           | failureReasonCodeId | completionPercentage | numInvalidFailed | numValidFailed | hiptest-uid                              |
      | Valid Failed   | 2                   | 100                  | 0                | 1              | uid:c4fb6765-3c45-4c51-8e7a-1e1e91ce1f77 |
      | Invalid Failed | 5                   | 0                    | 1                | 0              | uid:e4c41d55-0d82-45ab-9dc3-db3d851e9957 |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Pickup - <type> (<hiptest-uid>)
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
      | failureReasonFindMode  | findAdvance           |
      | failureReasonCodeId    | <failureReasonCodeId> |
      | failureReasonIndexMode | FIRST                 |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | <completionPercentage> |
      | totalWaypoint        | 1                      |
      | pendingCount         | 0                      |
      | numLateAndPending    | 0                      |
      | successCount         | 0                      |
      | numInvalidFailed     | <numInvalidFailed>     |
      | numValidFailed       | <numValidFailed>       |
      | earlyCount           | 1                      |
      | lateCount            | 0                      |
    Examples:
      | type           | failureReasonCodeId | completionPercentage | numInvalidFailed | numValidFailed | hiptest-uid                              |
      | Valid Failed   | 7                   | 100                  | 0                | 1              | uid:528bb29f-1f4f-4d52-b029-7787030289f1 |
      | Invalid Failed | 9                   | 0                    | 1                | 0              | uid:a320bc69-a868-46ba-a9b4-0e073ed84d24 |

  @DeleteOrArchiveRoute @Close@CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup (uid:2c79b0f5-11a6-42e8-b761-461303c7267d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | OrderTag | 5570 |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId                | {KEY_CREATED_ROUTE_ID} |
      | totalParcels           | 2                      |
      | totalWaypoint          | 2                      |
      | pendingPriorityParcels | 2                      |
    When Operator open Pending Priority modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 2 Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page
    And Operator verify Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[1].fromName}    |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |

  @DeleteOrArchiveRoute @Close@CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Delivery (uid:49495b5c-9762-492b-9e04-810c209104a2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | OrderTag | 5570 |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId                | {KEY_CREATED_ROUTE_ID} |
      | totalParcels           | 2                      |
      | totalWaypoint          | 2                      |
      | pendingPriorityParcels | 2                      |
    When Operator open Pending Priority modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 2 Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page
    And Operator verify Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[1].toName}      |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels on NON-PRIOR Waypoints (uid:00efcc8e-6720-4dca-80a8-6da3a11f38c0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | routeId                | {KEY_CREATED_ROUTE_ID} |
      | totalParcels           | 1                      |
      | pendingPriorityParcels | 0                      |
    When Operator open Pending Priority modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 0 Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page
    And Operator check there are 0 Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page

  @DeleteOrArchiveRoute @Close@CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup & Delivery Under the Same Route (uid:ae53d1b3-93b0-4890-b64a-b0084e282ebf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | OrderTag | 5570 |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId                | {KEY_CREATED_ROUTE_ID} |
      | totalParcels           | 2                      |
      | totalWaypoint          | 2                      |
      | pendingPriorityParcels | 2                      |
    When Operator open Pending Priority modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 1 Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page
    And Operator verify Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[1].fromName}    |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator close current window and switch to Route Monitoring V2 page

    Then Operator check there are 1 Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page
    And Operator verify Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[2].toName}      |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order Has PRIOR Tag (uid:4bf8531a-ead3-49ac-bce5-7072f26142dc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | OrderTag | 5570 |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | orderNumber            | 1           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 5           |
      | failureReasonIndexMode | FIRST       |
    And API Driver failed the delivery of the created parcel using data below:
      | orderNumber            | 2           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 5           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 2                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 2                      |
      | numInvalidFailed     | 2                      |
      | numValidFailed       | 0                      |
    When Operator open Invalid Failed WP modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 2 Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[1].toName}      |
      | tags         | PRIOR                                      |
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[2].toName}      |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order with NO Tags (uid:5440bc22-43e1-4d23-a73e-7a0960b21b1c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | orderNumber            | 1           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 5           |
      | failureReasonIndexMode | FIRST       |
    And API Driver failed the delivery of the created parcel using data below:
      | orderNumber            | 2           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 5           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 2                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 2                      |
      | numInvalidFailed     | 2                      |
      | numValidFailed       | 0                      |
    When Operator open Invalid Failed WP modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 2 Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[1].toName}      |
      | tags         | -                                          |
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[2].toName}      |
      | tags         | -                                          |
    When Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order Has PRIOR Tag (uid:e48b223f-fab2-4828-9e18-64474676b390)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | OrderTag | 5570 |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the C2C/Return order pickup using data below:
      | orderNumber            | 1           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    And API Driver failed the C2C/Return order pickup using data below:
      | orderNumber            | 2           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 2                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 2                      |
      | numInvalidFailed     | 2                      |
      | numValidFailed       | 0                      |
    When Operator open Invalid Failed WP modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 2 Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[1].fromName}    |
      | tags         | PRIOR                                      |
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[2].fromName}    |
      | tags         | PRIOR                                      |
    When Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order with NO Tags (uid:bde14f57-e3af-45c8-8dd5-9b0c619d02e2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the C2C/Return order pickup using data below:
      | orderNumber            | 1           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    And API Driver failed the C2C/Return order pickup using data below:
      | orderNumber            | 2           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 2                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 2                      |
      | numInvalidFailed     | 2                      |
      | numValidFailed       | 0                      |
    When Operator open Invalid Failed WP modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 2 Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[1].fromName}    |
      | tags         | -                                          |
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[2].fromName}    |
      | tags         | -                                          |
    When Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator close current window and switch to Route Monitoring V2 page
    When Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups on NON-Failed Waypoints (uid:f152f03a-5b87-4171-b06f-c11f83834f1e)
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
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 1                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 0                      |
    When Operator open Invalid Failed WP modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 0 Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 0 Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 0 Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page

  @DeleteOrArchiveRoute @Close@CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Waypoints - Pickup, Delivery & Reservation Under the Same Route
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the C2C/Return order pickup using data below:
      | orderNumber            | 1           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    And API Driver failed the delivery of the created parcel using data below:
      | orderNumber            | 2           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 5           |
      | failureReasonIndexMode | FIRST       |
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9          |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId          | {KEY_CREATED_ROUTE_ID} |
      | totalParcels     | 3                      |
      | totalWaypoint    | 3                      |
      | numInvalidFailed | 3                      |
    When Operator open Invalid Failed WP modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 1 Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 1 Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 1 Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[2].fromName}    |
      | tags         | -                                          |
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[1].fromName}    |
      | tags         | -                                          |

  @DeleteOrArchiveRoute @Close@CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Reservation
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9          |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId          | {KEY_CREATED_ROUTE_ID} |
      | totalParcels     | 1                      |
      | totalWaypoint    | 1                      |
      | numInvalidFailed | 1                      |
    When Operator open Invalid Failed WP modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    And Operator check there are 1 Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op