@OperatorV2 @MiddleMile @Hub @PathManagement @UpdatePath @CFW
Feature: Update Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb @SoftDeleteCreatedPaths @RT
  Scenario: Update Path by Path Table (uid:04f2f914-0f5d-4c9b-89e1-ba17b67a50e1)
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
    Given API Operator create "manual" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "{KEY_LIST_OF_CREATED_HUBS[2].name}" as origin and destination hub
    And Operator selects "Manual Path" in "Path Type" filter
    And Operator clicks load selection button
    Then Operator verify path data from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" appear in path table
    When Operator click "edit" hyperlink button
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[3].name}" as transit hub in edit path modal
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully updated" is shown on path management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op