@OperatorV2 @HappyPath @Hub @PathManagement @CreateManualPath
Feature: Path Management - Create Manual Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI
  Scenario: Create New Path with Transit Hubs and Single Schedule (uid:86707205-cc88-4cae-b03d-97f8e82ec7f1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 3 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[3].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | selectSchedule     | single                             |
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    And Operator verify created manual path data in path detail with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}        |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name}        |
      | departureTime      | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[1]} |
    When Operator searches "{KEY_LIST_OF_CREATED_HUBS[1].name} " in "Path" field
    Then Operator verifies path data appear in path table with following hubs:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    Then DB Operator verifies "manual" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaAPI
  Scenario: Create New Path without Transit Hub with Single Schedule (uid:80efbc62-9d82-41af-9648-5aa8568da26b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | selectSchedule     | single                             |
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    And Operator verify created manual path data in path detail with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}        |
      | departureTime      | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[1]} |
    When Operator searches "{KEY_LIST_OF_CREATED_HUBS[1].name} " in "Path" field
    Then Operator verify path data from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" appear in path table
    Then DB Operator verifies "manual" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaAPI
  Scenario: Unable to Create New Path - Adding Transit Hub Fails no schedule from Origin to Transit Hub (uid:10ecf3e4-d121-4cea-97ad-8e549e3c6864)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 3 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | selectSchedule     | false                              |
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |

  @DeleteHubsViaAPI
  Scenario: Unable to Create New Path - Adding Transit Hub Fails no schedule from Transit Hub to Destination Hub (uid:2fcbcd7d-8a3a-4575-ae45-4010d7c4193a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 3 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | selectSchedule     | false                              |
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |

  @DeleteHubsViaAPI
  Scenario: Unable to Create New Path - Removing Transit Hub (uid:89da40be-3767-46d4-a46c-7359b2162646)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 3 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | selectSchedule     | false                              |
    And Operator remove "first" transit hub
    And Operator clicks next button in create manual path modal
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |

  @DeleteHubsViaAPI @CloseNewWindows
  Scenario: Create New Path with Different Path and Same Schedule using 2 tabs (uid:3437b826-d724-43f5-a9ae-c619bd4a14e4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 4 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[3].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[3].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[4].id}
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "" as origin and destination hub
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | selectSchedule     | none                               |
    When Operator opens new tab and switch to new tab in path management page
    And Operator switch to new tab in path management page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "" as origin and destination hub
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | selectSchedule     | none                               |
    When Operator switch to main tab in path management page
    And Operator verifies path management page is loaded
    And Operator choose single schedule and clicks create button in create manual path modal
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    And Operator verify created manual path data in path detail with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}        |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name}        |
      | departureTime      | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[1]} |
    When Operator searches "{KEY_LIST_OF_CREATED_HUBS[2].name} " in "Path" field
    Then Operator verifies path data appear in path table with following hubs:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    Then DB Operator verifies "manual" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table
    When Operator switch to new tab in path management page
    And Operator verifies path management page is loaded
    And Operator choose single schedule and clicks create button in create manual path modal
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[4].name} has been successfully created" is shown on path management page
    And Operator verify created manual path data in path detail with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[4].name}        |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name}        |
      | departureTime      | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[1]} |
    When Operator searches "{KEY_LIST_OF_CREATED_HUBS[4].name} " in "Path" field
    Then Operator verifies path data appear in path table with following hubs:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    When Operator switch to main tab in path management page
    And Operator verifies path management page is loaded
    And Operator click "view" hyperlink button
    Then Operator verify created manual path data in path detail with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}        |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name}        |
      | departureTime      | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[1]} |
    Then DB Operator verifies "manual" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[4].id}" is created in movement_path table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op