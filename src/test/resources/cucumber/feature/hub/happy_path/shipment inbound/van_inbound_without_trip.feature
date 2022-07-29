@OperatorV2 @HappyPath @Hub @InterHub @ShipmentInboundScanning @VanInbound @WithoutTrip
Feature: Shipment Van Inbound Without Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Van Inbound Pending Shipment In Origin Hub (uid:89d454a1-c776-47be-b218-c4a88babf21d)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Transit                   |
      | currHubName | {hub-name}                |

  @DeleteShipment
  Scenario: Van Inbound Pending Shipment Not In Origin Hub (uid:01f85e7b-2d03-4914-a76d-aa4b0f1d298e)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} in Shipment Inbound Scanning page
    Then Operator verify small message "shipment {KEY_CREATED_SHIPMENT_ID} is [Pending], but scanned at [{hub-name-2}], please inbound into van in the origin hub [{hub-name}]" appears in Shipment Inbound Box
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Pending                   |
      | currHubName | {hub-name-2}              |

  @DeleteShipment
  Scenario: Van Inbound Wrong Shipment (uid:206caf86-d510-47b1-86f8-3a41a681d541)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning wrong Shipment 1 Into Van in hub "{hub-name}" on Shipment Inbound Scanning page
    Then Operator verify error message in shipment inbound scanning is "shipment not found" for shipment "1"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op