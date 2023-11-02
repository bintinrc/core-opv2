@OperatorV2 @Core @Routing @RoutingJob3 @RouteMonitoringV2 @RouteMonitoringV2Part2
Feature: Route Monitoring V2

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels on NON-PRIOR Waypoints
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
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
      | routeId                | {KEY_CREATED_ROUTE_ID} |
      | totalParcels           | 1                      |
      | pendingPriorityParcels | 0                      |
    When Operator open Pending Priority modal of a route "{KEY_CREATED_ROUTE_ID}" on Route Monitoring V2 page
    Then Operator check there are 0 Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page
    And Operator check there are 0 Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup & Delivery Under the Same Route
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
    When Operator go to menu Routing -> Route Monitoring V2
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
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order Has PRIOR Tag
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
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver failed the delivery of the created parcel using data below:
      | orderNumber            | 1           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Driver failed the delivery of the created parcel using data below:
      | orderNumber            | 2           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
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
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order with NO Tags
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
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
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order Has PRIOR Tag
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
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
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
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order with NO Tags
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
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
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed on NON-Failed Waypoints
    Given Operator go to menu Utilities -> QRCode Printing
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

  @DeleteOrArchiveRoute @CloseNewWindows @happy-path @HighPriority
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Waypoints - Pickup, Delivery & Reservation Under the Same Route
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
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
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Reservation
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> Route Monitoring V2
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

  @DeleteOrArchiveRoute @DeleteDriverV2
  Scenario: Show Updated Driver Name & Hub in Route Monitoring V2
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name-2}                   |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | driverName | {ninja-driver-name}    |
      | routeId    | {KEY_CREATED_ROUTE_ID} |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY    |
      | routeDateTo   | TODAY        |
      | hubName       | {hub-name-2} |
    And Operator edits details of created route using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}        |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name}                             |
      | hub        | {hub-name}                              |
      | driverName | {ninja-driver-2-name}                   |
      | comments   | Route has been edited by automated test |
    And Operator go to menu Routing -> Route Monitoring V2
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}                     |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}         |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | driverName | {ninja-driver-2-name}  |
      | routeId    | {KEY_CREATED_ROUTE_ID} |
