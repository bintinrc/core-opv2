#@OperatorV2 @Core @ShipperPickups @ShipperPickups2 @ViewPickupPOD @Deprecated
Feature: Shipper Pickups - View PODs Reservation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
