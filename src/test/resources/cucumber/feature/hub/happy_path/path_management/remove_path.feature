@OperatorV2 @HappyPath @Hub @PathManagement @RemovePath
Feature: Remove Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI
  Scenario: Remove Path by Path Details (uid:93c1f303-2676-45db-b91a-fc8dce84f7ec)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create "manual" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "{KEY_LIST_OF_CREATED_HUBS[2].name}" as origin and destination hub
    And Operator selects "Manual Path" in "Path Type" filter
    And Operator clicks load selection button
    Then Operator verify "manual paths" data appear in path table
    When Operator click "view" hyperlink button
    Then Operator verify shown "manual paths" path details modal data
    When Operator click "remove" button in path details
    Then Operator verify a notification with message "Path {KEY_CREATED_PATH_ID} successfully removed!" is shown on path management page
    And DB Operator verify "{KEY_CREATED_PATH_ID}" is deleted in movement_path table

  @DeleteHubsViaAPI
  Scenario: Remove Path by Path Table (uid:90ce7caa-0f3e-433a-ba49-9d3ba85df918)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create "manual" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "{KEY_LIST_OF_CREATED_HUBS[2].name}" as origin and destination hub
    And Operator selects "Manual Path" in "Path Type" filter
    And Operator clicks load selection button
    Then Operator verify "manual paths" data appear in path table
    When Operator click "remove" hyperlink button
    Then Operator verify shown "manual paths" remove path modal data
    When Operator click "remove" button in path details
    Then Operator verify a notification with message "Path {KEY_CREATED_PATH_ID} successfully removed!" is shown on path management page
    And DB Operator verify "{KEY_CREATED_PATH_ID}" is deleted in movement_path table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op