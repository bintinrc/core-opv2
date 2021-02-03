@HappyPath @Hub @InterHub @MovementSchedules @Stations
Feature: Stations

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI 
  Scenario: Create New Station Hub (uid:5f261101-65b8-4790-8928-d55cba446f01)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Operator refresh hubs cache on Facilities Management page
    And Operator refresh page
    Then Operator verify a new Hub is created successfully on Facilities Management page

  @DeleteHubsViaAPI 
  Scenario: Update Hub Type to Station (uid:bae5cf22-4c6a-4984-b9ea-0666ded1818e)
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
    And Operator refresh page
    When Operator go to menu Hubs -> Facilities Management
    And Operator refresh hubs cache on Facilities Management page
    And Operator refresh page
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | Station                |
    And Operator refresh page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @DeleteHubsViaAPI 
  Scenario: View Station Schedule - Show All Station Schedule under Selected Crossdock Hub (uid:17d9e2b0-2270-4b04-a7d5-db15cd188eb7)
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

  @DeleteHubsViaAPI 
  Scenario: View Station Schedule - Show Station Schedules based on selected Crossdock Hub, Origin Hub and Destination Hub (uid:eabf7da9-8930-4f44-ae35-d2d3486d4e95)
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

  @DeleteHubsViaAPI 
  Scenario: Create Station Schedule - Add Schedule for New Relations (uid:0415f542-2185-42a4-bfd2-ea4dbed56b8a)
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
      | departureTime  | 20:15                              |
      | duration       | 0                                  |
      | endTime        | 00:15                              |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI 
  Scenario: Create Station Schedule - Add Schedule for Existing Relations (uid:6bc7dd61-3868-4bb3-9dfb-388a728c02e3)
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
      | departureTime  | 20:15                              |
      | duration       | 0                                  |
      | endTime        | 00:15                              |
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
      | departureTime  | 21:15                              |
      | duration       | 0                                  |
      | endTime        | 00:15                              |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI 
  Scenario: Create Station Schedule - Add Multiple Schedules (uid:4852437d-c268-4529-a2e3-9204ef59de19)
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
      | departureTime  | 20:15                              |
      | duration       | 0                                  |
      | endTime        | 00:15                              |
      | addAnother     | true                               |
    Then Operator verify all station schedules are correct from UI

  @DeleteHubsViaAPI 
  Scenario: Delete Station Movement Schedule (uid:0bbb347d-4921-4eb7-868c-441f0d983fc4)
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
    Then Operator verify all station schedules are correct
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules

  @DeleteHubsViaAPI 
  Scenario: Update Station Schedule - Succeed Update Schedule (uid:d4c469cf-4f7f-41fb-9afb-2ff695479b13)
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op