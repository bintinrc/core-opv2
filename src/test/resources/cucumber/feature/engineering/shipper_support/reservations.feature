@OperatorV2 @Engineering @ShipperSupport @Reservations
Feature: Reservations

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteReservationsAndAddresses
  Scenario: Create Reservation - Create one Reservation in one address (uid:015f6c41-d6ae-4548-8e3a-e40a244f8edf)
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

  @DeleteReservationsAndAddresses
  Scenario: Update Reservation Scheduled for Today (uid:bdbb75f3-da34-4169-9496-b66265867a84)
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

  @DeleteReservationsAndAddresses
  Scenario: Delete Reservation for Today (uid:eeccf9f1-73e1-4e23-a020-272f775e8986)
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

  @DeleteOrArchiveRoute
  Scenario: Fail Reservation (uid:f68dda3c-4869-400d-9168-7266177ac1be)
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
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | shipperName | {shipper-v4-name}                |
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
  Scenario: Success Reservation (uid:3a5f9759-9805-4055-acae-6116dc451b22)
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
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | shipperName | {shipper-v4-name}                |
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
