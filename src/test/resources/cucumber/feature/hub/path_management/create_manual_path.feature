@OperatorV2 @MiddleMile @Hub @PathManagement @CreateManualPath
Feature: Path Management - Create Manual Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Create New Path with Transit Hubs and Single Schedule (uid:6bb55b7d-3ce8-4a0b-8a59-8740b20d98e7)
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
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Create New Path with Transit Hubs and Multiple Schedule (uid:a49e28a0-cf9f-407c-84e7-abbe9e8052bc)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 3
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | selectSchedule     | multiple                           |
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
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Create New Path without Transit Hub with Multiple Schedule (uid:7498d4f6-9c9f-4d13-8522-05d35b49c0c9)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | selectSchedule     | multiple                           |
    Then Operator verify a notification with message "Path {KEY_LIST_OF_CREATED_HUBS[1].name} → {KEY_LIST_OF_CREATED_HUBS[2].name} has been successfully created" is shown on path management page
    And Operator verify created manual path data with "multiple" schedule in path detail with following data:
      | originHubName       | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}        |
      | departureTime       | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[1]} |
      | departureTimeSecond | {KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES[2]} |
    When Operator searches "{KEY_LIST_OF_CREATED_HUBS[1].name} " in "Path" field
    Then Operator verify path data from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" appear in path table
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path without Selecting Schedule (uid:9f133662-b9ec-4395-8c50-b7ec516b9ea6)
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
      | selectSchedule     | none                               |
    And Operator clicks create button in create manual path modal
    Then Operator verify it cannot create manual path "no schedule(s) selected" with data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Adding Transit Hub Fails no schedule from Origin to Transit Hub (uid:b0e503d1-1d55-4cc6-adab-b49672f1b16a)
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

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Adding Transit Hub Fails no schedule from Transit Hub to Destination Hub (uid:997f674a-9433-4807-b537-cfcca6d1892d)
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

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Cancel Creating Path (uid:4fbdec5e-a707-4897-a2e3-b72b404c4f62)
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
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator cancel add manual path button after fill "{KEY_LIST_OF_CREATED_HUBS[1].name}" and "{KEY_LIST_OF_CREATED_HUBS[2].name}" as origin and destination hub
    Then Operator verify it will direct to path management page

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Retract Step  in Creating Path (uid:12090f37-ee2b-4b4e-8df8-c47437eab517)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | selectSchedule     | false                              |
    Then Operator verify transit hub input empty after retract one step with "{KEY_LIST_OF_CREATED_HUBS[4].name}" and "{KEY_LIST_OF_CREATED_HUBS[3].name}" as origin and destination hub

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Removing Transit Hub (uid:7c5a61d2-d09c-4a06-b2b1-d3f37a646407)
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

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - No Schedule for Origin-Destination (uid:97537292-187c-4215-9634-98d9ae5efbb7)
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
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | selectSchedule     | false                              |
    And Operator clicks next button in create manual path modal
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path with Multiple Same Transit Hubs (uid:cdddc689-3282-4e01-aa54-2bde018ad094)
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
    Then Operator verify it cannot create manual path "multiple same transit hubs" with data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Schedule Not Available / Conflicted with Other Paths (uid:aaf82481-3714-4b4c-9461-a9833ac2bc7d)
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
    Given API Operator create manual path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | selectSchedule     | none                               |
    And Operator clicks create button in create manual path modal
    Then Operator verify it cannot create manual path "no schedule(s) available" with data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Update First Transit Hub (uid:d0ac46d7-22b6-4b91-bbe6-ab2357c666af)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 6 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 3
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[5].id}" plus hours 4
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName        | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName   | {KEY_LIST_OF_CREATED_HUBS[5].name} |
      | transitHubName       | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubNameSecond | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | transitHubNameThird  | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | selectSchedule       | false                              |
    And Operator update "first" transit hub with "{KEY_LIST_OF_CREATED_HUBS[6].name}"
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[6].name} |
    And Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[6].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Update Second Transit Hub (uid:5b9f4521-2d00-4024-b093-629caa2f6693)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 6 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 3
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[5].id}" plus hours 4
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName        | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName   | {KEY_LIST_OF_CREATED_HUBS[5].name} |
      | transitHubName       | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubNameSecond | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | transitHubNameThird  | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | selectSchedule       | false                              |
    And Operator update "second" transit hub with "{KEY_LIST_OF_CREATED_HUBS[6].name}"
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[6].name} |
    And Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[6].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[4].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Update Third Transit Hub (uid:2e15e03b-595a-429a-b3a9-1ba052e36c70)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 6 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 3
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[5].id}" plus hours 4
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName        | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName   | {KEY_LIST_OF_CREATED_HUBS[5].name} |
      | transitHubName       | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubNameSecond | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | transitHubNameThird  | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | selectSchedule       | false                              |
    And Operator update "third" transit hub with "{KEY_LIST_OF_CREATED_HUBS[6].name}"
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[6].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Removing First Transit Hub (uid:a43b4d86-52d2-4ca1-870a-849331a81f5d)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 3
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[5].id}" plus hours 4
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName        | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName   | {KEY_LIST_OF_CREATED_HUBS[5].name} |
      | transitHubName       | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubNameSecond | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | transitHubNameThird  | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | selectSchedule       | false                              |
    And Operator remove "first" transit hub
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Removing Second Transit Hub (uid:2fe6c04a-d0af-4af9-9291-ce47b060ffae)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 3
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[5].id}" plus hours 4
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName        | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName   | {KEY_LIST_OF_CREATED_HUBS[5].name} |
      | transitHubName       | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubNameSecond | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | transitHubNameThird  | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | selectSchedule       | false                              |
    And Operator remove "second" transit hub
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[4].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Unable to Create New Path - Removing Third Transit Hub (uid:eae2aeaf-2c4e-4ceb-a1db-214534e96887)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 3
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[5].id}" plus hours 4
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Path Management
    And Operator verifies path management page is loaded
    When Operator clicks add manual path button
    And Operator create manual path with following data:
      | originHubName        | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHubName   | {KEY_LIST_OF_CREATED_HUBS[5].name} |
      | transitHubName       | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | transitHubNameSecond | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | transitHubNameThird  | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | selectSchedule       | false                              |
    And Operator remove "third" transit hub
    Then Operator verify it cannot create manual path "no schedules between hubs" with data:
      | sourceHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | targetHub | {KEY_LIST_OF_CREATED_HUBS[5].name} |

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb @CloseNewWindows
  Scenario: Create New Path with Different Path and Same Schedule using 2 tabs (uid:21db2b2e-0183-4272-afeb-aaea601d447d)
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
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table
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
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[4].id}" is created in movement_path table

  @DeleteHubsViaDb @SoftDeleteAllCreatedMovementsViaDb @CloseNewWindows
  Scenario: Create New Path with Same Path and Same Schedule using 2 tabs (uid:3cd2a72f-3cda-4d72-a5f2-1a06effc81eb)
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
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
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
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table
    When Operator switch to new tab in path management page
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
    When Operator switch to main tab in path management page
    And Operator verifies path management page is loaded
    And Operator click "view" hyperlink button
    Then Operator verify created manual path data in path detail empty schedule with following data:
      | originHubName      | {KEY_LIST_OF_CREATED_HUBS[1].name}        |
      | destinationHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}        |
      | transitHubName     | {KEY_LIST_OF_CREATED_HUBS[3].name}        |
    Then DB Operator verifies manual path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is created in movement_path table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op