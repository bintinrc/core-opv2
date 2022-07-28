@OperatorV2 @HappyPath @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithoutTrip
Feature: Shipment Hub Inbound Without Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Hub Inbound Pending Shipment In Destination Hub (uid:cbc440de-0b41-4c0d-8854-c5a6f3aee6c0)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Completed                 |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name-2}              |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Hub Inbound Pending Shipment Not In Destination Hub (uid:0ff35872-6b21-4fdf-ad11-79d34aab2502)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | At Transit Hub            |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment In Destination Hub (uid:c0c5001d-6190-4373-a914-c1e048dc4c52)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Completed    |
      | lastInboundHub | {hub-name-2} |
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Completed                 |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name-2}              |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment Not In Destination Hub (uid:530866f4-1616-4a0c-97f4-b29196154eeb)
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Air Haul               |
      | shipmentStatus | At Transit Hub,Transit |
      | lastInboundHub | {hub-name}             |
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Transit                   |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op