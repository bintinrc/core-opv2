@MiddleMile @Hub @InterHub @MovementSchedules @Stations
Feature: Stations

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Station Hub (uid:db3123ca-4459-49bf-88fe-1bccd5c6203b)
    When Operator go to menu Hubs -> Facilities Management
    And Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | displayName  | GENERATED |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Then Operator verifies that success react notification displayed:
      | top | Hub Created Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}         |
      | facilityType | {KEY_CREATED_HUB.facilityType} |
      | region       | {KEY_CREATED_HUB.region}       |
      | displayName  | {KEY_CREATED_HUB.displayName}  |
      | city         | {KEY_CREATED_HUB.city}         |
      | country      | {KEY_CREATED_HUB.country}      |
      | latitude     | {KEY_CREATED_HUB.latitude}     |
      | longitude    | {KEY_CREATED_HUB.longitude}    |

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Update Hub Type to Station (uid:ef20d628-b61d-473a-b9c1-30c0f63d9b5e)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | Station                |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | Station                       |
      | region       | {KEY_CREATED_HUB.region}      |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | {KEY_CREATED_HUB.latitude}    |
      | longitude    | {KEY_CREATED_HUB.longitude}   |

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: View Station Schedule - Show All Station Schedule under Selected Crossdock Hub (uid:77570610-a905-4994-af38-7963dc4e0c99)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: View Station Schedule - Show Station Schedules based on selected Crossdock Hub, Origin Hub and Destination Hub (uid:58889684-f34b-4004-bfe6-d1bd5755964f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create Station Schedule - Add Schedule for New Relations (uid:a4a01a48-1fc2-49b7-8ca2-39f7f7a6e833)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 00:01                              |
      | daysOfWeek     | all                                |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create Station Schedule - Add Schedule for Existing Relations (uid:685dbcfd-72e3-4162-b6d3-5c6dca432b76)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 00:01                              |
      | daysOfWeek     | all                                |
    When Operator refresh page
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 21:00                              |
      | duration       | 0                                  |
      | endTime        | 00:01                              |
      | daysOfWeek     | all                                |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create Station Schedule - Add Multiple Schedules (uid:302d98b5-a06a-4210-84c0-1b505f4a9123)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 01:01                            |
      | daysOfWeek     | all                                |
      | addAnother     | true                               |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create Station Schedule - Add Multiple Schedules with Existing Schedule Data
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 00:20                              |
      | daysOfWeek     | all                                |
    Then Operator verify all station schedules are correct from UI
    When Operator refresh page
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 21:00                             |
      | duration       | 0                                  |
      | endTime        | 01:20                             |
      | daysOfWeek     | all                                |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Delete Station Movement Schedule (uid:2adde309-3433-4e29-8dd4-5c54609f2118)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify all station schedules are correct
    When Operator deletes created movement schedule on Movement Management page
    And Operator clicks close button in movement management page
    Then Operator verify all station schedules are correct
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Update Station Schedule - Succeed Update Schedule (uid:f808c484-4bcb-4f78-83f9-bbcbaa23da3d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify all station schedules are correct
    When Operator updates created station schedule
    When Operator refresh page
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create Station Schedule - Merged into Same Wave
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator adds new Station Movement Schedules on Movement Management page:
      | crossdockHub                       | originHub                          | destinationHub                     | movementType | departureTime | duration | endTime | daysOfWeek          |
      | {KEY_LIST_OF_CREATED_HUBS[1].name} | {KEY_LIST_OF_CREATED_HUBS[1].name} | {KEY_LIST_OF_CREATED_HUBS[2].name} | Land Haul    | 20:00         | 0        | 01:01   | monday,tuesday      |
      | {KEY_LIST_OF_CREATED_HUBS[1].name} | {KEY_LIST_OF_CREATED_HUBS[1].name} | {KEY_LIST_OF_CREATED_HUBS[2].name} | Land Haul    | 21:00         | 0        | 01:01   | wednesday, thursday |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Update Station Schedule - Remove Existing Schedules
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedules on Movement Management page:
      | crossdockHub                       | originHub                          | destinationHub                     | movementType | departureTime | duration | endTime | daysOfWeek          |
      | {KEY_LIST_OF_CREATED_HUBS[1].name} | {KEY_LIST_OF_CREATED_HUBS[1].name} | {KEY_LIST_OF_CREATED_HUBS[2].name} | Land Haul    | 20:00         | 0        | 02:01   | monday,tuesday      |
      | {KEY_LIST_OF_CREATED_HUBS[1].name} | {KEY_LIST_OF_CREATED_HUBS[1].name} | {KEY_LIST_OF_CREATED_HUBS[2].name} | Land Haul    | 21:00         | 0        | 02:01   | wednesday, thursday |
    And Operator deletes schedule 1 from Edit Schedule dialog

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Fail Update Station Schedule to Duplicate and Existing Schedule (uid:002362fd-43ed-4704-a330-fb19d42c9d22)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 3
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify all station schedules are correct
    Then Operator updates Station Schedule to Duplicate and Existing Schedule and verifies error messages
    When Operator clicks Error Message close icon
    Then Operator verifies page is back to view mode
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Fail Update Station Schedule to Duplicate Schedule (uid:46dbce64-4445-4cb5-bf7e-ccb57fd8115f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify all station schedules are correct
    Then Operator updates Station Schedule to Duplicate Schedule and verifies error messages
    When Operator clicks Error Message close icon
    Then Operator verifies page is back to view mode
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Fail Update Station Schedule to Existing Schedule (uid:2376bfa9-bfcf-4b22-b0d8-b3eb4788dfe0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify all station schedules are correct
    Then Operator updates Station Schedule to Existing Schedule and verifies error messages
    When Operator clicks Error Message close icon
    Then Operator verifies page is back to view mode
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Create with Single Driver (uid:68c0da7a-14dc-45e7-8068-40bba8d570d6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 00:01                              |
      | daysOfWeek     | all                                |
      | assignDrivers  | 1                                  |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Create with Multiple Drivers (uid:cec5c175-357d-45d9-b39a-4b1cf0c92349)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 00:01                              |
      | daysOfWeek     | all                                |
      | assignDrivers  | 2                                  |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Create with 4 Drivers (uid:5845f0c5-fd1a-4deb-99e9-f1b18629a770)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 4 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 00:01                              |
      | daysOfWeek     | all                                |
      | assignDrivers  | 4                                  |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Create with > 4 Drivers (uid:c8a06a13-d366-40bc-862b-247db882c5a1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 5 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 00:01                              |
      | daysOfWeek     | all                                |
      | assignDrivers  | 5                                  |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Create with Inactive License Status Driver (uid:e8568e01-c4b3-4dac-ae94-2d254e29a109)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 00:01                              |
      | daysOfWeek     | all                                |
      | assignDrivers  | 1                                  |
    Then Operator verifies "driver" with value "{expired-driver-username}" is not shown on Movement Schedules page
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Create with Inactive Employment Status Driver (uid:4c1b1b7b-4e25-4d93-ae20-2abce8a849ee)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 00:01                              |
      | daysOfWeek     | all                                |
      | assignDrivers  | 1                                  |
    Then Operator verifies "driver" with value "{inactive-driver-username}" is not shown on Movement Schedules page
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Add Multiple Schedules with Single Driver (uid:4538d147-440a-45a2-a3cd-178fca8f35a0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 01:01                            |
      | daysOfWeek     | all                                |
      | assignDrivers  | 1                                  |
      | addAnother     | true                               |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Add Multiple Schedules with Multiple Drivers (uid:2e79f606-2b7a-44b4-a875-a7e3f8ea24d9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 01:01                            |
      | daysOfWeek     | all                                |
      | assignDrivers  | 2                                  |
      | addAnother     | true                               |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Add Multiple Schedules with 4 Drivers (uid:5d339478-b839-44a0-a14f-ed1f7f41dbea)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 4 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 01:01                            |
      | daysOfWeek     | all                                |
      | assignDrivers  | 4                                  |
      | addAnother     | true                               |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Add Multiple Schedules with >4 Drivers (uid:428ede20-c299-40f5-a687-07251496dad2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create 5 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | 20:00                              |
      | duration       | 0                                  |
      | endTime        | 01:01                            |
      | daysOfWeek     | all                                |
      | assignDrivers  | 5                                  |
      | addAnother     | true                               |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create Station Schedule - Add Multiple Schedules with Existing Schedule Data (uid:dc04635f-825a-465c-93ce-75de41dcce05)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                          |
      | departureTime  | EXISTED                              |
      | duration       | 0                                  |
      | endTime        | EXISTED                           |
      | daysOfWeek     | all                                |
      | assignDrivers  | 1                                  |
      | addAnother     | true                               |
    Then Operator verifies "Existing Schedule" error message
    And Operator verify all station schedules are correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op