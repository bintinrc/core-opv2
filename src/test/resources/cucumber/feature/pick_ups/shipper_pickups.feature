@OperatorV2 @Core @PickUps @ShipperPickups
Feature: Shipper Pickups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator find Normal Reservation on Shipper Pickups page (uid:877efac2-803a-4c50-a1d4-5e9792ff5490)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |

  @DeleteOrArchiveRoute
  Scenario: Operator add Reservation to Route using API and verify the Reservation info is correct (uid:b8b62011-882f-451b-9331-6cec2077aab2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
      | routeId      | GET_FROM_CREATED_ROUTE       |
      | driverName   | {ninja-driver-name}          |
    And DB Operator verify new record is created in route_waypoints table with the correct details

  @DeleteOrArchiveRoute
  Scenario: Operator assign Reservation to Route on Shipper Pickups page (uid:992f1485-ef00-45cc-88d8-df36a3e4e77d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    When Operator refresh routes on Shipper Pickups page
    When Operator assign Reservation to Route on Shipper Pickups page
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
      | routeId      | GET_FROM_CREATED_ROUTE       |
      | driverName   | {ninja-driver-name}          |
    And DB Operator verify new record is created in route_waypoints table with the correct details

  @DeleteOrArchiveRoute
  Scenario: Operator assign Reservation to Route with priority level on Shipper Pickups page (uid:4e1e8b2b-ddad-48c4-98ea-b1f5a5ef448c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    When Operator refresh routes on Shipper Pickups page
    When Operator assign Reservation to Route with priority level = "3" on Shipper Pickups page
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName   | {shipper-v4-name}            |
      | approxVolume  | Less than 10 Parcels         |
      | comments      | GET_FROM_CREATED_RESERVATION |
      | routeId       | GET_FROM_CREATED_ROUTE       |
      | driverName    | {ninja-driver-name}          |
      | priorityLevel | 3                            |
    And DB Operator verify new record is created in route_waypoints table with the correct details

  Scenario: Operator create and verify the reservations details is correct on Shipper Pickups page (uid:acc59c88-9da5-4990-9a48-26c23ba7e464)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    Then Operator verify the reservations details is correct on Shipper Pickups page using data below:
      | shipperName   | {shipper-v4-name}            |
      | shipperId     | {shipper-v4-legacy-id}       |
      | reservationId | GET_FROM_CREATED_RESERVATION |

  Scenario: Operator should be able to create/duplicate single reservation on Shipper Pickups page (uid:37a2c9b1-7f8f-41e8-a0a9-52f57b69bcdc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator duplicates created reservation
    Then Operator verify the duplicated reservation is created successfully

  Scenario: Operator should be able to create/duplicate multiple reservations on Shipper Pickups page (uid:e974f8e8-498c-4602-a63e-2560902ff343)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator duplicates created reservations
    Then Operator verify the duplicated reservations are created successfully

  @DeleteOrArchiveRoute
  Scenario: Operator should be able to use the Route Suggestion and add single reservation to the route on Shipper Pickups page (uid:87eaa63d-5f66-4bc7-b425-ebf33ab47392)
    # For a route to be able to be suggested to a RSVN, it should have at least 1 waypoint.
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [{route-tag-id}]
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Operator retrieve routes using data below:
      | tagIds | {route-tag-id} |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator use the Route Suggestion to add created reservation to the route using data below:
      | routeTagName | {route-tag-name} |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v4-name}        |
      | routeId     | GET_FROM_SUGGESTED_ROUTE |
      | driverName  | GET_FROM_SUGGESTED_ROUTE |

  @DeleteOrArchiveRoute
  Scenario: Operator should be able to use the Route Suggestion and add multiple reservations to the route on Shipper Pickups page (uid:b5ffe64a-0143-4d66-aa5d-82d9be1f9ff4)
    # For a route to be able to be suggested to a RSVN, it should have at least 1 waypoint.
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [{route-tag-id}]
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Operator retrieve routes using data below:
      | tagIds | {route-tag-id} |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator use the Route Suggestion to add created reservations to the route using data below:
      | routeTagName | {route-tag-name} |
    Then Operator verify the new reservations are listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v4-name}        |
      | routeId     | GET_FROM_SUGGESTED_ROUTE |
      | driverName  | GET_FROM_SUGGESTED_ROUTE |

  @DeleteOrArchiveRoute
  Scenario: Operator should be able to remove the route from single reservation on Shipper Pickups page (uid:b96dab27-cb75-4696-a6fd-fed6c40b5caa)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator removes the route from the created reservation
    Then Operator verify the route was removed from the created reservation

  @DeleteOrArchiveRoute
  Scenario: Operator should be able to remove the route from multiple reservations on Shipper Pickups page (uid:8bd44522-4d95-4fb9-8dba-5819de6171b9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-ups to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator removes the route from the created reservations
    Then Operator verify the route was removed from the created reservations

  @DeleteOrArchiveRoute
  Scenario Outline: Operator should be able to filter the Shipper Pickups by parameters (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":<zoneId>, "hubId":<hubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate | TODAY      |
      | toDate   | TOMORROW   |
      | hub      | <hubName>  |
      | zone     | <zoneName> |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v4-name}      |
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |
    Examples:
      | Note     | hiptest-uid                              | hubId    | hubName    | zoneId    | zoneName |
      | Params 1 | uid:619b39f4-1a64-4abe-8b8f-916e7509d129 | {hub-id} | {hub-name} | {zone-id} |          |
#     In the step "API Operator create new route using data below" zone of a created route doesn't match to requested zone,
#     So, it's not possible to find created pickup by zone name
#      | Params 2 | uid:579e00c4-0612-4c55-91b3-26d29a8fec8a | {hub-id} |            | 569       | DRIVER-APP-MSI-ZONE |

  Scenario: Operator should be able to download CSV file on Shipper Pickups page (uid:1214e548-8996-403a-a58c-043ed5c642d9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator download CSV file for created reservation
    Then Operator verify the reservation info is correct in downloaded CSV file

  Scenario: Operator should be able to edit the Priority Level of single reservation on Shipper Pickups page (uid:a9630dc0-ce00-4caf-aced-c6dedc59b76b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator set the Priority Level of the created reservation to "2" from Apply Action
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | priorityLevel | 2 |
    And DB Operator verify reservation priority level
      | priorityLevel | 2 |

  Scenario: Operator should be able to edit the Priority Level of multiple reservation on Shipper Pickups page (uid:1ef31434-423d-417c-955e-051d5b203a65)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator set the Priority Level of the created reservations to "2" from Apply Action
    Then Operator verify the new reservations are listed on table in Shipper Pickups page using data below:
      | priorityLevel | 2 |

  Scenario: Operator should be able to edit the Priority Level of multiple reservation on Shipper Pickups page using "Set To All" option (uid:f68f5816-325a-425f-9dc8-656cfe75038d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator set the Priority Level of the created reservations to "2" from Apply Action using "Set To All" option
    Then Operator verify the new reservations are listed on table in Shipper Pickups page using data below:
      | priorityLevel | 2 |

  Scenario: Operator filters using Waypoint Status filter - PENDING (uid:ece39130-5b50-4025-afc2-9cf08aea30c0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
      | waypointStatus       | PENDING                          |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |

  @DeleteOrArchiveRoute
  Scenario: Operator filters using Waypoint Status filter - ROUTED (uid:4c0f6b60-7c52-4d93-98ac-30c642318fbf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
      | waypointStatus       | ROUTED                           |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |

  @DeleteOrArchiveRoute
  Scenario: Operator filters using Waypoint Status filter - SUCCESS (uid:90724128-68ff-4b66-a30a-8f9808aa0f37)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
      | waypointStatus       | ROUTED                           |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
    When Operator finish reservation with success
    Then Operator verifies reservation is finished using data below:
      | backgroundColor | #90ee90 |
      | status          | SUCCESS |
    When Operator refresh page
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
      | waypointStatus       | SUCCESS                          |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |

  @DeleteOrArchiveRoute
  Scenario: Operator filters using Waypoint Status filter - FAIL (uid:3de9fd64-efa9-4dad-bb91-e78cf1a7a65d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
      | waypointStatus       | ROUTED                           |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
    When Operator finish reservation with failure
    Then Operator verifies reservation is finished using data below:
      | backgroundColor | #ffc0cb |
      | status          | FAIL    |
    When Operator refresh page
    When Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
      | waypointStatus       | FAIL                             |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}    |
      | approxVolume | Less than 10 Parcels |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
