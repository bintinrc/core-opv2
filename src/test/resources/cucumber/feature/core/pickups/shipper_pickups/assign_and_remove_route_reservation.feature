@OperatorV2 @Core @ShipperPickups @ShipperPickups1 @runsuggestroute
Feature: Shipper Pickups - Assign & Remove Route Reservation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Assign a Pending Reservation to a Driver Route (uid:f8c61882-5430-4d7a-aaa9-3e4c97f52b13)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator refresh routes on Shipper Pickups page
    And Operator assign Reservation to Route on Shipper Pickups page
    Then Operator verify reservation details on Shipper Pickups page:
      | id           | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | approxVolume | Less than 10 Parcels                     |
      | shipperName  | ^{shipper-v4-name}.*                     |
      | comments     | {KEY_CREATED_RESERVATION.comments}       |
      | routeId      | {KEY_CREATED_ROUTE_ID}                   |
      | driverName   | {ninja-driver-name}                      |
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies waypoints.seq_no is the same as route_waypoint.seq_no for each waypoint
    And DB Operator verifies route_monitoring_data record
    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    Then Verify that waypoints are shown on driver "{ninja-driver-id}" list route correctly

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Removes Reservation from Route on Edit Route Details (uid:b79d861a-625d-4273-a405-d2a08e68859b)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator removes reservation from route from Edit Route Details dialog
    And Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | routeId | driverName |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | null    | null       |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute @runsuggestroute1
  Scenario: Operator Add Reservation to Driver Route Using Bulk Action Suggest Route - Single Reservation (uid:9d6f1456-f96a-4ac8-a38b-bb0ddbe8740b)
    # For a route to be able to be suggested to a RSVN, it should have at least 1 waypoint.
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator use the Route Suggestion to add created reservations to the route using data below:
      | routeTagName | {KEY_CREATED_ROUTE_TAG.name} |
    And Operator refresh routes on Shipper Pickups page
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | routeId                | driverName          |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute @runsuggestroute1
  Scenario: Operator Add Reservation to Driver Route Using Bulk Action Suggest Route - Multiple Reservations (uid:e1d9c28e-57d9-48c5-b43d-752165695637)
    # For a route to be able to be suggested to a RSVN, it should have at least 1 waypoint.
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2                  |
      | shipperId         | {shipper-v4-id}    |
      | generateAddress   | ZONE {zone-name-3} |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    And Operator use the Route Suggestion to add created reservations to the route using data below:
      | routeTagName | {KEY_CREATED_ROUTE_TAG.name} |
    And Operator refresh routes on Shipper Pickups page
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | routeId                | driverName          |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Removes Driver Route of Routed Reservation - Single Reservation (uid:cce1d21c-a238-4a46-b622-dcc8820f8ce1)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator removes the route from the created reservations
    And Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | routeId | driverName |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | null    | null       |

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute @runsuggestroute1
  Scenario: Operator Bulk Suggest Route for Reservation on Shipper Pickup Page - Single Reservations, Suggested Route Found
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And Operator use the Route Suggestion to add created reservation to the route using data below:
      | routeTagName | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v4-name}      |
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute @runsuggestroute1
  Scenario: Operator Bulk Suggest Route for Reservation on Shipper Pickup Page - Multiple Reservations, Suggested Route Found (uid:b4da89d4-6041-4649-9b00-89b54671bcac)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And Operator use the Route Suggestion to add created reservations to the route using data below:
      | routeTagName | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verify the new reservations are listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v4-name}      |
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute @runsuggestroute1
  Scenario: Operator Bulk Suggest Route for Reservation on Shipper Pickup Page - Single Reservation, No Suggested Route Found (uid:f59fc4ef-b127-4fc6-8eac-4f5a53bbf2cf)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And Operator select Route Tags for Route Suggestion of created reservation using data below:
      | routeTagName | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verifies that "No waypoints to suggest after filtering!" error toast message is displayed
    And Operator verifies no route suggested for selected reservations

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute @runsuggestroute1
  Scenario: Operator Bulk Suggest Route for Reservation on Shipper Pickup Page - Multiple Reservations, No Suggested Route Found (uid:4911902f-a1a4-4b4a-9a5b-6705728fcfb6)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator retrieve routes using data below:
      | tagIds | {route-tag-id} |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And Operator select Route Tags for Route Suggestion of created reservations using data below:
      | routeTagName | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verifies that "No waypoints to suggest after filtering!" error toast message is displayed
    And Operator verifies no route suggested for selected reservations

  @DeleteOrArchiveRoute @SuggestRoute @runsuggestroute1
  Scenario: Operator Failed to Bulk Suggest Route - Routed Reservation (uid:ffa0334b-b5af-4d1f-a0b9-6a0529090828)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | ROUTED                           |
    And Operator select "Suggest Route" action for created reservations on Shipper Pickup page
    Then Operator verifies that "No Valid Reservation Selected" error toast message is displayed

  @DeleteOrArchiveRoute @SuggestRoute @runsuggestroute1
  Scenario: Operator Failed to Bulk Suggest Route - Success Reservation (uid:0d89c71c-51e5-4519-93f5-16f0fd81922c)
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
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | SUCCESS                          |
    And Operator select "Suggest Route" action for created reservations on Shipper Pickup page
    Then Operator verifies that "No Valid Reservation Selected" error toast message is displayed

  @DeleteOrArchiveRoute @SuggestRoute @runsuggestroute1
  Scenario: Operator Failed to Bulk Suggest Route - Failed Reservation (uid:252dbcbb-832f-4a82-89b0-4ffed96b83d2)
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
    And API Operator start the route
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | FAIL                             |
    And Operator select "Suggest Route" action for created reservations on Shipper Pickup page
    Then Operator verifies that "No Valid Reservation Selected" error toast message is displayed

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Removes Driver Route of Routed Reservation - Multiple Reservations (uid:b4d16fb8-edb0-4dca-b31d-416e58232e45)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-ups to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    And Operator removes the route from the created reservations
    And Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | routeId | driverName |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | null    | null       |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} | null    | null       |

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Assign Route to Reservation on Shipper Pickup Page - Single Reservation (uid:4726c81c-43f9-4ac4-a10b-d1778d2c4cdf)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And Operator switch on Bulk Assign Route toggle on Shipper Pickups page
    Then Operator verify that Bulk Route Assignment Side Panel is shown on Shipper Pickups page
    When Operator select created reservations on Shipper Pickup page
    Then Operator verify that title of Bulk Route Assignment Side Panel is "1/100 RSVN selected"
    And Operator verify reservations data in Bulk Route Assignment Side Panel using data below:
      | title             | description                                                   | subtitle                                 |
      | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    When Operator select "{KEY_CREATED_ROUTE_ID}" route in Bulk Route Assignment Side Panel
    And Operator click Bulk Assign button in Bulk Route Assignment Side Panel
    Then Operator verifies that "Bulk Assignment is successful" success toast message is displayed
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
      | routeId      | GET_FROM_CREATED_ROUTE       |
      | driverName   | {ninja-driver-name}          |

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Assign Route to Reservation on Shipper Pickup Page - Multiple Reservations (uid:644c21ea-190c-4475-b846-3eda37ad0066)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And Operator switch on Bulk Assign Route toggle on Shipper Pickups page
    Then Operator verify that Bulk Route Assignment Side Panel is shown on Shipper Pickups page
    When Operator select created reservations on Shipper Pickup page
    Then Operator verify that title of Bulk Route Assignment Side Panel is "2/100 RSVN selected"
    And Operator verify reservations data in Bulk Route Assignment Side Panel using data below:
      | title             | description                                                   | subtitle                                 |
      | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ADDRESSES[2].to1LineAddressWithPostcode} | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    When Operator delete 1 reservation in Bulk Route Assignment Side Panel
    Then Operator verify that title of Bulk Route Assignment Side Panel is "1/100 RSVN selected"
    And Operator verify reservations data in Bulk Route Assignment Side Panel using data below:
      | title             | description                                                   | subtitle                                 |
      | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ADDRESSES[2].to1LineAddressWithPostcode} | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    When Operator select "{KEY_CREATED_ROUTE_ID}" route in Bulk Route Assignment Side Panel
    And Operator click Bulk Assign button in Bulk Route Assignment Side Panel
    Then Operator verifies that "Bulk Assignment is successful" success toast message is displayed
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v4-name}      |
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |

  @DeleteOrArchiveRoute
  Scenario: Operator Not Allowed to Bulk Assign Route on Shipper Pickup Page - Routed Reservation (uid:032a6e28-2a95-4fe8-89bb-381f3505e86f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | ROUTED                           |
    And Operator select created reservations on Shipper Pickup page
    And Operator switch on Bulk Assign Route toggle on Shipper Pickups page
    Then Operator verify that Bulk Route Assignment Side Panel is shown on Shipper Pickups page
    And Operator verify that title of Bulk Route Assignment Side Panel is "0/100 RSVN selected"
    And Operator verify that reservation checkbox is not selected on Shipper Pickups page

  @DeleteOrArchiveRoute
  Scenario: Operator Not Allowed to Bulk Assign Route on Shipper Pickup Page - Failed Reservation (uid:0ebc72de-06b0-4e64-a561-0aa853522ddf)
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
    And API Operator start the route
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | FAIL                             |
    And Operator select created reservations on Shipper Pickup page
    And Operator switch on Bulk Assign Route toggle on Shipper Pickups page
    Then Operator verify that Bulk Route Assignment Side Panel is shown on Shipper Pickups page
    And Operator verify that title of Bulk Route Assignment Side Panel is "0/100 RSVN selected"
    And Operator verify that reservation checkbox is not selected on Shipper Pickups page

  @DeleteOrArchiveRoute
  Scenario: Operator Not Allowed to Bulk Assign Route on Shipper Pickup Page - Success Reservation (uid:886f246b-547d-4137-b07f-f908264ff835)
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
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | SUCCESS                          |
    And Operator select created reservations on Shipper Pickup page
    And Operator switch on Bulk Assign Route toggle on Shipper Pickups page
    Then Operator verify that Bulk Route Assignment Side Panel is shown on Shipper Pickups page
    And Operator verify that title of Bulk Route Assignment Side Panel is "0/100 RSVN selected"
    And Operator verify that reservation checkbox is not selected on Shipper Pickups page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
