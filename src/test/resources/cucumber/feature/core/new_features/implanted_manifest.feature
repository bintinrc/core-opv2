@OperatorV2 @Core @NewFeatures @ImplantedManifest
Feature: Implanted Manifest

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Scan All Orders and Download & Verifies CSV File Info on Implanted Manifest Page (uid:cd7f3ec4-3887-4f61-b057-d40ae8a56d5b)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    And Operator clicks "Download CSV File" on Implanted Manifest
    Then Operator verifies the file is downloaded successfully and contains all scanned orders with correct info

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page (uid:fb17a389-4f54-45b7-b5f1-c12a830d6aa8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    Then Operator verifies all scanned orders is listed on Manifest table and the info is correct

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page and Remove Scanned Order by Scanning (uid:ca1314b5-661a-4dc7-b144-8b897e4d54b0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    And Operator do "Remove order by Scan" for all created orders on Implanted Manifest page
    Then Operator verifies all scanned orders is removed from the Manifest table

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page and Remove All Scanned Orders by Remove All Button (uid:5284e3dc-43ab-4336-b395-6ee7c46be8ed)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    And Operator clicks "Remove All" button on Implanted Manifest page
    Then Operator verifies all scanned orders is removed from the Manifest table

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page and Remove All Scanned Orders by X Button (uid:b18d3f25-98d9-4d76-bb5b-3c92c8e9bada)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    And Operator clicks "Actions X" button on Manifest table for all created orders on Implanted Manifest page
    Then Operator verifies all scanned orders is removed from the Manifest table

  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid Reservation Id (uid:28477458-a062-40b7-b512-1d9acff22efa)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_CREATED_ORDER_TRACKING_ID}" barcode on Implanted Manifest page
    Then Operator verifies all scanned orders is listed on Manifest table and the info is correct
    When Operator creates manifest for "000000" reservation on Implanted Manifest page
    Then Operator verifies that "Reservation ID not found! Please enter another Reservation ID" error toast message is displayed

  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid Reservation Status - Pending Reservation (uid:f88b803e-3992-4c04-8cf7-de10e37aaa9e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_CREATED_ORDER_TRACKING_ID}" barcode on Implanted Manifest page
    Then Operator verifies all scanned orders is listed on Manifest table and the info is correct
    When Operator creates manifest for "{KEY_CREATED_RESERVATION_ID}" reservation on Implanted Manifest page
    Then Operator verifies that "Not a success reservation!" error toast message is displayed
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | shipperName | {shipper-v4-name}                |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD not found in Reservation Details dialog on Shipper Pickups page

  @DeleteOrArchiveRoute
  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid Reservation Status - Failed Reservation (uid:8365b0e2-1c23-4b1f-a560-0f3f49f8f645)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And Operator admin manifest force fail reservation
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 7           |
      | failureReasonIndexMode | FIRST       |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_CREATED_ORDER_TRACKING_ID}" barcode on Implanted Manifest page
    Then Operator verifies all scanned orders is listed on Manifest table and the info is correct
    When Operator creates manifest for "{KEY_CREATED_RESERVATION_ID}" reservation on Implanted Manifest page
    Then Operator verifies that "Not a success reservation!" error toast message is displayed
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | FAIL                             |
      | shipperName | {shipper-v4-name}                |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | scannedAtShipperCount | 0       |
      | scannedAtShipperPOD   | No data |

  @DeleteOrArchiveRoute
  Scenario: Operator Failed to Create Implanted Manifest Pickup - Reservation without POD Pickup (uid:1b598216-2d81-4ad9-8d40-7852ae149df0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
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
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" barcode on Implanted Manifest page
    When Operator creates manifest for "{KEY_CREATED_RESERVATION_ID}" reservation on Implanted Manifest page
    Then Operator verifies that "No POD available!" error toast message is displayed
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | SUCCESS                          |
      | shipperName | {shipper-v4-name}                |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | scannedAtShipperCount | 1                                          |
      | scannedAtShipperPOD   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Failed to Create Implanted Manifest Pickup - Total Scanned Orders != Total of POD (uid:995601b8-52cc-4d28-b1b1-3bf4f1e33a57)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 1                                                                                                                                                                                                                                                                                                                                |
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
    And Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator success reservation waypoint from Route Manifest page
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" barcode on Implanted Manifest page
    When Operator creates manifest for "{KEY_CREATED_RESERVATION_ID}" reservation on Implanted Manifest page
    Then Operator verifies that "POD and Manifest parcel count do not match." error toast message is displayed
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | SUCCESS                          |
      | shipperName | {shipper-v4-name}                |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | scannedAtShipperCount | 0       |
      | scannedAtShipperPOD   | No data |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Creates Implanted Manifest Pickup with Total Scanned Orders = Total of POD (uid:9840426a-a1f5-4864-8ecf-3747f7b55e52)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
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
    And API Driver success Reservation by NOT scanning order using data below:
      | reservationId  | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId        | {KEY_CREATED_ROUTE_ID}                   |
      | pickupQuantity | 2                                        |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" barcode on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" barcode on Implanted Manifest page
    When Operator creates manifest for "{KEY_CREATED_RESERVATION_ID}" reservation on Implanted Manifest page
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | SUCCESS                          |
      | shipperName | {shipper-v4-name}                |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | inputOnPod            | 2                                                                                     |
      | scannedAtShipperCount | 2                                                                                     |
      | scannedAtShipperPOD   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]},{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER PICKUP SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER PICKUP SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies inbound_scans record for all orders with type "1" and correct route_id

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page - Multiple TID (uid:027dfab6-19b3-4157-af2e-7e924ed45660)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]},{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" barcode on Implanted Manifest page
    Then Operator verifies all scanned orders is listed on Manifest table and the info is correct

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page - Using Prefix - Multiple TID (uid:8ef03b8e-c48f-458a-8755-84a9dafc4ae7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator saves created orders Tracking IDs without prefix
    And Operator adds country prefix on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_ORDER_PREFIXLESS_TRACKING_ID[1]},{KEY_LIST_OF_CREATED_ORDER_PREFIXLESS_TRACKING_ID[2]}" barcode on Implanted Manifest page
    Then Operator verifies all scanned orders is listed on Manifest table and the info is correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op