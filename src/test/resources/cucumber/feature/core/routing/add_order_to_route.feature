@OperatorV2 @Core @Routing @AddOrderToRoute @RoutingModules
Feature: Add Order To Route

  Background:
    Given Launch browser
    When Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @routing-refactor @HighPriority
  Scenario: Add Order to a Route - Pickup, Valid Tracking ID, With Prefix
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Pickup" transaction type on Add Order to Route page
    And Operator add prefix of the created order on Add Order to Route page
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}          |
      | requestedTrackingId | {KEY_LIST_OF_CREATED_ORDERS[1].requestedTrackingId} |
    And Operator enters "{KEY_LIST_OF_CREATED_ORDERS[1].requestedTrackingId}" tracking id on Add Order to Route page
    Then Operator verifies that success notification displayed:
      | top | Order {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} added to route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verifies the last scanned tracking id is "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status  | PENDING                            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Add Order to a Route - Invalid Tracking ID, With Prefix
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    When Operator add "TEST" prefix on Add Order to Route page
    And Operator enters "INVALIDTRACKINGID" tracking id on Add Order to Route page
    Then Operator verifies that error notification displayed:
      | bottom | Order TESTINVALIDTRACKINGID not found! |
    And Operator verifies the last scanned tracking id is "TESTINVALIDTRACKINGID"

  @ArchiveRouteCommonV2 @routing-refactor @happy-path @HighPriority
  Scenario: Add Order to a Route - Delivery, Valid Tracking ID, No Prefix
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking id on Add Order to Route page
    Then Operator verifies that success notification displayed:
      | top | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} added to route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verifies the last scanned tracking id is "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Add Order to a Route - Invalid Tracking ID, No Prefix
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "INVALIDTRACKINGID" tracking id on Add Order to Route page
    Then Operator verifies that error notification displayed:
      | bottom | Order INVALIDTRACKINGID not found! |
    And Operator verifies the last scanned tracking id is "INVALIDTRACKINGID"

  @ArchiveRouteCommonV2 @routing-refactor @MediumPriority
  Scenario: Not Allowed to Add Delivery Routed Order to a New Route - Non-ID Country
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking id on Add Order to Route page
    Then Operator verifies that error notification displayed:
      | bottom | Delivery is already routed to {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verifies the last scanned tracking id is "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |

  @DeleteRoutes @HighPriority
  Scenario: Add Merged Pickup Order to a Route by Valid Tracking Id
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | generateFrom        | INDEX-0                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | INDEX-1                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator merge waypoints on Zonal Routing:
      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Pickup" transaction type on Add Order to Route page
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking id on Add Order to Route page
    Then Operator verifies that success notification displayed:
      | top | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} added to route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verifies the last scanned tracking id is "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | latestRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Routing Search - verify transactions record:
      | txnId      | {KEY_TRANSACTION.id}               |
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId           | {ninja-driver-id}                     |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  @DeleteRoutes @HighPriority
  Scenario: Add Merge Delivery Order to a Route by Valid Tracking Id
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFrom        | INDEX-0                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | INDEX-1                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator merge waypoints on Zonal Routing:
      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking id on Add Order to Route page
    Then Operator verifies that success notification displayed:
      | top | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} added to route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verifies the last scanned tracking id is "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | latestRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Routing Search - verify transactions record:
      | txnId      | {KEY_TRANSACTION.id}               |
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId           | {ninja-driver-id}                     |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Add Order to a Route - Pickup return order, route archived
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Pickup" transaction type on Add Order to Route page
    And Operator add prefix of the created order on Add Order to Route page
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}          |
      | requestedTrackingId | {KEY_LIST_OF_CREATED_ORDERS[1].requestedTrackingId} |
    And Operator enters "{KEY_LIST_OF_CREATED_ORDERS[1].requestedTrackingId}" tracking id on Add Order to Route page
    Then Operator verifies that error notification displayed:
      | bottom | [status=ARCHIVED]: cannot add waypoint if route not in [PENDING IN_PROGRESS] status |
    And Operator verifies the last scanned tracking id is "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Add Order to a Route - Delivery, route archived
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator add prefix of the created order on Add Order to Route page
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}          |
      | requestedTrackingId | {KEY_LIST_OF_CREATED_ORDERS[1].requestedTrackingId} |
    And Operator enters "{KEY_LIST_OF_CREATED_ORDERS[1].requestedTrackingId}" tracking id on Add Order to Route page
    Then Operator verifies that error notification displayed:
      | bottom | [status=ARCHIVED]: cannot add waypoint if route not in [PENDING IN_PROGRESS] status |
    And Operator verifies the last scanned tracking id is "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
