@MiddleMile @Hub @InterHub @MovementSchedules @SlaCalculation @StationToStation @StationToStationUnderDifferentCrossdock
Feature: Station to Station Under Same Crossdock by MAWB Scan

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipment @CloseNewWindows @DeletePaths
  Scenario: Station to Station Under Same Crossdock by MAWB Scan - Station Movement found and there is available schedule (uid:1396f758-e6d7-4677-9d7e-3ea04346c958)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign mawb "mawb_{KEY_CREATED_SHIPMENT_ID}" to following shipmentIds
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:15                              |
      | duration       | 1                                  |
      | endTime        | 16:30                              |
    And Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment on Shipment Inbound Scanning page using data below:
      | label      | Into Van                         |
      | hub        | {KEY_LIST_OF_CREATED_HUBS[1].id} |
      | mawb       | {KEY_SHIPMENT_AWB}               |
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}        |
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}           |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                             |
      | sla         | {{next-2-days-yyyy-MM-dd}} 12:45:00 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @DeleteShipment @CloseNewWindows @DeletePaths @SoftDeleteCrossdockDetailsViaDb
  Scenario: Station to Station Under Same Crossdock by MAWB Scan - Station Movement Found but there is no available schedule (uid:08df57d8-f3a5-4bc7-9418-c310c9031201)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator edit Shipment on Shipment Management page including MAWB using data below:
      | mawb | AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new relation on Movement Management page using data below:
      | station        | {hub-name}                          |
      | crossdockHub   | {hub-relation-destination-hub-name} |
      | stationId      | {hub-id}                            |
      | crossdockHubId | {hub-relation-destination-hub-id}   |
    And Operator adds new relation on Movement Management page using data below:
      | station        | {hub-name-2}                        |
      | crossdockHub   | {hub-relation-destination-hub-name} |
      | stationId      | {hub-id-2}                          |
      | crossdockHubId | {hub-relation-destination-hub-id}   |
    And Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment on Shipment Inbound Scanning page using data below:
      | label      | Into Van                  |
      | hub        | {hub-id}                  |
      | mawb       | {KEY_MAWB}                |
      | shipmentId | {KEY_CREATED_SHIPMENT_ID} |
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | destHubName | {hub-name-2}              |
      | status      | Transit                   |
      | sla         | -                         |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND |
      | result | Transit              |
      | hub    | {hub-name}           |
    Then Operator verify movement event on Shipment Details page using data below:
      | source   | SLA_CALCULATION                                                        |
      | status   | FAILED                                                                 |
      | comments | found no path from origin {hub-id} (sg) to destination {hub-id-2} (sg) |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op