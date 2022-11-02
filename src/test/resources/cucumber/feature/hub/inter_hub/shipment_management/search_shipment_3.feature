@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @SearchShipment3
Feature: Shipment Management - Search Shipment 3

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Search Shipment by Search Filters
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Pending                |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Search Filters but Hide selected Shipment Status, Shipment Type
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Pending                |
    When Operator click Hide (n) button in Shipment Status filter
    When Operator click Hide (n) button in Shipment Type filter
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Search Filters but Hide selected Shipment Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Pending                |
    When Operator click Hide (n) button in Shipment Status filter
    When Operator click "Load Selection" button on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Search Filters but Hide selected Shipment Type
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Pending                |
    When Operator click Hide (n) button in Shipment Type filter
    When Operator click "Load Selection" button on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  Scenario: Search Shipment by Clear All Shipment Type Selected Filters
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator click X icon button in the right corner of Shipment Type filter field
    Then Operator verify it shows Please enter shipment type error message
    When Operator click "Load Selection" button on Shipment Management page
    Then Operator verify unable to load Shipment data without input Shipment Type

  Scenario: Search Shipment by Clear All Shipment Status Selected Filters
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator click X icon button in the right corner of Shipment Status filter field
    Then Operator verify it shows Please enter shipment status error message
    When Operator click "Load Selection" button on Shipment Management page
    Then Operator verify unable to load Shipment data without input Shipment Status

  Scenario: Search Shipment by Clear All Shipment Type, Shipment Status Selected Filters
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator click X icon button in the right corner of Shipment Type filter field
    Then Operator verify it shows Please enter shipment type error message
    When Operator click X icon button in the right corner of Shipment Status filter field
    Then Operator verify it shows Please enter shipment status error message
    When Operator click "Load Selection" button on Shipment Management page
    Then Operator verify unable to load Shipment data without input Shipment Type and Shipment Status

  @DeleteShipment @DeleteFilterTemplate
  Scenario: Search Shipment by Select Preset Filter
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator apply filters on Shipment Management Page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |
    And Operator save current filters as preset on Shipment Management page
    And Operator refresh page
    Then Operator select created filters preset on Shipment Management page
    And Operator verify selected filters on Shipment Management page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |
    When Operator click "Load Selection" button on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment @DeleteFilterTemplate
  Scenario: Search Shipment by Search Filters but No Data Found
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id-2} to hub id = {hub-id}
    When Operator apply filters on Shipment Management Page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |
    And Operator save current filters as preset on Shipment Management page
    And Operator refresh page
    Then Operator select created filters preset on Shipment Management page
    And Operator verify selected filters on Shipment Management page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |
    When Operator click "Load Selection" button on Shipment Management page
    When Operator search not found shipment id on Shipment Management table
    Then Operator verify it shows "No Results Found" error message

  @DeleteShipment
  Scenario: Search Shipment by Search Filters with Range Date > 7 days
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator select Shipment Date on Shipment Management page
    When Operator click "Load Selection" button on Shipment Management page
    Then Operator verify it shows The Shipment Date maximum range of selection error message

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op