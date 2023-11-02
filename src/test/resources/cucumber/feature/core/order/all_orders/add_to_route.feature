@OperatorV2 @Core @AllOrders @RoutingModules @RoutingModulesAllOrders
Feature: All Orders - Add To Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @routing-refactor @happy-path @HighPriority
  Scenario: Operator Add Multiple Orders to Route on All Orders Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And Operator unmask All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator add multiple orders to route on All Orders page:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                |
      | trackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]},{KEY_LIST_OF_CREATED_TRACKING_IDS[3]} |
    Then Operator verifies that info toast displayed:
      | top    | 3 order(s) updated |
      | bottom | add to route       |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | seqNo   | not null                                                   |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | status  | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo   | not null                                                   |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | status  | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
      | seqNo   | not null                                                   |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | status  | Routed                                                     |
    And DB Core - verify route_monitoring_data record:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And DB Core - verify route_monitoring_data record:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And DB Core - verify route_monitoring_data record:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId           | {ninja-driver-id}                                                                                                  |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                 |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]},{KEY_LIST_OF_CREATED_TRACKING_IDS[3]}" |

  @ArchiveRouteCommonV2
  Scenario: Operator Add Partial Multiple Orders to Route on All Orders Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator unmask All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator add multiple orders to route on All Orders page:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                           |
      | trackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}, {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} \| Delivery is already routed to {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator close Errors dialog on All Orders page
    Then Operator verifies that warning toast displayed:
      | top    | 1 order(s) failed to update |
      | bottom | Add To Route                |
    And Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | Add To Route       |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator unmask edit order V2 page
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator unmask edit order V2 page
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | seqNo   | not null                                                   |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | status  | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo   | not null                                                   |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | status  | Routed                                                     |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |

  @DeleteOrArchiveRoute
  Scenario: Block Add to Route for Cancelled Order on All Orders Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator unmask All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    When Operator add multiple orders to route on All Orders page:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                           |
      | trackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}, {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} \| Order is Cancelled and cannot be added to route |
    When Operator close Errors dialog on All Orders page
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | add to route       |

  @ArchiveRouteCommonV2
  Scenario: Block Add to Route for On Hold Order on All Orders Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Recovery - Create ticket for tracking id: "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator add multiple orders to route on All Orders page:
      | trackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                          |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} \| Order is On Hold and cannot be added to route |
    When Operator close Errors dialog on All Orders page
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | add to route       |
