@MiddleMile @Hub @InterHub @SlaCalculation @StationToCrossdock @StationToAnotherCrossdockUsingMawb
Feature: Station to another Crossdock using MAWB

  @1 @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @1 @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipment @CloseNewWindows @DeletePaths
  Scenario: Station to another Crossdock using MAWB - Station Movement Found and there is available schedule (uid:bba7604d-9881-42c3-babd-820ec94c7b6a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign mawb "mawb_{KEY_CREATED_SHIPMENT_ID}" to following shipmentIds
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 20:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                           |
      | departureTime  | 20:15                              |
      | duration       | 1                                  |
      | endTime        | 16:30                              |
      | daysOfWeek     | all                                |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    And Operator close the shipment which has been created
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {KEY_LIST_OF_CREATED_HUBS[1].name} on Shipment Inbound Scanning page using MAWB
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}           |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}  |
      | status      | Transit                             |
      | sla         | {{next-4-days-yyyy-MM-dd}} 12:45:00 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipment @CloseNewWindows @DeletePaths
  Scenario: Station to another Crossdock using MAWB - Station Movement found but there is no available schedule (uid:0f8ba27c-7a69-4369-8899-fefa0e051bfb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
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
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}                                  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}                                  |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | mawb | AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    And Operator close the shipment which has been created
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {KEY_LIST_OF_CREATED_HUBS[1].name} on Shipment Inbound Scanning page using MAWB
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | status      | Transit                            |
      | sla         | -                                  |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source   | SLA_CALCULATION                                                                                                      |
      | status   | FAILED                                                                                                               |
      | comments | No path found between {KEY_LIST_OF_CREATED_HUBS[1].name} (sg) and {KEY_LIST_OF_CREATED_HUBS[3].name} (sg). Please ask your manager to check the schedule. |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipment @CloseNewWindows @DeletePaths
  Scenario: Station to another Crossdock using MAWB - Station Movement not found (uid:78d93bdc-8539-47b1-a050-68f748c2d9a8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
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
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}                                  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}                                  |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | mawb | AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    And Operator close the shipment which has been created
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {KEY_LIST_OF_CREATED_HUBS[1].name} on Shipment Inbound Scanning page using MAWB
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | status      | Transit                            |
      | sla         | -                                  |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source   | SLA_CALCULATION                                                                                                      |
      | status   | FAILED                                                                                                               |
      | comments | No path found between {KEY_LIST_OF_CREATED_HUBS[1].name} (sg) and {KEY_LIST_OF_CREATED_HUBS[3].name} (sg). Please ask your manager to check the schedule. |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
