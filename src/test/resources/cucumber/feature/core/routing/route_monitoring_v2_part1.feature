@OperatorV2 @Core @Routing @RoutingJob3 @RouteMonitoringV2 @RouteMonitoringV2Part1
Feature: Route Monitoring V2

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @HighPriority
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
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 1                      |

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Multiple Transactions
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 3                      |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Empty Route
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Monitoring V2
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

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Pickup
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> Route Monitoring V2
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
      | successCount         | 0                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 0                      |

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Delivery
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
      | hubs    | {hub-name}             |
      | zones   | {zone-name}            |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId              | {KEY_CREATED_ROUTE_ID} |
      | totalParcels         | 1                      |
      | completionPercentage | 0                      |
      | totalWaypoint        | 1                      |
      | pendingCount         | 1                      |
      | successCount         | 0                      |
      | numInvalidFailed     | 0                      |
      | numValidFailed       | 0                      |

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Delivery
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver pickup the created parcel successfully
    When Operator go to menu Routing -> Route Monitoring V2
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

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Pickup
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver pickup the created parcel successfully
    When Operator go to menu Routing -> Route Monitoring V2
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

  @DeleteOrArchiveRoute @HighPriority
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Delivery - <type>
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance           |
      | failureReasonCodeId    | <failureReasonCodeId> |
      | failureReasonIndexMode | FIRST                 |
    When Operator go to menu Routing -> Route Monitoring V2
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
    Examples:
      | type           | failureReasonCodeId | completionPercentage | numInvalidFailed | numValidFailed | hiptest-uid                              |
      | Valid Failed   | 2                   | 100                  | 0                | 1              | uid:c4fb6765-3c45-4c51-8e7a-1e1e91ce1f77 |
      | Invalid Failed | 5                   | 0                    | 1                | 0              | uid:e4c41d55-0d82-45ab-9dc3-db3d851e9957 |

  @DeleteOrArchiveRoute @HighPriority
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Pickup - <type>
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup using data below:
      | failureReasonFindMode  | findAdvance           |
      | failureReasonCodeId    | <failureReasonCodeId> |
      | failureReasonIndexMode | FIRST                 |
    When Operator go to menu Routing -> Route Monitoring V2
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
    Examples:
      | type           | failureReasonCodeId | completionPercentage | numInvalidFailed | numValidFailed | hiptest-uid                              |
      | Valid Failed   | 7                   | 100                  | 0                | 1              | uid:528bb29f-1f4f-4d52-b029-7787030289f1 |
      | Invalid Failed | 9                   | 0                    | 1                | 0              | uid:a320bc69-a868-46ba-a9b4-0e073ed84d24 |

  @DeleteOrArchiveRoute @CloseNewWindows @happy-path @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> Route Monitoring V2
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

  @DeleteOrArchiveRoute @CloseNewWindows @happy-path @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Delivery
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
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
