@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @EditShipment4
Feature: Shipment Management - Edit Shipment 4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Edit Shipment - Start Hub
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page:
      | shipmentId  | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-3}              |
    Then Operator verifies that notification displayed:
      | top | Shipment {KEY_CREATED_SHIPMENT_ID} updated |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name-3}              |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Edit Shipment - End Hub
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page:
      | shipmentId  | {KEY_CREATED_SHIPMENT_ID} |
      | destHubName | {hub-name-3}              |
    Then Operator verifies that notification displayed:
      | top | Shipment {KEY_CREATED_SHIPMENT_ID} updated |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-3}              |

  @DeleteShipment
  Scenario: Edit Shipment - Comments
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                           |
      | comments   | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Then Operator verifies that notification displayed:
      | top | Shipment {KEY_CREATED_SHIPMENT_ID} updated |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                                            |
      | id           | {KEY_CREATED_SHIPMENT_ID}                                           |
      | status       | Pending                                                             |
      | origHubName  | {hub-name}                                                          |
      | currHubName  | {hub-name}                                                          |
      | destHubName  | {hub-name-2}                                                        |
      | comments     | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op