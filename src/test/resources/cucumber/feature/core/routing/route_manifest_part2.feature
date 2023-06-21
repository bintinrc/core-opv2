@OperatorV2 @Core @Routing @RoutingJob1 @RouteManifest @RouteManifestPart2
Feature: Route Manifest

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Show Order Tags in Route Manifest Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id-2} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    Then Operator verify waypoint tags at Route Manifest using data below:
      | {order-tag-name}   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {order-tag-name-2} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Load Route Manifest of a Driver Multiple Pending Waypoints
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} | { "type":"PP" }         |
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    Then Operator verify waypoint at Route Manifest using data below:
      | id                 | {KEY_WAYPOINT_ID}            |
      | status             | Pending                      |
      | deliveriesCount    | 0                            |
      | pickupsCount       | 0                            |
      | reservation.id     | {KEY_CREATED_RESERVATION_ID} |
      | reservation.status | Pending                      |
    And Operator verify waypoint at Route Manifest using data below:
      | status              | Pending                                    |
      | deliveriesCount     | 1                                          |
      | pickupsCount        | 0                                          |
      | trackingIds         | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | delivery.trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | delivery.status     | Pending                                    |
    And Operator verify waypoint at Route Manifest using data below:
      | status            | Pending                                    |
      | deliveriesCount   | 0                                          |
      | pickupsCount      | 1                                          |
      | trackingIds       | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | pickup.trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | pickup.status     | Pending                                    |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Pickup Transaction with COP on Route Manifest - Collect COP
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update parcel COP to 20.00
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator success pickup waypoint with COD collection from Route Manifest page:
      | trackingId                      | collected |
      | {KEY_CREATED_ORDER_TRACKING_ID} | true      |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status            | Success                       |
      | deliveriesCount   | 0                             |
      | pickupsCount      | 1                             |
      | trackingIds       | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.trackingId | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.status     | Success                       |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | PICKUP                      |
      | expectedCodAmount | {KEY_CASH_ON_PICKUP_AMOUNT} |
      | driverId          | {ninja-driver-id}           |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup details on Edit order page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Pickup Transaction with COP on Route Manifest - Do Not Collect COP
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update parcel COP to 20.00
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator success pickup waypoint with COD collection from Route Manifest page:
      | trackingId                      | collected |
      | {KEY_CREATED_ORDER_TRACKING_ID} | false     |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status            | Success                       |
      | deliveriesCount   | 0                             |
      | pickupsCount      | 1                             |
      | trackingIds       | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.trackingId | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.status     | Success                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | PICKUP            |
      | expectedCodAmount | 0.00              |
      | driverId          | {ninja-driver-id} |
    And Operator verify Pickup details on Edit order page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Delivery Transaction with COD on Route Manifest -  Collect COD
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new COD for created order
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator success delivery waypoint with COD collection from Route Manifest page:
      | trackingId                      | collected |
      | {KEY_CREATED_ORDER_TRACKING_ID} | true      |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status              | Success                       |
      | deliveriesCount     | 1                             |
      | pickupsCount        | 0                             |
      | trackingIds         | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.trackingId | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.status     | Success                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | DELIVERY                      |
      | expectedCodAmount | {KEY_CASH_ON_DELIVERY_AMOUNT} |
      | driverId          | {ninja-driver-id}             |
    And Operator verify Delivery details on Edit order page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Delivery Transaction with COD on Route Manifest -  Do not Collect COD
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new COD for created order
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator success delivery waypoint with COD collection from Route Manifest page:
      | trackingId                      | collected |
      | {KEY_CREATED_ORDER_TRACKING_ID} | false     |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status              | Success                       |
      | deliveriesCount     | 1                             |
      | pickupsCount        | 0                             |
      | trackingIds         | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.trackingId | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.status     | Success                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | DELIVERY          |
      | expectedCodAmount | 0.00              |
      | driverId          | {ninja-driver-id} |
    And Operator verify Delivery details on Edit order page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Delivery Transaction of RTS Order with COD on Route Manifest - Collect COD
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator success delivery waypoint with COD collection from Route Manifest page:
      | trackingId                      | collected |
      | {KEY_CREATED_ORDER_TRACKING_ID} | true      |
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status              | Success                       |
      | deliveriesCount     | 1                             |
      | pickupsCount        | 0                             |
      | trackingIds         | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.trackingId | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.status     | Success                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                                     |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: Returned to Sender\n\nOld Order Status: Transit\nNew Order Status: Completed\n\nReason: ADMIN_UPDATE_WAYPOINT |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And DB Operator verify core_qa_sg/cod_collections record is NOT created:
      | driverId        | {ninja-driver-id} |
      | transactionMode | DELIVERY          |
    And API Operator verify order pricing details:
      | orderId      | {KEY_CREATED_ORDER_ID} |
      | codValue     | 23.57                  |
      | codCollected | 0                      |
    And Operator verify Delivery details on Edit order page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Delivery Transaction of RTS Order on Route Manifest
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator success delivery waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status              | Success                       |
      | deliveriesCount     | 1                             |
      | pickupsCount        | 0                             |
      | trackingIds         | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.trackingId | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.status     | Success                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order events on Edit order page using data below:
      | name           |
      | PRICING CHANGE |
      | FORCED SUCCESS |
      | UPDATE STATUS  |
    And Operator verify Delivery details on Edit order page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Fail Delivery Transaction of RTS Order on Route Manifest
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail delivery waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status                 | Fail                          |
      | deliveriesCount        | 1                             |
      | pickupsCount           | 0                             |
      | comments               | KEY_FAILURE_REASON            |
      | trackingIds            | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.trackingId    | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.status        | Fail                          |
      | delivery.failureReason | 1                             |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |
    And Operator verify order events on Edit order page using data below:
      | name           |
      | FORCED FAILURE |
      | UPDATE STATUS  |
    And Operator verify Delivery details on Edit order page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |
