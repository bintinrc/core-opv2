@OperatorV2 @Core @Routing  @RouteManifest @RouteManifestPart2
Feature: Route Manifest

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Show Order Tags in Route Manifest Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-id}                     |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-id-2}                   |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verify waypoint tags at Route Manifest using data below:
      | {order-tag-name}   | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {order-tag-name-2} | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |

  @HighPriority
  Scenario: Operator Load Route Manifest of a Driver Multiple Pending Waypoints
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 1       | 0       | 0       | 1   |
      | Pickups    | 1       | 0       | 0       | 1   |
      | Total      | 2       | 0       | 0       | 2   |
    And Operator verify Route summary Waypoint type on Route Manifest page:
      |             | Pending | Success | Failure | All |
      | Normal      | 2       | 0       | 0       | 2   |
      | Reservation | 1       | 0       | 0       | 1   |
    Then Operator verify waypoint at Route Manifest using data below:
      | id              | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | status          | Pending                                          |
      | deliveriesCount | 0                                                |
      | pickupsCount    | 0                                                |
    And Operator verify waypoint at Route Manifest using data below:
      | status          | Pending                               |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verify waypoint at Route Manifest using data below:
      | status          | Pending                               |
      | deliveriesCount | 0                                     |
      | pickupsCount    | 1                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |

  @HighPriority
  Scenario: Operator Admin Manifest Force Success Pickup Transaction with COP on Route Manifest - Collect COP
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order COP:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | copAmount | 20.00                              |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success pickup waypoint with COD collection from Route Manifest page:
      | trackingId                            | collected |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | true      |
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} successfully |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Success                               |
      | deliveriesCount | 0                                     |
      | pickupsCount    | 1                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | collectedSum | 20.00                                                      |
      | driverId     | {ninja-driver-id}                                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @HighPriority
  Scenario: Operator Admin Manifest Force Success Pickup Transaction with COP on Route Manifest - Do Not Collect COP
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order COP:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | copAmount | 20.00                              |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success pickup waypoint with COD collection from Route Manifest page:
      | trackingId                            | collected |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | false     |
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} successfully |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Success                               |
      | deliveriesCount | 0                                     |
      | pickupsCount    | 1                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | collectedSum | 0.00                                                       |
      | driverId     | {ninja-driver-id}                                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @HighPriority
  Scenario: Operator Admin Manifest Force Success Delivery Transaction with COD on Route Manifest -  Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":20.00, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success delivery waypoint with COD collection from Route Manifest page:
      | trackingId                            | collected |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | true      |
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} successfully |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Success                               |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | collectedSum | 20.00                                                      |
      | driverId     | {ninja-driver-id}                                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @HighPriority
  Scenario: Operator Admin Manifest Force Success Delivery Transaction with COD on Route Manifest -  Do not Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":20.00, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success delivery waypoint with COD collection from Route Manifest page:
      | trackingId                            | collected |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | false     |
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} successfully |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Success                               |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | collectedSum | 0.00                                                       |
      | driverId     | {ninja-driver-id}                                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  Scenario: Operator Admin Manifest Force Success Delivery Transaction of RTS Order with COD on Route Manifest - Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":20.00, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success delivery waypoint with COD collection from Route Manifest page:
      | trackingId                            | collected |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | true      |
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} successfully |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Success                               |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And DB Core - verifies cod_collections record was not created:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | driverId   | {ninja-driver-id}                                          |
    And API Core - verify order pricing details:
      | orderId      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | codValue     | 20.00                              |
      | codCollected | 0                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed          |
      | granularStatus | Returned to Sender |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And DB Core - verify waypoints record:
      | id     | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status | Success                                                    |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                     |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: Returned to Sender\n\nOld Order Status: Transit\nNew Order Status: Completed\n\nReason: ADMIN_UPDATE_WAYPOINT |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @HighPriority
  Scenario: Operator Admin Manifest Force Success Delivery Transaction of RTS Order on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                  |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY "} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 1       | 0       | 0       | 1   |
      | Total      | 1       | 0       | 0       | 1   |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success delivery waypoint from Route Manifest page
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} successfully |
    And Operator refresh page
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 0       | 1       | 0       | 1   |
      | Total      | 0       | 1       | 0       | 1   |
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Success                               |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed          |
      | granularStatus | Returned to Sender |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | PRICING CHANGE |
      | FORCED SUCCESS |
      | UPDATE STATUS  |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |

  @HighPriority
  Scenario: Operator Admin Manifest Force Fail Delivery Transaction of RTS Order on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                  |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY "} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 1       | 0       | 0       | 1   |
      | Total      | 1       | 0       | 0       | 1   |
    And Operator fail delivery waypoint from Route Manifest page
      | failureReasonDescription    | Attempting failure at doorstep - Normal     |
      | failureReasonSubDescription | Non-residential location is closed - Normal |
      | replace                     | - Normal                                    |
    Then Operator verifies that success react notification displayed:
      | top | Updated waypoint {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} successfully |
    And Operator refresh page
    And Operator verify Route summary Parcel count on Route Manifest page:
      |            | Pending | Success | Failure | All |
      | Deliveries | 0       | 0       | 1       | 1   |
      | Total      | 0       | 0       | 1       | 1   |
    Then Operator verify waypoint at Route Manifest using data below:
      | status          | Fail                                  |
      | deliveriesCount | 1                                     |
      | pickupsCount    | 0                                     |
      | trackingIds     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | comments        | {KEY_SELECTED_FAILURE_REASON}         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | FORCED FAILURE |
      | UPDATE STATUS  |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |