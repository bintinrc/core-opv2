@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithoutTrip2
Feature: Shipment Hub Inbound Without Trip Scanning 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment Not In Destination Hub (uid:8dba78a8-564e-4296-bf12-59f533a5aae4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment In Destination Hub (uid:c4fb9ebd-7928-4872-996d-b942be649b3d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound Transit MAWB In Destination Hub (uid:2afb0308-c133-4b95-8c41-3dc84e454edc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound Completed Shipment In Destination Hub (uid:c902a96e-576e-4911-b3c2-651d3515efa7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator refresh page
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page with Completed alert

  @DeleteShipment
  Scenario: Hub Inbound Completed Shipment Not In Destination Hub (uid:3eedde95-b367-4898-9ce1-a65427ac2241)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page with Completed alert

  @DeleteShipment
  Scenario: Hub Inbound Cancelled Shipment In Destination Hub (uid:2af315a0-4d44-4004-a4fd-8228ef6ce55b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page with Cancelled alert

  @DeleteShipment
  Scenario: Hub Inbound Cancelled Shipment Not In Destination Hub (uid:5cd67385-6a4b-4d0b-9658-f81ebfac6dd5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page with Cancelled alert

  @DeleteShipment
  Scenario: Hub Inbound Completed MAWB In Destination Hub (uid:cf1439be-e2bf-48d4-81a0-d1b0ddb14d07)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB with Completed alert

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op