@OperatorV2 @Core @NewFeatures @ImplantedManifest @ImplantedManifestPart1
Feature: Implanted Manifest

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Scan All Orders and Download & Verifies CSV File Info on Implanted Manifest Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks 'Download CSV File' on Implanted Manifest page
    Then Operator verifies CSV file for "{hub-name}" hub is downloaded successfully on Implanted Manifest page:
      | trackingId                          | address                                                                               | rackSector                                 | toName                                 |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[2].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[2].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} |

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Then Operator verify scanned orders on Implanted Manifest page:
      | trackingId                          | scannedAt                           | destination                                                                           | rackSector                                 | addressee                              |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] | ^{gradle-current-date-yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] | ^{gradle-current-date-yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[2].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[2].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} |

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page and Remove Scanned Order by Scanning
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator removes order by scan on Implanted Manifest page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Then Operator verifies orders are removed on Implanted Manifest page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page and Remove All Scanned Orders by Remove All Button
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator remove all scanned orders on Implanted Manifest page
    Then Operator verifies that success react notification displayed:
      | top | All scanned item has been deleted |
    Then Operator verifies orders are removed on Implanted Manifest page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page and Remove All Scanned Orders by X Button
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator removes scanned orders on Implanted Manifest page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Then Operator verifies orders are removed on Implanted Manifest page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |

  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid Reservation Id
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify scanned orders on Implanted Manifest page:
      | trackingId                          | scannedAt                           | destination                                                                           | rackSector                                 | addressee                              |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] | ^{gradle-current-date-yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |
    When Operator creates manifest for "1" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error                                                    |
      | bottom | Reservation or Job ID not found! Please enter another ID |

  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid Reservation Status - Pending Reservation
    Given Operator go to menu Utilities -> QRCode Printing
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
    Then Operator verify scanned orders on Implanted Manifest page:
      | trackingId                          | scannedAt                           | destination                                                                           | rackSector                                 | addressee                              |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] | ^{gradle-current-date-yyyy-MM-dd}.* | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |
    When Operator creates manifest for "{KEY_CREATED_RESERVATION_ID}" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error                      |
      | bottom | Not a success reservation! |
    Then API Core - Operator verify there is no pods assigned to reservation id "{KEY_CREATED_RESERVATION_ID}"