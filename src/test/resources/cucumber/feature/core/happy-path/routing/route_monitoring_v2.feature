@OperatorV2 @Core @Routing @RouteMonitoringV2 @happy-path
Feature: Route Monitoring V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Delivery (uid:45e0b063-386d-4e9a-aa55-6258b968fe2e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}               |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}   |
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

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup (uid:d90eb775-2b4b-42aa-96c7-9a090d49cf64)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}               |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}   |
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
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Waypoints - Pickup, Delivery & Reservation Under the Same Route (uid:0aa5f6f9-0176-4fde-a2f1-01087f4a037d)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator start the route
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
    Then Route Monitoring V2 page is loaded
    When Operator search order on Route Monitoring V2 using data below:
      | hubs    | {hub-name}               |
      | zones   | {zone-short-name}({zone-name}) |
      | routeId | {KEY_CREATED_ROUTE_ID}   |
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op