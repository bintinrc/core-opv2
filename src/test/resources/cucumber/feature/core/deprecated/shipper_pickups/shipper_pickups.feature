#@OperatorV2 @Core @ShipperPickups @ShipperPickups2 @Deprecated
Feature: Shipper Pickups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

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
  Scenario: Show Updated Driver Name on Routed Reservation in Shipper Pickup Page
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
      | id         | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId    | {KEY_CREATED_ROUTE_ID}                   |
      | driverName | {ninja-driver-name}                      |
    And Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator edits details of created route using data below:
      | driverName | {ninja-driver-2-name} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 Route(s) Updated |
      | waitUntilInvisible | true               |
    And Operator waits for 5 seconds
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify reservation details on Shipper Pickups page:
      | id         | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId    | {KEY_CREATED_ROUTE_ID}                   |
      | driverName | {ninja-driver-2-name}                    |
    And DB Operator verifies shipper_pickups_search data updated correctly
      | driver_id | {ninja-driver-2-id} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
