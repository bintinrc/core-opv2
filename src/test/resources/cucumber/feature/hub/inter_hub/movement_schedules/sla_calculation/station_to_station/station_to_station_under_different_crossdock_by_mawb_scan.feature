@MiddleMile @Hub @InterHub @MovementSchedules @SlaCalculation @StationToStation @StationToStationUnderDifferentCrossdock
Feature: Station to Station Under Different Crossdock by MAWB Scan

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipment @CloseNewWindows @DeletePaths
  Scenario: Station to Station Under Different Crossdock by MAWB Scan - Given Crossdocks have relation (uid:7e1c0094-17b4-4119-a9db-b4ee8f39108c)
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
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator create Shipment on Shipment Management page using data below:
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}                                  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}                                  |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator edit Shipment on Shipment Management page including MAWB using data below:
      | mawb | AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[3].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[4].name}                            |
      | schedules[1].movementType   | Air Haul                                                      |
      | schedules[1].departureTime  | 15:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[4].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | movementType   | Air Haul                           |
      | departureTime  | 20:15                              |
      | duration       | 0                                  |
      | endTime        | 00:30                              |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Air Haul                           |
      | departureTime  | 20:15                              |
      | duration       | 0                                  |
      | endTime        | 00:30                              |
    And Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment on Shipment Inbound Scanning page using data below:
      | label      | Into Van                         |
      | hub        | {KEY_LIST_OF_CREATED_HUBS[1].id} |
      | mawb       | {KEY_MAWB}                       |
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}        |
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}           |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                             |
      | sla         | {{next-3-days-yyyy-MM-dd}} 20:45:00 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipment @CloseNewWindows @DeletePaths
  Scenario: Station to Station Under Different Crossdock by MAWB Scan - Given Crossdocks have no relation (uid:7f843b3b-4dbb-4abd-8897-0341a9ecee2a)
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
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator create Shipment on Shipment Management page using data below:
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}                                  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}                                  |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator edit Shipment on Shipment Management page including MAWB using data below:
      | mawb | AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[4].name} |
    And Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment on Shipment Inbound Scanning page using data below:
      | label      | Into Van                         |
      | hub        | {KEY_LIST_OF_CREATED_HUBS[1].id} |
      | mawb       | {KEY_MAWB}                       |
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}        |
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Transit                            |
      | sla         | -                                  |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source   | SLA_CALCULATION                                                                                                      |
      | status   | FAILED                                                                                                               |
      | comments | found no path from origin {KEY_LIST_OF_CREATED_HUBS[1].id} (sg) to destination {KEY_LIST_OF_CREATED_HUBS[2].id} (sg) |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op