@OperatorV2 @MiddleMile @Hub @PathManagement @CreateManualPath @CFW
Feature: Path Management - Create Manual Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Create New Path with Transit Hubs and Single Schedule (uid:6bb55b7d-3ce8-4a0b-8a59-8740b20d98e7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
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
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Create New Path with Transit Hubs and Multiple Schedule (uid:a49e28a0-cf9f-407c-84e7-abbe9e8052bc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 3
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with "multiple" schedule for following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[3].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    And Operator verify created manual path data with "multiple" schedule in path detail with following data:
      | originHubName       | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}        |
      | transitHubName      | {KEY_LIST_OF_CREATED_HUBS[3].name}        |
      | departureTime       | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[1]} |
      | departureTimeSecond | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[2]} |
    When Operator searches "{KEY_LIST_OF_CREATED_HUBS[1].name} " in "Path" field
    Then Operator verifies path data appear in path table with following hubs:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Create New Path without Transit Hub with Single Schedule (uid:5220881c-bec9-40e2-87e7-b3893cccf181)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
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
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    And Operator verify created manual path data in path detail with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}        |
      | departureTime      | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[1]} |
    When Operator searches "{KEY_LIST_OF_CREATED_HUBS[1].name} " in "Path" field
    Then Operator verify path data from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" appear in path table
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Create New Path without Transit Hub with Multiple Schedule (uid:7498d4f6-9c9f-4d13-8522-05d35b49c0c9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with "multiple" schedule for following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    And Operator verify created manual path data with "multiple" schedule in path detail with following data:
      | originHubName       | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}        |
      | departureTime       | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[1]} |
      | departureTimeSecond | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[2]} |
    When Operator searches "{KEY_LIST_OF_CREATED_HUBS[1].name} " in "Path" field
    Then Operator verify path data from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" appear in path table
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb @RT
  Scenario: Unable to Create New Path without Selecting Schedule (uid:9f133662-b9ec-4395-8c50-b7ec516b9ea6)
    Given no-op

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Adding Transit Hub Fails no schedule from Origin to Transit Hub (uid:b0e503d1-1d55-4cc6-adab-b49672f1b16a)
    Given no-op

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Adding Transit Hub Fails no schedule from Transit Hub to Destination Hub (uid:997f674a-9433-4807-b537-cfcca6d1892d)
    Given no-op

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Cancel Creating Path (uid:4fbdec5e-a707-4897-a2e3-b72b404c4f62)
    Given no-op

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Retract Step  in Creating Path (uid:12090f37-ee2b-4b4e-8df8-c47437eab517)
    Given no-op

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Removing Transit Hub (uid:7c5a61d2-d09c-4a06-b2b1-d3f37a646407)
    Given no-op

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op