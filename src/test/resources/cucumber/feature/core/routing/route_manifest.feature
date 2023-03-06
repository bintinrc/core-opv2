@OperatorV2 @Core @Routing @RoutingJob1 @RouteManifest
Feature: Route Manifest

  @LaunchBrowser @ShouldAlwaysRun @EnableClearCache
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Load Route Manifest of a Driver Success Delivery
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    Then Operator verify 1 delivery success at Route Manifest

  @DeleteOrArchiveRoute
  Scenario: Operator Load Route Manifest of a Driver Failed Delivery
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
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Operator get order details
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    Then Operator verify waypoint at Route Manifest using data below:
      | status                 | Fail                          |
      | deliveriesCount        | 1                             |
      | pickupsCount           | 0                             |
      | comments               | KEY_FAILURE_REASON            |
      | trackingIds            | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.trackingId    | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.status        | Fail                          |
      | delivery.failureReason | 6                             |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Fail Reservation on Route Manifest
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail reservation waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status             | Fail                       |
      | deliveriesCount    | 0                          |
      | pickupsCount       | 0                          |
      | reservation.id     | KEY_CREATED_RESERVATION_ID |
      | reservation.status | Fail                       |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | FAIL                             |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}    |
      | approxVolume | Less than 10 Parcels |
    And Operator verifies reservation is finished using data below:
      | backgroundColor | #ffc0cb |
      | status          | FAIL    |
    And DB Operator verifies waypoint status is "FAIL"

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Reservation on Route Manifest
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator success reservation waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status             | Success                    |
      | deliveriesCount    | 0                          |
      | pickupsCount       | 0                          |
      | reservation.id     | KEY_CREATED_RESERVATION_ID |
      | reservation.status | Success                    |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | SUCCESS                          |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}    |
      | approxVolume | Less than 10 Parcels |
    And Operator verifies reservation is finished using data below:
      | backgroundColor | #90ee90 |
      | status          | SUCCESS |
    And DB Operator verifies waypoint status is "SUCCESS"

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Fail Pickup Transaction on Route Manifest
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail pickup waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status               | Fail                          |
      | deliveriesCount      | 0                             |
      | pickupsCount         | 1                             |
      | trackingIds          | KEY_CREATED_ORDER_TRACKING_ID |
      | comments             | KEY_FAILURE_REASON            |
      | pickup.trackingId    | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.status        | Fail                          |
      | pickup.failureReason | 9                             |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Pickup Fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | FAIL |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED FAILURE |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                        |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Pickup fail\n\nOld Order Status: Pending\nNew Order Status: Pickup fail\n\nReason: ADMIN_UPDATE_WAYPOINT |
    And Operator verify Pickup details on Edit order page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Pickup Transaction on Route Manifest
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator success pickup waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status            | Success                       |
      | deliveriesCount   | 0                             |
      | pickupsCount      | 1                             |
      | trackingIds       | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.trackingId | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.status     | Success                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                                |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: En-route to Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: ADMIN_UPDATE_WAYPOINT |
    And Operator verify Pickup details on Edit order page using data below:
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Fail Delivery Transaction on Route Manifest
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
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
    And Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | FAIL |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED FAILURE |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                                         |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: Pending Reschedule\n\nOld Order Status: Transit\nNew Order Status: Delivery fail\n\nReason: ADMIN_UPDATE_WAYPOINT |
    And Operator verify Delivery details on Edit order page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Delivery Transaction on Route Manifest
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
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
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
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
      | tags          | name          | description                                                                                                                                                            |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: Completed\n\nOld Order Status: Transit\nNew Order Status: Completed\n\nReason: ADMIN_UPDATE_WAYPOINT |
    And Operator verify Delivery details on Edit order page using data below:
      | lastServiceEnd | {gradle-current-date-yyyy-MM-dd} |

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
      | tags          | name          | description                                                                                                                                                                      |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Vehicle for Delivery\nNew Granular Status: Returned to Sender\n\nOld Order Status: Transit\nNew Order Status: Completed\n\nReason: ADMIN_UPDATE_WAYPOINT |
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op