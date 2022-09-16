@OperatorV2 @Core @Routing @RouteManifest @happy-path
Feature: Route Manifest

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Fail Reservation on Route Manifest (uid:60dec2d6-20a2-4914-98fb-036c7591f834)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator waits for 1 seconds

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Reservation on Route Manifest (uid:b23ca49e-c64f-4b37-b327-f979e33615cc)
    Given Operator go to menu Shipper Support -> Blocked Dates
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

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Fail Pickup Transaction on Route Manifest (uid:4a9ab106-410e-49a3-bfb4-05ddbb4a670f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Pickup Transaction on Route Manifest (uid:c5e5ce6c-bf1b-4113-996a-6ab7ae0532de)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Fail Delivery Transaction on Route Manifest (uid:4154cb1e-4384-4fea-85fc-edb7bc5705be)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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

  @DeleteOrArchiveRoute
  Scenario: Operator Admin Manifest Force Success Delivery Transaction on Route Manifest (uid:cbfc2a8a-8cb9-455b-a837-0aeb20bf5bf9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver failed the delivery of the created parcel
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op