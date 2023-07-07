#@OperatorV2 @Core @PickUps @ShipperPickups @RoutingModules @Deprecated
Feature: Shipper Pickups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Filters Reservation by Reservation Type - Normal Reservation (uid:f622a44e-809f-442b-9461-574b180ebd44)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | type        | Normal                           |
    Then Operator verify reservation details on Shipper Pickups page:
      | id           | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | approxVolume | Less than 10 Parcels                     |
      | shipperName  | ^{shipper-v4-name}.*                     |
      | comments     | {KEY_CREATED_RESERVATION.comments}       |

  @DeleteOrArchiveRoute
  Scenario: Operator Verify Route Details of A Routed Reservation on Shipper Pickup Page (uid:15a1bd52-d4c5-4c31-a88e-3c4ca4619807)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify reservation details on Shipper Pickups page:
      | id           | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | approxVolume | Less than 10 Parcels                     |
      | shipperName  | ^{shipper-v4-name}.*                     |
      | comments     | {KEY_CREATED_RESERVATION.comments}       |
      | routeId      | {KEY_CREATED_ROUTE_ID}                   |
      | driverName   | {ninja-driver-name}                      |

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

  @DeleteOrArchiveRoute
  Scenario: Operator Edit Single Reservation Priority Level in Shipper Pickup Page (uid:5830302f-c452-49c4-bc59-28bb130e20ae)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator set the Priority Level of the created reservation to "3" from Apply Action
    When Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify reservation details on Shipper Pickups page:
      | id            | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | priorityLevel | 3                                        |

  Scenario: Operator Find Created Reservation by Shipper Name (uid:4d2d2a71-33e0-4f6c-846e-9cca10ef4c2b)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    Then Operator verify reservation details on Shipper Pickups page:
      | id          | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | shipperName | ^{shipper-v4-name}.*                     |
      | shipperId   | {shipper-v4-legacy-id}                   |

  Scenario: Operator Creates New Reservation by Duplicating Existing Reservation Details - Single Reservation (uid:2138a61e-e56b-4efb-9ced-7dfd92ea07f3)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator duplicates created reservation
    When Operator refresh page
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-next-1-day-yyyy-MM-dd} |
      | toDate      | {gradle-next-2-day-yyyy-MM-dd} |
      | shipperName | {filter-shipper-name}          |
    Then Operator verify reservation details on Shipper Pickups page:
      | shipperId              | {KEY_CREATED_RESERVATION.legacyShipperId}        |
      | shipperName            | ^{shipper-v4-name}.*                             |
      | pickupAddress          | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode} |
      | routeId                | null                                             |
      | driverName             | null                                             |
      | priorityLevel          | {KEY_CREATED_RESERVATION.priorityLevel}          |
      | readyBy                | not null                                         |
      | latestBy               | not null                                         |
      | reservationType        | REGULAR                                          |
      | reservationStatus      | PENDING                                          |
      | reservationCreatedTime | ^{gradle-current-date-yyyy-MM-dd}.*              |
      | serviceTime            | null                                             |
      | approxVolume           | {KEY_CREATED_RESERVATION.approxVolume}           |
      | failureReason          | null                                             |
      | comments               | {KEY_CREATED_RESERVATION.comments}               |

  Scenario: Operator Creates New Reservation by Duplicating Existing Reservation Details - Multiple Reservations (uid:aea00c1d-f550-4286-ba1a-5ed0f7369d2b)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    And Operator duplicates created reservations
    When Operator refresh page
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-next-1-day-yyyy-MM-dd} |
      | toDate      | {gradle-next-2-day-yyyy-MM-dd} |
      | shipperName | {filter-shipper-name}          |
    Then Operator verify reservations details on Shipper Pickups page:
      | shipperId              | shipperName          | pickupAddress                                                 | routeId | driverName | priorityLevel                                       | readyBy  | latestBy | reservationType | reservationStatus | reservationCreatedTime              | serviceTime | approxVolume                                       | failureReason | comments                                       |
      | {shipper-v4-legacy-id} | ^{shipper-v4-name}.* | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].priorityLevel} | not null | not null | REGULAR         | PENDING           | ^{gradle-current-date-yyyy-MM-dd}.* | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | null          | {KEY_LIST_OF_CREATED_RESERVATIONS[1].comments} |
      | {shipper-v4-legacy-id} | ^{shipper-v4-name}.* | {KEY_LIST_OF_CREATED_ADDRESSES[2].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[2].priorityLevel} | not null | not null | REGULAR         | PENDING           | ^{gradle-current-date-yyyy-MM-dd}.* | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[2].approxVolume} | null          | {KEY_LIST_OF_CREATED_RESERVATIONS[2].comments} |

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
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

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
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
  Scenario: Operator Filters Reservation by Hub Name (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id}    |
      | generateAddress | ZONE {zone-name-3} |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate | {gradle-current-date-yyyy-MM-dd} |
      | toDate   | {gradle-next-1-day-yyyy-MM-dd}   |
      | hub      | {hub-name-3}                     |
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | routeId                | driverName          |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Reservation by Zone Name
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id}    |
      | generateAddress | ZONE {zone-name-3} |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And DB Operator set "{zone-id-3}" routing_zone_id for waypoints:
      | {KEY_WAYPOINT_ID} |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate | {gradle-current-date-yyyy-MM-dd} |
      | toDate   | {gradle-next-1-day-yyyy-MM-dd}   |
      | zone     | {zone-full-name-3}               |
    Then Operator verify reservation details on Shipper Pickups page:
      | id          | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | shipperName | {shipper-v4-name}                        |
      | routeId     | null                                     |
      | driverName  | null                                     |

  Scenario: Operator Downloads Selected Reservations Details as CSV File (uid:77200c54-10f5-42e2-9575-60d1e365ae61)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And Operator download CSV file for created reservation
    Then Operator verify the reservation info is correct in downloaded CSV file

  Scenario: Operator Edits Priority Level on Bulk Action - Single Reservation (uid:4c10632f-b48e-4e09-a67f-f4763f6942d6)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator set the Priority Level of the created reservation to "2" from Apply Action
    When Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify reservation details on Shipper Pickups page:
      | id            | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | priorityLevel | 2                                        |
    And DB Operator verify reservation priority level
      | priorityLevel | 2 |

  Scenario: Operator Edits Priority Level on Bulk Action - Multiple Reservations (uid:8b24231a-34a4-493a-8a97-45b100e6888f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    And Operator set the Priority Level of the created reservations to "2" from Apply Action
    When Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | priorityLevel |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | 2             |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} | 2             |

  Scenario: Operator Edits Priority Level on Bulk Action - Multiple Reservations, Set to All Priority Level (uid:e994a33e-d5e8-4176-91b2-c7636f4ae1f6)
    Given Operator go to menu Utilities -> QRCode Printing
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
    And Operator set the Priority Level of the created reservations to "2" from Apply Action using "Set To All" option
    Then Operator verify the new reservations are listed on table in Shipper Pickups page using data below:
      | priorityLevel | 2 |

  Scenario: Operator Filters Reservation by Waypoint Status - PENDING (uid:f9641b05-1512-48f9-961d-b627e044c5a5)
    Given Operator go to menu Utilities -> QRCode Printing
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
      | status      | PENDING                          |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Reservation by Waypoint Status - ROUTED (uid:fec438e6-fc0a-4c0f-acd5-e49f27f6a285)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | ROUTED                           |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Reservation by Waypoint Status - SUCCESS (uid:a400c076-ada2-4e14-aabe-e9f888608373)
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
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}    |
      | approxVolume | Less than 10 Parcels |
    And Operator verifies reservation is finished using data below:
      | backgroundColor | #90ee90 |
      | status          | SUCCESS |

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Reservation by Waypoint Status - FAIL (uid:8e4d27a1-4d7b-4def-bd7b-2f758cb2deb4)
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
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}    |
      | approxVolume | Less than 10 Parcels |
    And Operator verifies reservation is finished using data below:
      | backgroundColor | #ffc0cb |
      | status          | FAIL    |

  Scenario: Operator Filters Reservation by Reservation Type - Premium Scheduled Reservation (uid:6693f2c8-ee4a-4592-8147-6dee8f4cebe5)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}","pickup_service_level":"Premium" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Premium Scheduled                |
      | shipperName | {filter-shipper-name}            |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}                  |
      | approxVolume | Less than 10 Parcels               |
      | comments     | {KEY_CREATED_RESERVATION.comments} |

  Scenario: Operator Filters Created Reservation by Master Shipper (uid:8977782b-6756-410b-86e7-c947d200eda9)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    And API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate          | {gradle-current-date-yyyy-MM-dd} |
      | toDate            | {gradle-next-1-day-yyyy-MM-dd}   |
      | masterShipperName | {shipper-v4-marketplace-name}    |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-marketplace-short-name} (ABC Shop) |
      | approxVolume | Less than 3 Parcels                            |
      | comments     | Please be careful with the v-day flowers.      |

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

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
  Scenario: Operator Bulk Suggest Route for Reservation on Shipper Pickup Page - Single Reservation, Suggested Route Found (uid:3a7616b6-5402-4cdb-9e10-2440f2fe8605)
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

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
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

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
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

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
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

  @DeleteOrArchiveRoute @SuggestRoute
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

  @DeleteOrArchiveRoute @SuggestRoute
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

  @DeleteOrArchiveRoute @SuggestRoute
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

  @DeleteOrArchiveRoute
  Scenario: Operator Force Finishes a Pending Reservation on Shipper Pickup Page - Success Reservation (uid:46685d49-fd6d-4234-b2a2-594bc411bbb3)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | ROUTED                           |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
    When Operator finish reservation with success
    Then Operator verifies reservation is finished using data below:
      | backgroundColor | #90ee90 |
      | status          | SUCCESS |
    When Operator refresh page
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | SUCCESS                          |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
    And Operator verify that "Finish" icon is disabled for created reservation on Shipper Pickups page

  @DeleteOrArchiveRoute
  Scenario: Operator Force Finishes a Pending Reservation on Shipper Pickup Page - Fail Reservation (uid:42df2c09-16b2-4081-a325-00e8aaffada3)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | ROUTED                           |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
    When Operator finish reservation with failure
    Then Operator verifies reservation is finished using data below:
      | backgroundColor | #ffc0cb |
      | status          | FAIL    |
    When Operator refresh page
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | FAIL                             |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}    |
      | approxVolume | Less than 10 Parcels |
    And Operator verify that "Finish" icon is disabled for created reservation on Shipper Pickups page

  Scenario: Operator Not Allowed to Force Finish a Unrouted Pending Reservation on Shipper Pickup Page (uid:d4b2cd45-a14f-4abe-ad1e-45313e6a0e87)
    Given Operator go to menu Utilities -> QRCode Printing
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
    Then Operator verify that "Finish" icon is disabled for created reservation on Shipper Pickups page

  @DeleteOrArchiveRoute
  Scenario: Operator Refresh List Routes on Shipper Pickup Page (uid:1c1ca03b-1e89-49fc-892d-5eff53431aed)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator refresh routes on Shipper Pickups page
    And Operator assign Reservation to Route on Shipper Pickups page
    Then Operator verify reservation details on Shipper Pickups page:
      | id           | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | approxVolume | Less than 10 Parcels                     |
      | routeId      | {KEY_CREATED_ROUTE_ID}                   |
      | driverName   | {ninja-driver-name}                      |
      | comments     | {KEY_CREATED_RESERVATION.comments}       |

  @DeleteOrArchiveRoute
  Scenario: Operator Views POD Details of a Success Reservation (uid:117cd772-7cdc-4fcb-acaa-fe4e3c5160a6)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | SUCCESS                          |
      | shipperName | {filter-shipper-name}            |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | timestamp             | {gradle-current-date-yyyy-MM-dd}           |
      | inputOnPod            | 1                                          |
      | scannedAtShipperCount | 1                                          |
      | scannedAtShipperPOD   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator verifies POD details in POD Details dialog on Shipper Pickups page using data below:
      | reservationId  | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | recipientName  | {KEY_CREATED_RESERVATION.name}           |
      | shipperId      | {shipper-v4-legacy-id}                   |
      | shipperName    | {shipper-v4-name}                        |
      | shipperContact | {shipper-v4-contact}                     |
      | status         | SUCCESS                                  |
    And Operator verifies downloaded POD CSV file on Shipper Pickups page using data below:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Views POD Details of a Fail  Reservation (uid:7f550afc-5682-4a0a-9d68-536763ea5153)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | FAIL                             |
      | shipperName | {filter-shipper-name}            |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | timestamp             | {gradle-current-date-yyyy-MM-dd} |
      | inputOnPod            | 0                                |
      | scannedAtShipperCount | 0                                |
      | scannedAtShipperPOD   | No data                          |
    And Operator verifies POD details in POD Details dialog on Shipper Pickups page using data below:
      | reservationId  | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | recipientName  | -                                        |
      | shipperId      | {shipper-v4-legacy-id}                   |
      | shipperName    | {shipper-v4-name}                        |
      | shipperContact | {shipper-v4-contact}                     |
      | status         | FAIL                                     |
    And Operator verifies downloaded POD CSV file on Shipper Pickups page contains no details

  Scenario: Operator Views POD Details of a Pending Reservation with no POD (uid:2b350b24-e984-4596-b867-fc232a4abf2e)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | shipperName | {filter-shipper-name}            |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD not found in Reservation Details dialog on Shipper Pickups page

  Scenario: Operator Edits Pending Reservation Address Details (uid:5fb61b34-8fdd-45a6-84a3-b2e5148e0bd4)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And Operator edit reservation address details on Edit Route Details dialog using data below:
      | oldAddress | KEY_LIST_OF_CREATED_ADDRESSES[1] |
      | newAddress | KEY_LIST_OF_CREATED_ADDRESSES[2] |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | address      | KEY_LIST_OF_CREATED_ADDRESSES[2] |
      | shipperName  | {shipper-v4-name}                |
      | approxVolume | Less than 3 Parcels              |
      | comments     | GET_FROM_CREATED_RESERVATION     |

  @DeleteOrArchiveRoute
  Scenario: Operator Not Allowed to Edit Attempted Reservation Address Details - Success Reservation (uid:80f2356d-5010-4291-9463-fae61a6207a1)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
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
    Then Operator verify that "Route Edit" icon is disabled for created reservation on Shipper Pickups page

  @DeleteOrArchiveRoute
  Scenario: Operator Not Allowed to Edit Attempted Reservation Address Details - Fail Reservation (uid:416311c2-e9b0-4b34-a3a3-e00d7152dd2f)
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
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify that "Route Edit" icon is disabled for created reservation on Shipper Pickups page

#    TODO DISABLED
#  @DeleteFilterTemplate
#  Scenario: Operator Save A New Preset on Shipper Pickup Page (uid:98a6abc9-a9d8-4e6d-abe0-bfef4a13cf99)
#    Given Operator go to menu Utilities -> QRCode Printing
#    When Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator selects filters on Shipper Pickups page:
#      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd}     |
#      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd}     |
#      | reservationTypes    | Hyperlocal                         |
#      | waypointStatus      | ROUTED                             |
#      | shipper             | {filter-shipper-name}              |
#      | masterShipper       | {shipper-v4-marketplace-legacy-id} |
#    And Operator selects "Save Current as Preset" preset action on Shipper Pickups page
#    Then Operator verifies Save Preset dialog on Shipper Pickups page contains filters:
#      | Reservation Date: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd} |
#      | Reservation Types: Hyperlocal                                                      |
#      | Waypoint Status: ROUTED                                                            |
#      | Shipper: {shipper-v4-legacy-id}-{shipper-v4-name}                                  |
#      | Master Shipper: {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name}   |
#    And Operator verifies Preset Name field in Save Preset dialog on Shipper Pickups page is required
#    And Operator verifies Cancel button in Save Preset dialog on Shipper Pickups page is enabled
#    And Operator verifies Save button in Save Preset dialog on Shipper Pickups page is disabled
#    When Operator enters "PRESET {gradle-current-date-yyyyMMddHHmmsss}" Preset Name in Save Preset dialog on Shipper Pickups page
#    Then Operator verifies Preset Name field in Save Preset dialog on Shipper Pickups page has green checkmark on it
#    And Operator verifies Save button in Save Preset dialog on Shipper Pickups page is enabled
#    When Operator clicks Save button in Save Preset dialog on Shipper Pickups page
#    Then Operator verifies that success toast displayed:
#      | top                | 1 filter preset created                         |
#      | bottom             | Name: {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME} |
#      | waitUntilInvisible | true                                            |
#    And Operator verifies selected Filter Preset name is "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" on Shipper Pickups page
#    And DB Operator verifies filter preset record:
#      | id        | {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_ID}   |
#      | namespace | shipper-pickups                           |
#      | name      | {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME} |
#    When Operator refresh page
#    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
#    Then Operator verifies selected filters on Shipper Pickups page:
#      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd}                                   |
#      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd}                                   |
#      | reservationTypes    | Hyperlocal                                                       |
#      | waypointStatus      | ROUTED                                                           |
#      | shipper             | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
#      | masterShipper       | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @DeleteFilterTemplate
  Scenario: Operator Apply Filter Preset on Shipper Pickup Page (uid:e27277c3-d95b-4bf8-a674-3705501cca51)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}               |
      | value.reservationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}               |
      | value.typeIds             | 0                                            |
      | value.waypointStatuses    | Pending,Routed                               |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    Then Operator verifies selected filters on Shipper Pickups page:
      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | reservationTypes    | Normal                         |
      | waypointStatus      | PENDING,ROUTED                 |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on Shipper Pickup Page (uid:d04a7955-2339-46e3-909c-454895f7aa3a)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}               |
      | value.reservationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}               |
      | value.typeIds             | 0                                            |
      | value.waypointStatuses    | Pending,Routed                               |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator selects "Delete Preset" preset action on Shipper Pickups page
    Then Operator verifies Cancel button in Delete Preset dialog on Shipper Pickups page is enabled
    And Operator verifies Delete button in Delete Preset dialog on Shipper Pickups page is disabled
    When Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" preset in Delete Preset dialog on Shipper Pickups page
    Then Operator verifies "Preset \"{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}\" will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on Shipper Pickups page
    When Operator clicks Delete button in Delete Preset dialog on Shipper Pickups page
    Then Operator verifies that warning toast displayed:
      | top    | 1 filter preset deleted                     |
      | bottom | ID: {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_ID} |
    And DB Operator verifies "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_ID}" filter preset is deleted

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Update Preset button on Shipper Pickup Page (uid:66e0d2dd-da74-471f-aa0b-51bd4cc3fb29)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}               |
      | value.reservationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}               |
      | value.typeIds             | 0                                            |
      | value.waypointStatuses    | Pending,Routed                               |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    And Operator updates filters on Shipper Pickups page:
      | waypointStatus | FAIL, SUCCESS         |
      | zones          | {zone-id}-{zone-name} |
    And Operator selects "Save Current as Preset" preset action on Shipper Pickups page
    Then Operator verifies Save Preset dialog on Shipper Pickups page contains filters:
      | Reservation Date: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd} |
      | Reservation Types: Normal                                                          |
      | Waypoint Status: FAIL, SUCCESS                                                     |
      | Zones: {zone-id}-{zone-name}                                                       |
    When Operator enters "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Preset Name in Save Preset dialog on Shipper Pickups page
    Then Operator verifies help text "This name is already taken. Do you want to update this preset?" is displayed in Save Preset dialog on Shipper Pickups page
    When Operator clicks Update button in Save Preset dialog on Shipper Pickups page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                         |
      | bottom             | Name: {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                            |
    When Operator refresh page
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    Then Operator verifies selected filters on Shipper Pickups page:
      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | reservationTypes    | Normal                         |
      | waypointStatus      | FAIL, SUCCESS                  |
      | zones               | {zone-id}-{zone-name}          |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Save Current As Preset button on Shipper Pickup Page (uid:333771f0-fe1b-4544-94fb-fe7d9f4d625c)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}               |
      | value.reservationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}               |
      | value.typeIds             | 0                                            |
      | value.waypointStatuses    | Pending,Routed                               |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    And Operator updates filters on Shipper Pickups page:
      | waypointStatus | FAIL, SUCCESS         |
      | zones          | {zone-id}-{zone-name} |
    And Operator selects "Update Preset" preset action on Shipper Pickups page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                         |
      | bottom             | Name: {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                            |
    When Operator refresh page
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    Then Operator verifies selected filters on Shipper Pickups page:
      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | reservationTypes    | Normal                         |
      | waypointStatus      | FAIL, SUCCESS                  |
      | zones               | {zone-id}-{zone-name}          |

  Scenario: Operator Search Single Reservation by Reservation Id on Shipper Pickup Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator enter reservation ids on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verifies that there is "1 reservation IDs entered" shown under the search field on Shipper Pickups page
    When Operator clicks Search by Reservation IDs on Shipper Pickups page
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | shipperId              | shipperName                                                                              | pickupAddress                                                 | routeId | driverName | priorityLevel                                       | readyBy                                                        | latestBy                                                        | reservationType | reservationStatus | reservationCreatedTime | serviceTime | approxVolume                                       | failureReason | comments                                       |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {shipper-v4-legacy-id} | {shipper-v4-name} - {shipper-v4-contact} ({KEY_LIST_OF_CREATED_RESERVATIONS[1].contact}) | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].priorityLevel} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedLatestDatetime} | REGULAR         | PENDING           | not null               | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | -             | {KEY_LIST_OF_CREATED_RESERVATIONS[1].comments} |

  Scenario: Operator Search Multiple Less Than 30 Reservations by Reservation Ids on Shipper Pickup Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator enter reservation ids on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    Then Operator verifies that there is "2 reservation IDs entered" shown under the search field on Shipper Pickups page
    When Operator clicks Search by Reservation IDs on Shipper Pickups page
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | shipperId              | shipperName                                                                              | pickupAddress                                                 | routeId | driverName | priorityLevel                                       | readyBy                                                        | latestBy                                                        | reservationType | reservationStatus | reservationCreatedTime | serviceTime | approxVolume                                       | failureReason | comments                                       |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {shipper-v4-legacy-id} | {shipper-v4-name} - {shipper-v4-contact} ({KEY_LIST_OF_CREATED_RESERVATIONS[1].contact}) | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].priorityLevel} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedLatestDatetime} | REGULAR         | PENDING           | not null               | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | -             | {KEY_LIST_OF_CREATED_RESERVATIONS[1].comments} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} | {shipper-v4-legacy-id} | {shipper-v4-name} - {shipper-v4-contact} ({KEY_LIST_OF_CREATED_RESERVATIONS[2].contact}) | {KEY_LIST_OF_CREATED_ADDRESSES[2].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[2].priorityLevel} | {KEY_LIST_OF_CREATED_RESERVATIONS[2].toDisplayedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[2].toDisplayedLatestDatetime} | REGULAR         | PENDING           | not null               | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[2].approxVolume} | -             | {KEY_LIST_OF_CREATED_RESERVATIONS[2].comments} |

  Scenario: Operator Search Multiple More Than 30 Reservations by Reservation Ids on Shipper Pickup Page
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator enters 31 reservation ids on Shipper Pickups page
    Then Operator verifies that there is "31 reservation IDs entered" shown under the search field on Shipper Pickups page
    When Operator clicks Search by Reservation IDs on Shipper Pickups page
    Then Operator verifies that error toast displayed:
      | top | We cannot process more than 30 reservations |

  Scenario: Operator Search Duplicate Reservation by Reservation Id on Shipper Pickup Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator enter reservation ids on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verifies that there is "2 reservation IDs entered 1 duplicate" shown under the search field on Shipper Pickups page
    When Operator clicks Search by Reservation IDs on Shipper Pickups page
    Then Operator verify exactly reservations details on Shipper Pickups page:
      | id                                       | shipperId              | shipperName                                                                              | pickupAddress                                                 | routeId | driverName | priorityLevel                                       | readyBy                                                        | latestBy                                                        | reservationType | reservationStatus | reservationCreatedTime | serviceTime | approxVolume                                       | failureReason | comments                                       |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {shipper-v4-legacy-id} | {shipper-v4-name} - {shipper-v4-contact} ({KEY_LIST_OF_CREATED_RESERVATIONS[1].contact}) | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].priorityLevel} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedLatestDatetime} | REGULAR         | PENDING           | not null               | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | -             | {KEY_LIST_OF_CREATED_RESERVATIONS[1].comments} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op