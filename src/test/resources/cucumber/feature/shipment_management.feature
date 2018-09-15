@OperatorV2Disabled @ShipmentManagement
Feature: Shipment Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Create Shipment (uid:7a3373f0-67f1-4f1a-b6b2-6447a2621305)
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | 30JKB                                   |
      | destHubName | DOJO                                    |
      | comments    | Created by feature @ShipmentManagement. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Edit Shipment (uid:5fbdb7d5-0a54-42de-bd8e-960ad26ff43e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | 30JKB                                   |
      | destHubName | DOJO                                    |
      | comments    | Created by feature @ShipmentManagement. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page using data below:
      | origHubName | DOJO                                     |
      | destHubName | EASTGW                                   |
      | comments    | Modified by feature @ShipmentManagement. |
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Force Success Shipment (uid:9e106cef-fac4-4283-9b40-634c50ad9413)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | 30JKB                                   |
      | destHubName | DOJO                                    |
      | comments    | Created by feature @ShipmentManagement. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator force success the created shipment on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |

  @DeleteShipment
  Scenario: Cancel Shipment (uid:9618d764-8b09-49a3-9cec-07e7d726faee)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | 30JKB                                   |
      | destHubName | DOJO                                    |
      | comments    | Created by feature @ShipmentManagement. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator cancel the created shipment on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
