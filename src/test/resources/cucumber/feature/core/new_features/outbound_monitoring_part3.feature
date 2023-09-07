@OperatorV2 @Core @NewFeatures @OutboundMonitoring @OutboundMonitoringPart3 @NewFeatures1
Feature: Outbound Monitoring

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Partial Success To Pull Out Multiple Orders from Multiple Routes on Outbound Breakroute V2 Page - Delivery Order is Pulled Out
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                            | trackingId                            |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And API Core - Operator pull order from route:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | type    | DELIVERY                           |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies errors in Processing modal on Outbound Breakroute V2 page:
      | Get ProcessingException [Code:BAD_REQUEST_EXCEPTION][Message:No route found to unroute for [OrderID:{KEY_LIST_OF_CREATED_ORDERS[2].id}]] |
    When Operator clicks Cancel in Processing modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top    | Tracking IDs Pulled Out   |
      | bottom | 1 Tracking IDs pulled out |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | status  | Pending              |
      | routeId | null                 |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId} |
      | status  | Pending                      |
      | routeId | null                         |
      | seqNo   | null                         |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_TRANSACTION.waypointId} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Views Orders Under Orders in Routes and Outbound Scans fields on Outbound Breakroute V1
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And DB Sort - get hub by hub name "{KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    Given API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                            |
      | hubId              | {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}                                                              |
      | taskId             | 1                                                                                                |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name}                                    |
      | hubName  | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
    Then Operator verify the route ID is exist on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator clicks Edit button for "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verify that Outbound Scans table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verify that Parcels not in Outbound Scans table is empty

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Views Orders Under Orders in Routes and Parcels not in Outbound Scans fields on Outbound Breakroute V1 - Order Scanned in Different Hub as Order and Route
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And DB Sort - get hub by hub name "{KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    Given API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                 |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name}                                    |
      | hubName  | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
    Then Operator verify the route ID is exist on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator clicks Edit button for "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator pull out order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" from route on Outbound Breakroute page
    Then Operator verifies that success toast displayed:
      | top | Success pullout tracking id {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | status  | Pending              |
      | routeId | null                 |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId} |
      | status  | Pending                      |
      | routeId | null                         |
      | seqNo   | null                         |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_TRANSACTION.waypointId} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Views Orders Under Orders in Routes and Parcels not in Outbound Scans fields on Outbound Breakroute V1 - Order is not Scanned
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And DB Sort - get hub by hub name "{KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    Given API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name}                                    |
      | hubName  | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
    Then Operator verify the route ID is exist on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator clicks Edit button for "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator pull out order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" from route on Outbound Breakroute page
    Then Operator verifies that success toast displayed:
      | top | Success pullout tracking id {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | status  | Pending              |
      | routeId | null                 |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId} |
      | status  | Pending                      |
      | routeId | null                         |
      | seqNo   | null                         |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_TRANSACTION.waypointId} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Views Orders Under Orders in Routes, Outbound Scans, and Parcels not in Outbound Scans fields on Outbound Breakroute V1
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And DB Sort - get hub by hub name "{KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                 |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}                                                            |
      | hubId              | {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}                                                              |
      | taskId             | 1                                                                                                |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name}                                    |
      | hubName  | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
    Then Operator verify the route ID is exist on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator clicks Edit button for "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator verify that Outbound Scans table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator pull out order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" from route on Outbound Breakroute page
    Then Operator verifies that success toast displayed:
      | top | Success pullout tracking id {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  @ArchiveRouteCommonV2
  Scenario: Operator Clicks on Flag Icon to Un-Mark Route ID on Outbound Monitoring Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    Given API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    When Operator go to menu New Features -> Outbound Load Monitoring
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator search on Route ID Header Table on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click on flag icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies route record on Outbound Monitoring page:
      | id             | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | outboundStatus | Marked                             |
    And Operator verifies route record has "yellow" background color
    When Operator click on flag icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies route record on Outbound Monitoring page:
      | id             | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | outboundStatus | In Progress                        |
    And Operator verifies route record has "red" background color
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | systemId | sg                                 |
      | isOk     | 0                                  |
