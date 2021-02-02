@OperatorV2 @HappyPath @Hub @PathManagement @TriggerAutoGeneratedPath
Feature: Trigger Auto Generated Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI
  Scenario: Generate Default Path with which Default Path Doesn't Exist (uid:180126bf-69f8-4ab9-ba61-27e4cea737e1)
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
    When Operator clicks add default path button
    And Operator create default path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify a notification with message "Auto Generated Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    And Operator verify created default path data in path detail with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaAPI
  Scenario: Generate Default Path with which Default Path Exists and No Changes Made (uid:b2843b83-3ec8-4266-802a-e65328d1efb1)
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
    Given API Operator create "auto generated" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "" as origin and destination hub
    And Operator selects "Default Path" in "Path Type" filter
    And Operator clicks load selection button
    Then Operator verify "default paths" data appear in path table
    When Operator clicks add default path button
    And Operator create default path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify a notification with message "Auto Generated Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    When Operator clicks load selection button
    Then Operator verify no new path created
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 1 in movement_path table

  @DeleteHubsViaAPI
  Scenario: Generate Default Path with Updated Transit Hub for Existing Default Path (uid:2f705e9c-d933-4e52-a3de-9ab00c786898)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    Given API Operator create "auto generated" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "" as origin and destination hub
    And Operator selects "Default Path" in "Path Type" filter
    And Operator clicks load selection button
    Then Operator verify "default paths" data appear in path table
    When API Operator deletes movement schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" with facility type "CROSSDOCK"
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add default path button
    And Operator create default path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify a notification with message "Auto Generated Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    When Operator clicks load selection button
    Then Operator verify no new path created
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op