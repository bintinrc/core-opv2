@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @EditShipment6
Feature: Shipment Management - Edit Shipment 6

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipments
  Scenario: Edit Shipment - Shipment Type
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Pending                |
    And Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page:
      | shipmentId   | {KEY_CREATED_SHIPMENT_ID} |
      | shipmentType | Land Haul                 |
    Then Operator verifies that notification displayed:
      | top | Shipment {KEY_CREATED_SHIPMENT_ID} updated |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | LAND_HAUL                 |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @HappyPath @DeleteShipments
  Scenario: Edit Shipment - Origin Hub - select same hub with Destination Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Pending                |
    And Operator click "Load All Selection" on Shipment Management page
    When Operator input form edit Shipment on Shipment Management page:
      | shipmentId  | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-2}              |
    Then Operator verify error message "Origin Hub and Destination Hub cannot be the same" is shown
    And Operator verify "save changes button" on edit popup is disable

  @HappyPath @DeleteShipments
  Scenario: Edit Shipment - Destination Hub - select same hub with Origin Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Pending                |
    And Operator click "Load All Selection" on Shipment Management page
    When Operator input form edit Shipment on Shipment Management page:
      | shipmentId  | {KEY_CREATED_SHIPMENT_ID} |
      | destHubName | {hub-name}                |
    Then Operator verify error message "Origin Hub and Destination Hub cannot be the same" is shown
    And Operator verify "save changes button" on edit popup is disable

  @DeleteShipments
  Scenario: Bulk Update Shipment - Update Origin Hub and Destination Hub with same hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator input form bulk update shipment with data below:
      | startHub | {hub-name} |
      | endHub   | {hub-name} |
    Then Operator verify error message "Origin Hub and Destination Hub cannot be the same" is showing on Bulk Update dialog
    And Operator verify "apply to selected button" on bulk update is disable

  @DeleteShipments
  Scenario: Bulk Update Shipment - Update Origin Hub - select same hub with Destination Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator bulk update shipment with data below:
      | startHub | {hub-name-2} |
    Then Operator verify error message "Failed. Error: Shipment Origin Hub and Destination Hub cannot be the same" is shown on bulk update page

  @DeleteShipments
  Scenario: Bulk Update Shipment - Update Destination Hub - select same hub with Origin Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator bulk update shipment with data below:
      | endHub | {hub-name} |
    Then Operator verify error message "Shipment Origin Hub and Destination Hub cannot be the same" is shown on bulk update page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
