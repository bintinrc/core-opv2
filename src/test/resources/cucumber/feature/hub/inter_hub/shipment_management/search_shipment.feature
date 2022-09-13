@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @SearchShipment
Feature: Shipment Management - Search Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Invalid Shipment (uid:bc7c0cdf-fbcb-4db2-8c0d-a16b39e617a5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 2 shipment IDs
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
      | 111111111                            |
    Then Operator verifies that search error modal shown with shipment ids:
      | 111111111 |
    And Operator click Show Shipments button in Search Error dialog on Shipment Management Page
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Empty Line (uid:a2945cf0-7404-427f-80f9-7feb06288d75)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 2 shipment IDs
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {empty}                              |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |

  @DeleteFilterTemplate
  Scenario: Preset Setting - Save Current Shipment Filter as Preset (uid:81c46be2-466f-4c5f-b7ba-d1f15d05ddc9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator apply filters on Shipment Management Page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |
    And Operator save current filters as preset on Shipment Management page
    And Operator refresh page
    Then Operator select created filters preset on Shipment Management page
    And Operator verify selected filters on Shipment Management page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |

  @DeleteFilterTemplate
  Scenario: Preset Setting - Delete Shipment Filter as Preset (uid:c722664d-4ef4-4f13-92d6-5074a3dde4f5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator save current filters as preset on Shipment Management page
    And Operator delete created filters preset on Shipment Management page
    And Operator refresh page
    Then Operator verify filters preset was deleted

  @DeleteShipment
  Scenario: Search Shipment by Filter - Start Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "{shipment-type}" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator apply filters on Shipment Management Page:
      | startHubName | {hub-name} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | {shipment-type}           |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | {pending-status}          |
      | startHubName | {hub-name}                |
      | currHubName  | {hub-name}                |

  @DeleteShipment
  Scenario: Search Shipment by Filter - End Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "{shipment-type}" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator apply filters on Shipment Management Page:
      | endHubName | {hub-name-2} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | {shipment-type}           |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | {pending-status}          |
      | currHubName  | {hub-name}                |
      | endHubName   | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Type : Air Haul
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "{shipment-type}" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | {pending-status}       |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | {shipment-type}           |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | {pending-status}          |
      | startHubName | {hub-name}                |
      | currHubName  | {hub-name}                |
      | endHubName   | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Type : Land Haul
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "{land-haul-shipment-type}" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {land-haul-shipment-dialog-type} |
      | shipmentStatus | {pending-status}                 |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | {land-haul-shipment-type} |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | {pending-status}          |
      | startHubName | {hub-name}                |
      | currHubName  | {hub-name}                |
      | endHubName   | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Type : Sea Haul
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "{sea-haul-shipment-type}" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {sea-haul-shipment-dialog-type} |
      | shipmentStatus | {pending-status}                |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | {sea-haul-shipment-type}  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | {pending-status}          |
      | startHubName | {hub-name}                |
      | currHubName  | {hub-name}                |
      | endHubName   | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Type : Others
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "{others-shipment-type}" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {others-shipment-dialog-type} |
      | shipmentStatus | {pending-status}              |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | {others-shipment-type}    |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | {pending-status}          |
      | startHubName | {hub-name}                |
      | currHubName  | {hub-name}                |
      | endHubName   | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "{shipment-type}" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | {pending-status}       |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | {shipment-type}           |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | {pending-status}          |
      | startHubName | {hub-name}                |
      | currHubName  | {hub-name}                |
      | endHubName   | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "{shipment-type}" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentDate | {gradle-previous-1-day-yyyy-MM-dd}:00:00,{gradle-current-date-yyyy-MM-dd}:23:30 |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | {shipment-type}           |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | {pending-status}          |
      | startHubName | {hub-name}                |
      | currHubName  | {hub-name}                |
      | endHubName   | {hub-name-2}              |

  Scenario: Search Shipment by ID - Search <= 30 Shipments Separated by Coma (,) or Space (uid:373d0602-6f7f-4669-afbb-e606dc6fa5d2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 2 shipment IDs
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | ,                                    |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verifies that error react notification displayed:
      | top    | SERVER_ERROR_EXCEPTION                                                     |
      | bottom | ^.*Error Message: Cannot parse parameter id as Long: For input string: "," |

  @DeleteShipment
  Scenario: Shipment Details (uid:839a572a-8534-4456-8340-b615174dc29c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    And Operator click "Load All Selection" on Shipment Management page
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op