@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @CreateShipment
Feature: Shipment Management - Create Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Create Shipment with Create Another Shipment (uid:7aeb10fa-ad56-4cbe-86f5-9717f878236c)
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given Operator intends to create a new Shipment directly from the Shipment Toast
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created multiple shipment on Shipment Management page

  @DeleteShipment
  Scenario: Create Shipment without Create Another Shipment (uid:8f16c9aa-7941-4ab7-9a9f-8f6afa5804c5)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  Scenario: Create New Shipment - selected same origin and destination hub
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName        | {hub-name}                                                          |
      | destHubName        | {hub-name}                                                          |
      | comments           | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | shipmentType       | {shipment-type}                                                     |
      | shipmentDialogType | {shipment-dialog-type}                                              |
    Then Operator verify error message exist
    And Operator verify "create button" is disable
    And Operator verify "create another button" is disable


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op