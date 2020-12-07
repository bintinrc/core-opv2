@OperatorV2 @Core @PickUps @ShipperPickups
Feature: Shipper Pickups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Filters Reservation by Reservation Type - Normal Reservation (uid:f622a44e-809f-442b-9461-574b180ebd44)
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
  Scenario: Operator Verify Route Details of A Routed Reservation on Shipper Pickup Page (uid:15a1bd52-d4c5-4c31-a88e-3c4ca4619807)
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
  Scenario: Operator Assign a Pending Reservation to a Driver Route (uid:f8c61882-5430-4d7a-aaa9-3e4c97f52b13)
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
  Scenario: Operator Assign Reservation to a Driver Route with Priority Level (uid:5830302f-c452-49c4-bc59-28bb130e20ae)
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

  Scenario: Operator Find Created Reservation by Shipper Name (uid:4d2d2a71-33e0-4f6c-846e-9cca10ef4c2b)
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

  Scenario: Operator Creates New Reservation by Duplicating Existing Reservation Details - Single Reservation (uid:2138a61e-e56b-4efb-9ced-7dfd92ea07f3)
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

  Scenario: Operator Creates New Reservation by Duplicating Existing Reservation Details - Multiple Reservations (uid:aea00c1d-f550-4286-ba1a-5ed0f7369d2b)
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
  Scenario: Operator Add Reservation to Driver Route Using Bulk Action Suggest Route - Single Reservation (uid:9d6f1456-f96a-4ac8-a38b-bb0ddbe8740b)
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
  Scenario: Operator Add Reservation to Driver Route Using Bulk Action Suggest Route - Multiple Reservations (uid:e1d9c28e-57d9-48c5-b43d-752165695637)
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
  Scenario: Operator Bulk Removes Driver Route of Routed Reservation - Single Reservation (uid:cce1d21c-a238-4a46-b622-dcc8820f8ce1)
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
  Scenario: Operator Bulk Removes Driver Route of Routed Reservation - Multiple Reservations (uid:b4d16fb8-edb0-4dca-b31d-416e58232e45)
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
  Scenario Outline: Operator Filters Reservation by - <Note> (<hiptest-uid>)
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
      | Note      | hiptest-uid                              | hubId    | hubName    | zoneId    | zoneName            |
      | Hub Name  | uid:f524560a-9fce-4255-b811-b8d61afa3b79 | {hub-id} | {hub-name} | {zone-id} |                     |
      | Zone Name | uid:7f1be87e-f830-4288-87d5-5cafd8602619 | {hub-id} |            | 569       | DRIVER-APP-MSI-ZONE |

  Scenario: Operator Downloads Selected Reservations Details as CSV File (uid:77200c54-10f5-42e2-9575-60d1e365ae61)
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

  Scenario: Operator Edits Priority Level on Bulk Action - Single Reservation (uid:4c10632f-b48e-4e09-a67f-f4763f6942d6)
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

  Scenario: Operator Edits Priority Level on Bulk Action - Multiple Reservations (uid:8b24231a-34a4-493a-8a97-45b100e6888f)
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

  Scenario: Operator Edits Priority Level on Bulk Action - Multiple Reservations, Set to All Priority Level (uid:e994a33e-d5e8-4176-91b2-c7636f4ae1f6)
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

  Scenario: Operator Filters Reservation by Waypoint Status - PENDING (uid:f9641b05-1512-48f9-961d-b627e044c5a5)
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
  Scenario: Operator Filters Reservation by Waypoint Status - ROUTED (uid:fec438e6-fc0a-4c0f-acd5-e49f27f6a285)
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
  Scenario: Operator Filters Reservation by Waypoint Status - SUCCESS (uid:a400c076-ada2-4e14-aabe-e9f888608373)
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
  Scenario: Operator Filters Reservation by Waypoint Status - FAIL (uid:8e4d27a1-4d7b-4def-bd7b-2f758cb2deb4)
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

  Scenario: Operator Filters Reservation by Reservation Type - Premium Scheduled Reservation (uid:6693f2c8-ee4a-4592-8147-6dee8f4cebe5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
      | pickupServiceTypeLevels      | Scheduled:Premium     |
    And API Operator fetch id of the created shipper
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {KEY_CREATED_SHIPPER.id} |
      | generateAddress | RANDOM                   |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{KEY_CREATED_SHIPPER.legacyId}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}","pickup_service_level":"Premium" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | TODAY                      |
      | toDate      | TOMORROW                   |
      | type        | Premium Scheduled          |
      | shipperName | {KEY_CREATED_SHIPPER.name} |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {KEY_CREATED_SHIPPER.name}         |
      | approxVolume | Less than 10 Parcels               |
      | comments     | {KEY_CREATED_RESERVATION.comments} |

  @DeleteOrArchiveRoute
  Scenario: Operator Removes Reservation from Route on Edit Route Details (uid:b79d861a-625d-4273-a405-d2a08e68859b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator removes reservation from route from Edit Route Details dialog
    Then Operator verify the route was removed from the created reservation

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Suggest Route for Reservation on Shipper Pickup Page - Single Reservation, Suggested Route Found (uid:3a7616b6-5402-4cdb-9e10-2440f2fe8605)
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
      | routeId     | {KEY_SUGGESTED_ROUTE.id} |
      | driverName  | GET_FROM_SUGGESTED_ROUTE |

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Suggest Route for Reservation on Shipper Pickup Page - Single Reservation, No Suggested Route Found (uid:f59fc4ef-b127-4fc6-8eac-4f5a53bbf2cf)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
    And Operator select Route Tags for Route Suggestion of created reservation using data below:
      | routeTagName | AAA |
    Then Operator verifies that "No waypoints to suggest after filtering!" error toast message is displayed
    And Operator verifies no route suggested for selected reservations

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Suggest Route for Reservation on Shipper Pickup Page - Multiple Reservations, Suggested Route Found (uid:b4da89d4-6041-4649-9b00-89b54671bcac)
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
  Scenario: Operator Bulk Suggest Route for Reservation on Shipper Pickup Page - Multiple Reservations, No Suggested Route Found (uid:4911902f-a1a4-4b4a-9a5b-6705728fcfb6)
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
    And Operator select Route Tags for Route Suggestion of created reservations using data below:
      | routeTagName | AAA |
    Then Operator verifies that "No waypoints to suggest after filtering!" error toast message is displayed
    And Operator verifies no route suggested for selected reservations

  @DeleteOrArchiveRoute
  Scenario: Operator Failed to Bulk Suggest Route - Routed Reservation (uid:ffa0334b-b5af-4d1f-a0b9-6a0529090828)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
      | waypointStatus       | ROUTED                           |
    And Operator select "Suggest Route" action for created reservations on Shipper Pickup page
    Then Operator verifies that "No Valid Reservation Selected" error toast message is displayed

  @DeleteOrArchiveRoute
  Scenario: Operator Failed to Bulk Suggest Route - Success Reservation (uid:0d89c71c-51e5-4519-93f5-16f0fd81922c)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
      | waypointStatus       | SUCCESS                          |
    And Operator select "Suggest Route" action for created reservations on Shipper Pickup page
    Then Operator verifies that "No Valid Reservation Selected" error toast message is displayed

  @DeleteOrArchiveRoute
  Scenario: Operator Failed to Bulk Suggest Route - Failed Reservation (uid:252dbcbb-832f-4a82-89b0-4ffed96b83d2)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Operator set filters using data below and click Load Selection on Shipper Pickups page:
      | reservationDateStart | {gradle-current-date-yyyy-MM-dd} |
      | reservationDateEnd   | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName          | {shipper-v4-name}                |
      | waypointStatus       | FAIL                             |
    And Operator select "Suggest Route" action for created reservations on Shipper Pickup page
    Then Operator verifies that "No Valid Reservation Selected" error toast message is displayed


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
