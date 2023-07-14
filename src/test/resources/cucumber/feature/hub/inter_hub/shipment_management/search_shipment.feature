@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @SearchShipment
Feature: Shipment Management - Search Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments
  Scenario: Search Shipment by ID - Search <= 30 Shipments with Invalid Shipment (uid:bc7c0cdf-fbcb-4db2-8c0d-a16b39e617a5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    When API MM - Operator creates multiple 2 new shipments with type "LAND_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
      | 111111111                                |
    Then Operator verifies that search error modal shown with shipment ids:
      | 111111111 |
    And Operator click Show Shipments button in Search Error dialog on Shipment Management Page
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |

  @DeleteCreatedShipments
  Scenario: Search Shipment by ID - Search <= 30 Shipments with Empty Line (uid:a2945cf0-7404-427f-80f9-7feb06288d75)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given API MM - Operator creates multiple 2 new shipments with type "LAND_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | {empty}                                  |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |

  @DeleteShipmentFilterPreset
  Scenario: Preset Setting - Save Current Shipment Filter as Preset (uid:81c46be2-466f-4c5f-b7ba-d1f15d05ddc9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator apply filters on Shipment Management Page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |
    And Operator save current filters as preset on Shipment Management page
    And Operator refresh page
    Then Operator select "{KEY_MM_LIST_OF_CREATED_SHIPMENT_FILTER_PRESETS[1].name}" filters preset on Shipment Management page
    And Operator verify selected filters on Shipment Management page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |

  @DeleteShipmentFilterPreset
  Scenario: Preset Setting - Delete Shipment Filter as Preset (uid:c722664d-4ef4-4f13-92d6-5074a3dde4f5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator save current filters as preset on Shipment Management page
    And Operator delete filters preset "KEY_MM_LIST_OF_CREATED_SHIPMENT_FILTER_PRESETS[1]" on Shipment Management page
    And Operator refresh page
    Then Operator verify filters preset was deleted

  @DeleteCreatedShipments
  Scenario Outline: Search Shipment by Filter - <scenarioName>
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When Operator apply filters on Shipment Management Page:
      | <filterName> | <filterValue> |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Pending                                  |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |
    Examples:
      | scenarioName    | filterName     | filterValue  |
      | Origin Hub      | originHub      | {hub-name}   |
      | Destination Hub | destinationHub | {hub-name-2} |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Type : Air Haul
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Air Haul |
      | shipmentStatus | Pending  |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Pending                                  |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Type : Land Haul
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Land Haul |
      | shipmentStatus | Pending   |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | LAND_HAUL                                |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Pending                                  |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Type : Sea Haul
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 1 new shipments with type "SEA_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Sea Haul |
      | shipmentStatus | Pending  |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | SEA_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Pending                                  |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Type : Others
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 1 new shipments with type "OTHERS" from hub id "{hub-id}" to "{hub-id-2}"
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Others  |
      | shipmentStatus | Pending |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | OTHERS                                   |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Pending                                  |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Status : Pending
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Air Haul |
      | shipmentStatus | Pending  |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Pending                                  |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Status : Closed
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    Given Operator waits for 5 seconds
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Air Haul |
      | shipmentStatus | Closed   |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Closed                                   |
      | origHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Status : Transit
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    Given Operator waits for 5 seconds
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Air Haul |
      | shipmentStatus | Transit  |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Transit                                  |
      | origHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments @DeleteMiddleMileDriver @DeleteCreatedPorts @ForceCompleteCreatedMovementTrips
  Scenario: Search Shipment by Filter - Shipment Status : Transit to Airport
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    Given Operator waits for 5 seconds
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"

    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{hub-id}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."}                                                                                                                                                                      |
      | extraData   | {"drivers":[{"driver_id":{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id},"primary":true,"username":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}","license_expiry_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].licenseExpiryDate}","employment_start_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentStartDate}","employment_end_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentEndDate}"}]} |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator refresh page
    When API MM - Operator refreshes these movement trips details "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS"
    When API MM - Operator scan inbound single shipment to movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]":
      | scanType   | SHIPMENT_VAN_INBOUND                     |
      | scanValue  | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | actionType | ADD                                      |
    When API MM - Operator end shipment inbound with movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]":
      | scanType | SHIPMENT_VAN_INBOUND                               |
      | driverId | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id} |
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Air Haul           |
      | shipmentStatus | Transit to Airport |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Transit to Airport                       |
      | userId       | {operator-portal-uid}                    |
      | origHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Status : At Transit Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    Given Operator waits for 5 seconds
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{hub-id}" to "{hub-relation-origin-hub-id}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-relation-destination-hub-id}        |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-relation-origin-hub-id}                                                                                  |
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Land Haul      |
      | shipmentStatus | At Transit Hub |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | LAND_HAUL                                |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | At Transit Hub                           |
      | userId       | {operator-portal-uid}                    |
      | origHubName  | {hub-name}                               |
      | destHubName  | {hub-relation-origin-hub-name}           |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Status : Completed
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    Given Operator waits for 5 seconds
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-2}                               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id-2}                                                                                                    |
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Air Haul  |
      | shipmentStatus | Completed |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Completed                                |
      | userId       | {operator-portal-uid}                    |
      | origHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Status : Cancelled
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When API MM - Operator updates shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" status to "Cancelled"
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Air Haul  |
      | shipmentStatus | Cancelled |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Cancelled                                |
      | userId       | {operator-portal-uid}                    |
      | origHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentDate | {gradle-previous-1-day-yyyy-MM-dd}:00:00,{gradle-current-date-yyyy-MM-dd}:23:30 |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Pending                                  |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  Scenario: Search Shipment by ID - Search <= 30 Shipments Separated by Coma (,) or Space (uid:373d0602-6f7f-4669-afbb-e606dc6fa5d2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given API MM - Operator creates multiple 2 new shipments with type "LAND_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | ,                                        |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
    Then Operator verifies that error react notification displayed:
      | top    | SERVER_ERROR_EXCEPTION                                                     |
      | bottom | ^.*Error Message: Cannot parse parameter id as Long: For input string: "," |

  @DeleteCreatedShipments
  Scenario: Shipment Details (uid:839a572a-8534-4456-8340-b615174dc29c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    Given Operator waits for 5 seconds
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator open the shipment detail for shipment id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" on Shipment Management Page
    Then Operator opens Shipment Details page for shipment "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op