@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithoutTrip2
Feature: Shipment Hub Inbound Without Trip Scanning 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment Not In Destination Hub (uid:8dba78a8-564e-4296-bf12-59f533a5aae4)
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

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment In Destination Hub (uid:c4fb9ebd-7928-4872-996d-b942be649b3d)
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
  Scenario: Hub Inbound Completed Shipment In Destination Hub (uid:c902a96e-576e-4911-b3c2-651d3515efa7)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator refresh page
    When API Operator change the status of the shipment into "Completed"
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Completed |
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Completed                 |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} in Shipment Inbound Scanning page
    Then Click on Yes, continue on dialog box
    Then Operator verify scan text message "Destination Reached" appears in Shipment Inbound Box

  @DeleteShipment
  Scenario: Hub Inbound Completed Shipment Not In Destination Hub (uid:3eedde95-b367-4898-9ce1-a65427ac2241)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Completed |
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Completed                 |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} in Shipment Inbound Scanning page
    Then Click on Yes, continue on dialog box
    Then Operator verify scan text message "In Transit for" appears in Shipment Inbound Box

  @DeleteShipment
  Scenario: Hub Inbound Cancelled Shipment In Destination Hub (uid:2af315a0-4d44-4004-a4fd-8228ef6ce55b)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Cancelled |
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} in Shipment Inbound Scanning page
    And Click on No, goback on dialog box for shipment "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "shipment {KEY_CREATED_SHIPMENT_ID} is in terminal state: [Cancelled]" appears in Shipment Inbound Box

  @DeleteShipment
  Scenario: Hub Inbound Cancelled Shipment Not In Destination Hub (uid:5cd67385-6a4b-4d0b-9658-f81ebfac6dd5)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Cancelled |
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} in Shipment Inbound Scanning page
    And Click on No, goback on dialog box for shipment "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "shipment {KEY_CREATED_SHIPMENT_ID} is in terminal state: [Cancelled]" appears in Shipment Inbound Box

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op