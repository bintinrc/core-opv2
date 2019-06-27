@OperatorV2 @OperatorV2Part1 @ReservationRejection
Feature: Reservation Preset Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator should be able to find rejected Reservation on Reservation Rejection page (uid:b40f142b-c87b-4630-9562-43521bd5cde0)
    Given Operator go to menu Order -> All Orders
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator create new shipper address V2 using data below:
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
  Scenario: Operator should be able to Fail pickup a Rejected Reservation on Reservation Rejection page (uid:e637b2b9-2520-489d-8790-1886d3758373)
    Given Operator go to menu Order -> All Orders
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator create new shipper address V2 using data below:
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
  Scenario: Operator should be able to Re-assign a Rejected Reservation on Reservation Rejection page (uid:b1698d74-da98-4320-837b-d00e3bd340e5)
    Given API Operator create new route using data below:
    | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator create new shipper address V2 using data below:
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
    And Operator reassigns RSVN to new route
    And Operator verifies RSVN reassigned successfully

@KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
