@OperatorV2 @Core @NewFeatures @OutboundMonitoring @OutboundMonitoringPart1 @NewFeatures1
Feature: Outbound Monitoring

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2
  Scenario: Operator Search Outbound Data on Outbound Monitoring Page
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
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    And Operator search on Route ID Header Table on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify the route ID is exist on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2
  Scenario: Operator Verifies the In Progress Outbound Status on Outbound Monitoring Page
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
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    And Operator search on Route ID Header Table on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify the In Progress Outbound Status on Outbound Monitoring Page

  @ArchiveRouteCommonV2
  Scenario: Operator Verifies the Complete Outbound Status on Outbound Monitoring Page
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
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Core - Operator Outbound Scan parcel using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | hubId      | {hub-id}                              |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                     |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                             |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS" }] |
      | routes     | KEY_DRIVER_ROUTES                                                                      |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify the Complete Outbound Status on Outbound Monitoring Page

  @ArchiveRouteCommonV2
  Scenario: Operator Clicks on Flag Icon to Mark Route ID on Outbound Monitoring Page
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
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click on flag icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies the Outbound status on the chosen route ID is changed

  @ArchiveRouteCommonV2
  Scenario: Operator Adding Comment on the Outbound Monitoring Page
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
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click on comment icon on chosen route ID on Outbound Monitoring Page
    And Operator refresh page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies the comment table on the chosen route ID is changed

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Pull Out Delivery Order from a Route on Outbound Breakroute V1 Page
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
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Edit button for "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Outbound Monitoring Page
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
  Scenario: Operator Filters Single Route on Outbound Monitoring Page by Edit Route button
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
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    Then Operator verify the route ID is exist on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator clicks Edit button for "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Outbound Monitoring Page
    Then Operator verify that there is "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route selected shown on 'Outbound Route Pullout' field
    And Operator verify that Orders in Route table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Unable to Pull Out Non-Pending State Delivery Order on Outbound Breakroute V1 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                    |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                        |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS" }] |
      | routes     | KEY_DRIVER_ROUTES                                                                 |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | DELIVERY                                                                                             |
      | failureReasonId | 139                                                                                                  |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    Then Operator verify the route ID is exist on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator clicks Edit button for "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Outbound Monitoring Page
    And Operator pull out order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" from route on Outbound Breakroute page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                                                                                            |
      | bottom | ^.*Error Message: Get ProcessingException \[Code:ORDER_COMPLETED_EXCEPTION\]\[Message:Transaction for \[OrderID:{KEY_LIST_OF_CREATED_ORDERS[2].id}\] is not in pending state\].* |
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                          |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Able to Show Pending State and Non-Pending State Delivery Order on Outbound Breakroute V1 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                    |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                        |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS" }] |
      | routes     | KEY_DRIVER_ROUTES                                                                 |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    Then Operator verify the route ID is exist on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                          |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                          |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Unable to Show Pending State and Non-Pending State Pickup Order on Outbound Breakroute V1 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                    |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                               |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                       |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                |
      | jobType    | TRANSACTION                                                                      |
      | jobAction  | SUCCESS                                                                          |
      | jobMode    | PICK_UP                                                                          |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    Then Operator verify the route ID is exist on Outbound Monitoring Page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator clicks Edit button for "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Outbound Monitoring Page
    Then Operator verify that Orders in Route table is empty
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table is empty