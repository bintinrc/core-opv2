@OperatorV2 @HappyPath @Hub @PathManagement @UpdatePath
Feature: Update Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Update Path by Path Details (uid:22754dba-4918-4890-a9a9-8288a8d12ab7)
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
    Given API Operator create "manual" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "{KEY_LIST_OF_CREATED_HUBS[2].name}" as origin and destination hub
    And Operator selects "Manual Path" in "Path Type" filter
    And Operator clicks load selection button
    Then Operator verify path data from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" appear in path table
    When Operator click "view" hyperlink button
    Then Operator verify shown "manual paths" path details modal data
    When Operator click "edit" button in path details
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[3].name}" as transit hub in created edit path modal
    And Operator clicks "next" button in created edit path modal
    When Operator selects first schedule in created edit path modal
    And Operator clicks "update" button in created edit path modal
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully updated" is shown on path management page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Update Path by Path Table (uid:b862d8b3-1bc3-490d-bb4d-bbcc0c1fcb9e)
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
    And Operator clicks "next" button in edit path modal
    When Operator selects first schedule in edit path modal
    And Operator clicks "update" button in edit path modal
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully updated" is shown on path management page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Update Path - Add One Transit Hub (uid:eaebb10a-95a0-4cd4-9c18-3a780f06e19f)
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
    And Operator clicks "next" button in edit path modal
    When Operator selects first schedule in edit path modal
    And Operator clicks "update" button in edit path modal
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully updated" is shown on path management page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Update Path - Add Multiple Transit Hubs (uid:46427c07-0b13-495f-9d10-33b87d366128)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
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
    And Operator selects following transit hubs in edit path modal:
      | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | {KEY_LIST_OF_CREATED_HUBS[4].name} |
    And Operator clicks "next" button in edit path modal
    When Operator selects first schedule in edit path modal
    And Operator clicks "update" button in edit path modal
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[4].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully updated" is shown on path management page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Update Path - Remove One Transit Hub (uid:411bb539-a0ca-4a8f-aa21-a20994acc550)
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
    Given API Operator create "manual" path from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" with multiple movement schedule ids with "LAND_HAUL" movement type:
      | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id} |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "{KEY_LIST_OF_CREATED_HUBS[2].name}" as origin and destination hub
    And Operator selects "Manual Path" in "Path Type" filter
    And Operator clicks load selection button
    Then Operator verify path data from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" appear in path table with following transit hubs:
      | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    When Operator click "edit" hyperlink button
    And Operator remove "first" transit hub
    And Operator clicks "next" button in edit path modal
    When Operator selects first schedule in edit path modal
    And Operator clicks "update" button in edit path modal
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully updated" is shown on path management page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Update Path - Remove Multiple Transit Hubs (uid:fc94ae49-e59d-479f-b3b4-c7637080182b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 5 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[5].id}" plus hours 3
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[5].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 4
    Given API Operator create "manual" path from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" with multiple movement schedule ids with "LAND_HAUL" movement type:
      | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id} |
      | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[4].id} |
      | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[5].id} |
      | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[6].id} |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    And Operator clicks show or hide filters
    And Operator selects "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "{KEY_LIST_OF_CREATED_HUBS[2].name}" as origin and destination hub
    And Operator selects "Manual Path" in "Path Type" filter
    And Operator clicks load selection button
    Then Operator verify path data from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" appear in path table with following transit hubs:
      | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | {KEY_LIST_OF_CREATED_HUBS[5].name} |
    When Operator click "edit" hyperlink button
    And Operator remove "third" transit hub
    And Operator remove "first" transit hub
    And Operator clicks "next" button in edit path modal
    When Operator selects first schedule in edit path modal
    And Operator clicks "update" button in edit path modal
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[4].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully updated" is shown on path management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op