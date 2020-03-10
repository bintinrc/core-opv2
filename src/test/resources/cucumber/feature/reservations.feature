@OperatorV2 @OperatorV2Part1 @Reservations @Saas
Feature: Reservations

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator create new Reservation (uid:b2a5084c-16f9-42ce-9203-131574e5f3d2)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    When Operator go to menu Shipper Support -> Reservations
    And Operator create new Reservation using data below:
      | shipperName  | {shipper-v4-name}   |
      | timeslot     | 9AM-12PM            |
      | approxVolume | Less than 3 Parcels |
    Then Operator verify the new Reservation is created successfully
      | expectedTimeslotTextOnCalendar | 9:00 AM - 12:00 PM |

  Scenario: Operator create and edit Reservation (uid:a7b7630f-5723-45c4-9575-1b9ed572be17)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Shipper Support -> Reservations
    And Operator create new Reservation using data below:
      | shipperName  | {shipper-v4-name}   |
      | timeslot     | 9AM-12PM            |
      | approxVolume | Less than 3 Parcels |
    Then Operator verify the new Reservation is created successfully
      | expectedTimeslotTextOnCalendar | 9:00 AM - 12:00 PM |
    When Operator update the new Reservation using data below:
      | timeslot | 12PM-3PM |
    Then Operator verify the new Reservation is updated successfully
      | expectedTimeslotTextOnCalendar | 12:00 PM - 3:00 PM |

  Scenario: Operator create and delete Reservation (uid:4d256cf6-cada-491d-855f-900e7f01c8d6)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Shipper Support -> Reservations
    And Operator create new Reservation using data below:
      | shipperName  | {shipper-v4-name}   |
      | timeslot     | 9AM-12PM            |
      | approxVolume | Less than 3 Parcels |
    Then Operator verify the new Reservation is created successfully
      | expectedTimeslotTextOnCalendar | 9:00 AM - 12:00 PM |
    When Operator delete the new Reservation
    Then Operator verify the new Reservation is deleted successfully

  Scenario: Operator create, edit, and delete Reservation (uid:7d8deed7-7ccd-4d29-8645-16aa43a90931)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Shipper Support -> Reservations
    And Operator create new Reservation using data below:
      | shipperName  | {shipper-v4-name}   |
      | timeslot     | 9AM-12PM            |
      | approxVolume | Less than 3 Parcels |
    Then Operator verify the new Reservation is created successfully
      | expectedTimeslotTextOnCalendar | 9:00 AM - 12:00 PM |
    When Operator update the new Reservation using data below:
      | timeslot | 12PM-3PM |
    Then Operator verify the new Reservation is updated successfully
      | expectedTimeslotTextOnCalendar | 12:00 PM - 3:00 PM |
    When Operator delete the new Reservation
    Then Operator verify the new Reservation is deleted successfully

  @DeleteOrArchiveRoute
  Scenario: Operator fails a normal reservation (uid:a7c0111d-924b-4626-86bf-16c7fa05b917)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 3 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    And Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | TODAY             |
      | toDate      | TOMORROW          |
      | type        | Normal            |
      | shipperName | {shipper-v4-name} |
    And Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 3 Parcels          |
      | comments     | GET_FROM_CREATED_RESERVATION |
      | routeId      | GET_FROM_CREATED_ROUTE       |
      | driverName   | {ninja-driver-name}          |
    When Operator finish reservation with failure
    Then Operator verifies reservation is finished using data below:
      | backgroundColor | #ffc0cb |
      | status          | FAIL    |
    And DB Operator verifies reservation record using data below:
      | status | 2 |
    And DB Operator verifies waypoint record using data below:
      | status | Fail |

  @DeleteOrArchiveRoute
  Scenario: Operator finishes a normal reservation with success (uid:e6644334-79ee-413a-9d07-e5a7fbac14d3)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 3 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    And Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | TODAY             |
      | toDate      | TOMORROW          |
      | type        | Normal            |
      | shipperName | {shipper-v4-name} |
    And Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 3 Parcels          |
      | comments     | GET_FROM_CREATED_RESERVATION |
      | routeId      | GET_FROM_CREATED_ROUTE       |
      | driverName   | {ninja-driver-name}          |
    And Operator finish reservation with success
    Then Operator verifies reservation is finished using data below:
      | backgroundColor | #90ee90 |
      | status          | SUCCESS |
    And DB Operator verifies reservation record using data below:
      | status | 1 |
    And DB Operator verifies waypoint record using data below:
      | status | Success |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
