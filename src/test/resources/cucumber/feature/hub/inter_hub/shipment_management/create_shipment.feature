@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @CreateShipment
Feature: Shipment Management - Create Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Osperator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteCreatedShipments
  Scenario: Create Shipment with Create Another Shipment (uid:3e44bd1b-5bbf-4eb3-b51c-300c21005f86)
    When Operator go to menu Inter-Hub -> Shipment Management
    Given Operator intends to create a new Shipment directly from the Shipment Toast
    When Operator create Shipment on Shipment Management page:
      | origHubName  | {hub-name}                                                          |
      | destHubName  | {hub-name-2}                                                        |
      | comments     | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | shipmentType | Land Haul                                                           |
    When Operator apply filters on Shipment Management Page:
      | originHub    | {hub-name} |
      | shipmentType | Land Haul  |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | LAND_HAUL                            |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | origHubName  | {hub-name}                           |
      | currHubName  | {hub-name}                           |
      | destHubName  | {hub-name-2}                         |
      | status       | Pending                              |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | LAND_HAUL                            |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
      | origHubName  | {hub-name}                           |
      | currHubName  | {hub-name}                           |
      | destHubName  | {hub-name-2}                         |
      | status       | Pending                              |

  @HappyPath @DeleteCreatedShipments
  Scenario: Create Shipment without Create Another Shipment (uid:20aadc4d-b1f8-4adf-9c45-6eb0b636c5bb)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName  | {hub-name}                                                          |
      | destHubName  | {hub-name-2}                                                        |
      | comments     | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | shipmentType | Land Haul                                                           |
    When Operator apply filters on Shipment Management Page:
      | originHub    | {hub-name} |
      | shipmentType | Land Haul  |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | LAND_HAUL                            |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | origHubName  | {hub-name}                           |
      | currHubName  | {hub-name}                           |
      | destHubName  | {hub-name-2}                         |
      | status       | Pending                              |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op