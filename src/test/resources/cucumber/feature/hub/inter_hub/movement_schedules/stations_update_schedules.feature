@MiddleMile @Hub @InterHub @MovementSchedules @StationsUpdateSchedule
Feature: Stations

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

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
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
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
  Scenario: Update Station Schedule - Update Schedule with Filter to Modify Schedules (uid:13242caf-dc23-4fbc-992c-4d041ae26696)
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
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify all station schedules are correct
    When Operator updates created station schedule with filter using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    When Operator refresh page
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Update Station Schedule - Cancel Update Schedules (uid:6462774b-38c7-4581-a7de-7f3e00562076)
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
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify all station schedules are correct
    When Operator cancels Update Schedules on Movement Schedule page
    Then Operator verifies dialog confirm with message "Discard unsaved changes?" show on Movement Schedules page
    When Operator click on OK button
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Update Station Schedule - Failed Update Schedule (uid:449f4a8b-4839-4754-839d-dcbecdf21603)
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
    Then Operator updates Schedule to Existing Schedule and verifies error messages
    When Operator clicks Error Message close icon
    Then Operator verifies page is back to view mode
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Update Station Schedule - Update Schedule with Existing Schedules (uid:a4e0873e-05dc-4b97-b150-038d67ccf3c9)
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
    Then Operator updates Schedule to Existing Schedule and verifies error messages
    When Operator clicks Error Message close icon
    Then Operator verifies page is back to view mode
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Update Station Schedule - Update Duplicate Schedules (uid:67dc1bfc-ba81-4121-9a2e-b92b19500f93)
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
    Then Operator updates Schedule to Duplicate Schedule and verifies error messages
    When Operator clicks Error Message close icon
    Then Operator verifies page is back to view mode
    Then Operator verify all station schedules are correct

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Update Station Schedule - Merged into Same Wave (uid:b8cdd252-c029-41a2-a3ad-a3d70a74707b)
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
    When Operator upgrades new Station Movement Schedules on Movement Management page:
      | departureTime    | duration | endTime    | daysOfWeek          |
      |  SAMEWAVE        | 0        | SAMEWAVE   | monday,tuesday      |
      |  SAMEWAVE        | 0        | SAMEWAVE   | wednesday,thursday  |
    Then Operator verify all station schedules are correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op