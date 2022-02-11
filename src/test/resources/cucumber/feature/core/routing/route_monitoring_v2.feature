@OperatorV2 @Core @Routing @RoutingJob3 @RouteMonitoringV2
Feature: Route Monitoring V2

  @LaunchBrowser @ShouldAlwaysRun
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 3                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Empty Route (uid:928d4d63-c3f3-468c-a565-3f0c6d68db35)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Pickup (uid:d58b2f01-96b1-490c-8359-e207a77fa3a9)
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

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Delivery (uid:8ff7b641-6085-4a03-bd23-2fa7caddc4a3)
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
    Examples:
      | type           | failureReasonCodeId | completionPercentage | numInvalidFailed | numValidFailed | hiptest-uid                              |
      | Valid Failed   | 7                   | 100                  | 0                | 1              | uid:528bb29f-1f4f-4d52-b029-7787030289f1 |
      | Invalid Failed | 9                   | 0                    | 1                | 0              | uid:a320bc69-a868-46ba-a9b4-0e073ed84d24 |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup (uid:f84418a9-839e-4d8c-b179-98e5b58b643d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | orderTag | {order-tag-prior-id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Delivery (uid:b1a7810d-d762-4546-8dec-87e4a8926acf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | orderTag | {order-tag-prior-id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId                | {KEY_CREATED_ROUTE_ID} |
      | totalParcels           | 1                      |
      | pendingPriorityParcels | 0                      |
    When Operator open Pending Priority modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 0 Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page
    And Operator check there are 0 Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page

  @DeleteOrArchiveRoute @CloseNewWindows
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
      | orderTag | {order-tag-prior-id} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
      | orderTag | {order-tag-prior-id} |
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
      | orderTag | {order-tag-prior-id} |
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed on NON-Failed Waypoints (uid:f152f03a-5b87-4171-b06f-c11f83834f1e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
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

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Waypoints - Pickup, Delivery & Reservation Under the Same Route (uid:a9415bb3-33d2-41aa-b4c6-06975f5f360e)
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
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId          | {KEY_CREATED_ROUTE_ID} |
      | totalWaypoint    | 3                      |
      | numInvalidFailed | 3                      |
    When Operator open Invalid Failed WP modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 1 Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 1 Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator check there are 1 Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page
    And Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[2].toName}      |
      | tags         | -                                          |
    And Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customerName | {KEY_LIST_OF_CREATED_ORDER[1].fromName}    |
      | tags         | -                                          |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Reservation (uid:184d89a0-ea55-4d0f-bd94-c6f249eb1b3f)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId          | {KEY_CREATED_ROUTE_ID} |
      | totalParcels     | 1                      |
      | totalWaypoint    | 2                      |
      | numInvalidFailed | 1                      |
    When Operator open Invalid Failed WP modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    And Operator check there are 1 Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page

  @DeleteOrArchiveRoute @DeleteDriver
  Scenario: Show Updated Driver Name in Route Monitoring V2 (uid:88878587-9c53-482f-80c2-a98f4376ac0b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"+6589011608"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Shipper create V4 order using data below:
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | driverName | {ninja-driver-name}    |
      | routeId    | {KEY_CREATED_ROUTE_ID} |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator edits details of created route using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}        |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name}                             |
      | hub        | {hub-name}                              |
      | driverName | {KEY_CREATED_DRIVER_INFO.getFullName}   |
      | vehicle    | {vehicle-name}                          |
      | comments   | Route has been edited by automated test |
    And Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | driverName | {KEY_CREATED_DRIVER_INFO.getFullName} |
      | routeId    | {KEY_CREATED_ROUTE_ID}                |

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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Reservation (uid:03e8e4e1-bd2d-4ac6-951b-daf7c74199b7)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | successCount | 1                      |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Reservation - <name> (<hiptest-uid>)
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
    And API Operator start the route
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 8           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId        | {KEY_CREATED_ROUTE_ID} |
      | numValidFailed | 1                      |

    Examples:
      | name         | failureReasonCodeId | numValidFailed | numInvalidFailed | hiptest-uid                              |
      | Valid Fail   | 8                   | 1              | 0                | uid:795339f1-f3db-4417-9c90-5b712a22adf9 |
      | Invalid Fail | 9                   | 0              | 1                | uid:eef28170-195e-45a1-97d7-1e99970ad1eb |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Reservation
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
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalWaypoint | 1                      |
      | pendingCount  | 1                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending Reservation From Route
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {shipper-v4-legacy-id}           |
    And Operator removes the route from the created reservation
    And DB Operator verifies "{KEY_CREATED_RESERVATION.waypointId}" waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalWaypoint | 0                      |
      | pendingCount  | 0                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery Transactions (uid:7ee66a53-0dc8-4b11-90de-88add722887b)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator merge route transactions
    And API Operator get order details
    And API Operator verifies that each "Delivery" transaction of created orders has the same waypoint_id
    And API Operator gets orphaned "Delivery" transaction waypoint ids of created orders
    And DB Operator verifies there are 1 route_monitoring_data records for route "KEY_CREATED_ROUTE_ID"
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted
    And DB Operator verifies there are 3 route_waypoint records for route "KEY_CREATED_ROUTE_ID"
    And DB Operator verifies all orphaned route_waypoint records are hard-deleted
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
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
  Scenario: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Pickup Transactions (uid:a2b915b0-e821-4d5b-8808-bebf6f69b40f)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator merge route transactions
    And API Operator get order details
    And API Operator verifies that each "Pickup" transaction of created orders has the same waypoint_id
    And API Operator gets orphaned "Pickup" transaction waypoint ids of created orders
    And DB Operator verifies there are 1 route_monitoring_data records for route "KEY_CREATED_ROUTE_ID"
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted
    And DB Operator verifies there are 3 route_waypoint records for route "KEY_CREATED_ROUTE_ID"
    And DB Operator verifies all orphaned route_waypoint records are hard-deleted
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalParcels  | 2                      |
      | totalWaypoint | 1                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery & Pickup Transactions (uid:5bddde45-bde6-403a-90dc-35c0cc0362ba)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator merge route transactions
    And API Operator get order details
    And API Operator verifies that each "Delivery" transaction of orders has the same waypoint_id:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And API Operator verifies that each "Pickup" transaction of orders has the same waypoint_id:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} |
    And DB Operator verifies there are 2 route_monitoring_data records for route "KEY_CREATED_ROUTE_ID"
    And DB Operator verifies there are 4 route_waypoint records for route "KEY_CREATED_ROUTE_ID"
    And API Operator gets orphaned "Delivery" transaction waypoint ids of created orders
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted
    And DB Operator verifies all orphaned route_waypoint records are hard-deleted
    And API Operator gets orphaned "Pickup" transaction waypoint ids of created orders
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted
    And DB Operator verifies all orphaned route_waypoint records are hard-deleted
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId       | {KEY_CREATED_ROUTE_ID} |
      | totalParcels  | 4                      |
      | totalWaypoint | 2                      |
      | pendingCount  | 2                      |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op