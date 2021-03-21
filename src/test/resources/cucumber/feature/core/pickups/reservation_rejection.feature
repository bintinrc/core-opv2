@OperatorV2 @Core @PickUps @ReservationRejection
Feature: Reservation Rejection

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Should be Able to Find Rejected Reservation on Reservation Rejection Page (uid:5555943c-371c-4bea-aeed-0755ef9369a4)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver reject Reservation
    When Operator go to menu Pick Ups -> Reservation Rejection
    Then Operator verifies the Reservation is listed on the table with correct information

  @DeleteOrArchiveRoute
  Scenario: Operator Should be Able to Fail Pickup a Rejected Reservation on Reservation Rejection Page (uid:641cd65f-236a-4c8d-8af4-d1ebfa18e66d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver reject Reservation
    When Operator go to menu Pick Ups -> Reservation Rejection
    And Operator fails the pickup
    Then Operator verifies pickup failed successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Should be Able to Re-assign a Rejected Reservation on Reservation Rejection Page (uid:cbd252c8-3bf1-4566-ae80-474de3866ed7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver reject Reservation
    When Operator go to menu Pick Ups -> Reservation Rejection
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Then Operator reassigns RSVN to new route
    And Operator verifies RSVN reassigned successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op