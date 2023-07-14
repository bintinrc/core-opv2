@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @SearchShipment2
Feature: Shipment Management - Search Shipment 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - MAWB (uid:59cc8df2-47e0-46c4-9ca6-08179b099a02)
    When Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API MM - Link single or multiple shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" to AWB "RANDOM" with "airport" id from "{airport-id-1}" to "{airport-id-2}" and vendor id "{vendor-id}"
    When Operator apply filters on Shipment Management Page:
      | mawb | {KEY_MM_LIST_OF_CREATED_MAWBS[1]} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Pending                                  |
      | userId       | {operator-portal-uid}                    |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |
      | mawb         | {KEY_MM_LIST_OF_CREATED_MAWBS[1]}        |

  @wip @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Shipment Completion (uid:9667bb60-0933-49e3-8879-2bdac54aae68)
    Given Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
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
      | shipmentStatus         | Completed                                                                  |
      | shipmentCompletionDate | {date: 1 days ago, yyyy-MM-dd}:00:00,{date: 0 days next, yyyy-MM-dd}:23:30 |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Completed                                |
      | userId       | {operator-portal-uid}                    |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name-2}                             |
      | destHubName  | {hub-name-2}                             |

  @wip @DeleteCreatedShipments
  Scenario: Search Shipment by Filter - Transit Date Time (uid:d78f101e-c251-46ec-9b14-0eef64804627)
    Given Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
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
    And Operator waits for 5 seconds
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id-2}                                                                                                    |
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus  | Transit                                                                    |
      | transitDateTime | {date: 1 days ago, yyyy-MM-dd}:00:00,{date: 0 days next, yyyy-MM-dd}:23:30 |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                 |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Transit                                  |
      | userId       | {operator-portal-uid}                    |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {hub-name-2}                             |

  @DeleteCreatedHubs @DeleteCreatedShipments @DeleteMiddleMileDriver
  Scenario: Search Shipment by Filter - Last Inbound Hub (uid:7a2bf3c3-622d-4f31-9851-02ef7797ef1b)
    Given Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
    When API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates ad hoc trip
      | requestBody | {"origin_hub_id":"{hub-id}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}","destination_hub_system_id":"sg","departure_datetime":"{date: 0 seconds next, yyyy-MM-dd}T23:00:00Z","duration_time":"00:00:30","movement_type":"LAND_HAUL"} |
    When API MM - Operator assigns driver to movement trip with data below:
      | driver       | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
      | priority     | primary                                       |
      | movementTrip | KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]      |
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{hub-id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}"
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    When API MM - Operator scan inbound single shipment to movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]":
      | scanType   | SHIPMENT_VAN_INBOUND                     |
      | scanValue  | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | actionType | ADD                                      |
    When API MM - Operator end shipment inbound with movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]":
      | scanType | SHIPMENT_VAN_INBOUND                               |
      | driverId | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id} |
    When API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Land Haul  |
      | shipmentStatus | Transit    |
      | lastInboundHub | {hub-name} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | LAND_HAUL                                |
      | id           | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | status       | Transit                                  |
      | userId       | {operator-portal-uid}                    |
      | origHubName  | {hub-name}                               |
      | currHubName  | {hub-name}                               |
      | destHubName  | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |

  @DeleteCreatedShipments
  Scenario: Search Shipment by ID - Search <= 30 Shipments without Duplicate (uid:68b7217b-41a8-4259-9da8-e8ce68f0a7b0)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |

  @DeleteCreatedShipments
  Scenario: Search Shipment by ID - Search <= 30 Shipments with Duplicate (uid:6ec523ea-2f26-4d09-b90b-cb686c7c3b0c)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |

  @DeleteCreatedShipments
  Scenario: Search Shipment by ID - Search > 30 Shipments without Duplicate (uid:a4c69f51-6389-46b4-8348-db2b4fb4dfe5)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 35 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When Operator enters multiple shipment ids "KEY_MM_LIST_OF_CREATED_SHIPMENTS" in the Shipment Management Page
    Then Operator verifies number of entered shipment ids on Shipment Management page:
      | entered | 35 |
    When Operator click Search by shipment id on Shipment Management page
    Then Operator verifies that error react notification displayed:
      | top | We cannot process more than 30 shipments |

  @DeleteCreatedShipments
  Scenario: Search Shipment by ID - Search > 30 Shipments with Duplicate (uid:b57b2ffb-b215-4188-b66e-9ae51dc67278)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API MM - Operator creates multiple 35 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When Operator enters multiple shipment ids "KEY_MM_LIST_OF_CREATED_SHIPMENTS" in the Shipment Management Page
    When Operator enters next shipment ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
    Then Operator verifies number of entered shipment ids on Shipment Management page:
      | entered   | 35 |
      | duplicate | 2  |
    When Operator click Search by shipment id on Shipment Management page
    Then Operator verifies that error react notification displayed:
      | top | We cannot process more than 30 shipments |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op