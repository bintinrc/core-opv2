@OperatorV2 @Core @NewFeatures @ImplantedManifestPart2 @NewFeatures1 @current2
Feature: Implanted Manifest

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid Reservation Status - Failed Reservation
    Given Operator go to menu Utilities -> QRCode Printing
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
    Then Operator verifies that error toast displayed:
      | top | Not a success reservation! |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | FAIL                             |
      | shipperName | {filter-shipper-name}            |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | scannedAtShipperCount | 0       |
      | scannedAtShipperPOD   | No data |

  @DeleteOrArchiveRoute
  Scenario: Operator Failed to Create Implanted Manifest Pickup - Reservation without POD Pickup
    Given Operator go to menu Utilities -> QRCode Printing
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
    Then Operator verifies that error toast displayed:
      | top | No POD available! |
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | SUCCESS                          |
      | shipperName | {filter-shipper-name}            |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | scannedAtShipperCount | 1                                          |
      | scannedAtShipperPOD   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Failed to Create Implanted Manifest Pickup - Total Scanned Orders != Total of POD
    Given Operator go to menu Utilities -> QRCode Printing
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
    Then Operator verifies that error toast displayed:
      | top | POD and Manifest parcel count do not match. |
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | SUCCESS                          |
      | shipperName | {filter-shipper-name}            |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | scannedAtShipperCount | 0       |
      | scannedAtShipperPOD   | No data |

  @DeleteOrArchiveRoute @happy-path @wip2
  Scenario: Operator Creates Implanted Manifest Pickup with Total Scanned Orders = Total of POD
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Core - Operator create reservation using data below:
      | reservationRequest | { "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId                  | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | waypointId               | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | parcels                  | []                                               |
      | routes                   | KEY_DRIVER_ROUTES                                |
      | jobType                  | RESERVATION                                      |
      | jobAction                | SUCCESS                                          |
      | jobMode                  | PICK_UP                                          |
      | totalUnmanifestedParcels | 2                                                |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" barcode on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" barcode on Implanted Manifest page
    When Operator creates manifest for "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that success react notification displayed:
      | top | Manifest has been created |
#    And Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
#      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
#      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
#      | type        | Normal                           |
#      | status      | SUCCESS                          |
#      | shipperName | {filter-shipper-name}            |
#    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
#    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
#      | inputOnPod            | 2                                                                           |
#      | scannedAtShipperCount | 2                                                                           |
#      | scannedAtShipperPOD   | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
#    And Operator verify order event on Edit order page using data below:
#      | name    | DRIVER PICKUP SCAN     |
#      | routeId | {KEY_CREATED_ROUTE_ID} |
#    And Operator verify order events on Edit order page using data below:
#      | tags          | name          | description                                                                                                                                                            |
#      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: En-route to Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: UPDATE_PICKUP_POD |
#    And Operator verify order events on Edit order page using data below:
#      | tags         | name                    | description                                                                                                                                                                                                  |
#      | PICKUP, SCAN | IMPLANTED MANIFEST SCAN | Implanted Manifest User: AUTOMATION EDITED ({operator-portal-uid}) Driver ID: {ninja-driver-id} Route ID: {KEY_CREATED_ROUTE_ID} Waypoint ID: {KEY_WAYPOINT_ID} Reservation ID: {KEY_CREATED_RESERVATION_ID} |
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
#    And Operator verify order event on Edit order page using data below:
#      | name    | DRIVER PICKUP SCAN     |
#      | routeId | {KEY_CREATED_ROUTE_ID} |
#    And Operator verify order events on Edit order page using data below:
#      | tags          | name          | description                                                                                                                                                            |
#      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: En-route to Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: UPDATE_PICKUP_POD |
#    And Operator verify order events on Edit order page using data below:
#      | tags         | name                    | description                                                                                                                                                                                                  |
#      | PICKUP, SCAN | IMPLANTED MANIFEST SCAN | Implanted Manifest User: AUTOMATION EDITED ({operator-portal-uid}) Driver ID: {ninja-driver-id} Route ID: {KEY_CREATED_ROUTE_ID} Waypoint ID: {KEY_WAYPOINT_ID} Reservation ID: {KEY_CREATED_RESERVATION_ID} |
#    And DB Operator verifies inbound_scans record for all orders with type "1" and correct route_id

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page - Multiple TID
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]},{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" barcode on Implanted Manifest page
    Then Operator verifies all scanned orders is listed on Manifest table and the info is correct

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page - Using Prefix - Multiple TID
    Given Operator go to menu Utilities -> QRCode Printing
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

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page with Invalid Tracking Id
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "INVALIDTRACKINGID" barcode on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error               |
      | bottom | Unknown Tracking ID |
    Then Operator verifies all scanned orders is listed on Manifest table and the info is correct
    When Operator creates manifest for "{KEY_CREATED_RESERVATION_ID}" reservation on Implanted Manifest page
    Then Operator verifies that error toast displayed:
      | top | Not a success reservation! |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | FAIL                             |
      | shipperName | {filter-shipper-name}            |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | scannedAtShipperCount | 0       |
      | scannedAtShipperPOD   | No data |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op