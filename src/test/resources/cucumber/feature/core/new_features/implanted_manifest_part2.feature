@OperatorV2 @CancelCreatedReservations @Core @NewFeatures @ImplantedManifest @ImplantedManifestPart2
Feature: Implanted Manifest

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid Reservation Status - Failed Reservation
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Core - Operator force fail waypoint via route manifest:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | failureReasonId | 7                                                |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 0 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 0 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" barcode on Implanted Manifest page
    Then Operator verify scanned orders on Implanted Manifest page:
      | trackingId                          | scannedAt                          | destination                                                                           | rackSector                                 | addressee                              |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] | ^{date: 0 days next, yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |
    When Operator creates manifest for "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error                      |
      | bottom | Not a success reservation! |
    And API Core - Operator verify pods in pickup details of reservation id below:
      | id                           | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | pods[1].shipperScansQuantity | 0                                        |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Failed to Create Implanted Manifest Pickup - Reservation without POD Pickup
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 0 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 0 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                               |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                 |
      | routes     | KEY_DRIVER_ROUTES                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS"}] |
      | jobType    | RESERVATION                                                                      |
      | jobAction  | SUCCESS                                                                          |
      | jobMode    | PICK_UP                                                                          |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" barcode on Implanted Manifest page
    When Operator creates manifest for "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error             |
      | bottom | No POD available! |


  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Failed to Create Implanted Manifest Pickup - Total Scanned Orders != Total of POD
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 0 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 0 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And API Core - Operator force success waypoint via route manifest:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" barcode on Implanted Manifest page
    When Operator creates manifest for "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error                                       |
      | bottom | POD and Manifest parcel count do not match. |
    And API Core - Operator verify pods in pickup details of reservation id below:
      | id                           | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | pods[1].shipperScansQuantity | 0                                        |

  @ArchiveRouteCommonV2 @happy-path @HighPriority
  Scenario: Operator Creates Implanted Manifest Pickup with Total Scanned Orders = Total of POD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Core - Operator create reservation using data below:
      | reservationRequest | { "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
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
        # Verify Order 1
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER PICKUP SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                            |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: En-route to Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: UPDATE_PICKUP_POD |
    And Operator verify order events on Edit Order V2 page using data below:
      | name                    | description                                                                                                                                                                                                                                                         |
      | IMPLANTED MANIFEST SCAN | Implanted Manifest User: AUTOMATION EDITED ({operator-portal-uid}) Driver ID: {ninja-driver-id} Route ID: {KEY_LIST_OF_CREATED_ROUTES[1].id} Waypoint ID: {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} Reservation ID: {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    # Verify Order 2
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER PICKUP SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                            |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: En-route to Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: UPDATE_PICKUP_POD |
    And Operator verify order events on Edit Order V2 page using data below:
      | name                    | description                                                                                                                                                                                                                                                         |
      | IMPLANTED MANIFEST SCAN | Implanted Manifest User: AUTOMATION EDITED ({operator-portal-uid}) Driver ID: {ninja-driver-id} Route ID: {KEY_LIST_OF_CREATED_ROUTES[1].id} Waypoint ID: {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} Reservation ID: {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And DB Core - Operator verifies inbound_scans record:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}                     |
      | type     | 1                                                      |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                     |
      | location | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddress} |
    And DB Core - Operator verifies inbound_scans record:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id}                     |
      | type     | 1                                                      |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                     |
      | location | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddress} |


  @HighPriority
  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page - Multiple TID
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 0 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 0 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" barcode on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" barcode on Implanted Manifest page
    Then Operator verify scanned orders on Implanted Manifest page:
      | trackingId                          | scannedAt                          | destination                                                                           | rackSector                                 | addressee                              |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] | ^{date: 0 days next, yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] | ^{date: 0 days next, yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[2].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[2].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} |


  @MediumPriority
  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page - Using Prefix - Multiple TID
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 0 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 0 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator saves created orders Tracking IDs without prefix
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator adds country prefix on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_ORDER_PREFIXLESS_TRACKING_ID[1]}" barcode on Implanted Manifest page
    And Operator scans "{KEY_LIST_OF_CREATED_ORDER_PREFIXLESS_TRACKING_ID[2]}" barcode on Implanted Manifest page
    Then Operator verify scanned orders on Implanted Manifest page:
      | trackingId                          | scannedAt                          | destination                                                                           | rackSector                                 | addressee                              |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] | ^{date: 0 days next, yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] | ^{date: 0 days next, yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[2].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[2].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} |

  @MediumPriority
  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page with Invalid Tracking Id
    When Operator go to menu New Features -> Implanted Manifest
    And Operator selects "{hub-name}" hub on Implanted Manifest page
    And Operator clicks Create Manifest on Implanted Manifest page
    And Operator scan barcodes on Implanted Manifest page:
      | INVALIDTRACKINGID |
    Then Operator verifies that error react notification displayed:
      | top    | Error               |
      | bottom | Unknown Tracking ID |
    Then Operator verify scanned orders on Implanted Manifest page:
      | trackingId        | scannedAt                          | destination | rackSector | addressee |
      | INVALIDTRACKINGID | ^{date: 0 days next, yyyy-MM-dd}.* | NOT FOUND   | NOT FOUND  | NOT FOUND |
    And Operator verify rack sector details on Implanted Manifest page:
      | rackSector | -                 |
      | stamp      | INVALIDTRACKINGID |


  @MediumPriority
  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page with Duplicate Tracking Id
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 0 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 0 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verify rack sector details on Implanted Manifest page:
      | rackSector | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} |
      | stamp      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}      |
    Then Operator verify scanned orders on Implanted Manifest page:
      | trackingId                          | scannedAt                          | destination                                                                           | rackSector                                 | addressee                              |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] | ^{date: 0 days next, yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |
    When Operator scan barcodes on Implanted Manifest page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verifies that error react notification displayed:
      | top    | Error                 |
      | bottom | Duplicate Tracking ID |
    Then Operator verify scanned orders on Implanted Manifest page:
      | trackingId                          | scannedAt                          | destination                                                                           | rackSector                                 | addressee                              |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] | ^{date: 0 days next, yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |


  @MediumPriority
  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page with Non-Pending Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 0 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 0 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Completed                          |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verifies that error react notification displayed:
      | top    | Error                                                           |
      | bottom | Parcel already exists in the system. Granular status: Completed |
    Then Operator verifies orders are not presented on Implanted Manifest page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
