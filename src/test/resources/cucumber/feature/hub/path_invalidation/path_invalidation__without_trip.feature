@OperatorV2 @MiddleMile @Hub @PathInvalidation @WithoutTrip
Feature: Path Invalidation - Without Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario: Disable Hub - Van Inbound w/o Trip (uid:cf9d8bcf-302a-4646-920c-b737060c2f2c)
    Given API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create "manual" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 3 in movement_path table
    And Operator refresh page
    Given Operator go to menu Hubs -> Facilities Management
    When Operator disable hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    And Operator refresh page
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules
    And DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}" is deleted in hub_relation_schedules
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[1]}" is deleted in movement_path table
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[2]}" is deleted in movement_path table
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[3]}" is deleted in movement_path table

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario: Create Schedule (CD->CD) - Van Inbound w/o Trip (uid:7ecb6050-6f12-4856-be11-b25f27e8c3a1)
    Given API Operator creates hubs for "CD->CD" movement
    And API Operator reloads hubs cache
    Given API Operator creates paths for "CD->CD" movement
    Then DB Operator verifies number of path for "CD->CD" movement existence
    When API Operator creates schedules for "CD->CD" movement
    Then DB Operator verifies number of path for "CD->CD" movement existence
    When API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verify sla in movement events table for "CD->CD" movement
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path for "CD->CD" movement existence after van inbound
    And DB Operator verify created hub relation schedules is not deleted

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario Outline: Create Schedule - Van Inbound w/o Trip - <type> - (<hiptest-uid>)
    Given API Operator creates hubs for "<type>" movement
    And API Operator reloads hubs cache
    Given API Operator creates paths for "<type>" movement
    Then DB Operator verifies number of path for "<type>" movement existence
    When API Operator creates schedules for "<type>" movement
    Then DB Operator verifies number of path for "<type>" movement existence
    When API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verify sla in movement events table for "<type>" movement
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path for "<type>" movement existence after van inbound
    And DB Operator verify created hub relation schedules is not deleted
    Examples:
      | type                    | hiptest-uid                              |
      | CD->its ST              | uid:b1dc9df8-c0cd-4055-964b-45ae2eb4d08b |
      | CD->ST under another CD | uid:97f8988a-3e15-4c8a-8d3c-fdc3c8ce9393 |
      | ST->ST under same CD    | uid:c3a36fb3-4b0f-485e-bec8-598e29f394df |
      | ST->ST under diff CD    | uid:807955fd-7f34-4410-9a36-ea798d915ba4 |
      | ST->its CD              | uid:3b64b309-0e5b-43c5-9ef4-0359678bb10e |
      | ST->another CD          | uid:1396e561-1368-4a21-9233-939b8eebe6cf |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario Outline: Delete Schedules - Van Inbound w/o Trip - <type> - (<hiptest-uid>)
    Given API Operator creates hubs for "<type>" movement
    And API Operator creates paths for "<type>" movement
    Then DB Operator verifies number of path for "<type>" movement existence
    And API Operator reloads hubs cache
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Operator refresh page
    And Movement Management page is loaded
    And Operator deletes schedule for "<type>" movement
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules
    When API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    And DB Operator verify sla in movement_events table for "<type>" no path for the following shipments from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}":
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Examples:
      | type                    | hiptest-uid                              |
      | CD->CD                  | uid:725c5210-eb76-4497-b5a1-fc77690af7da |
      | CD->its ST              | uid:269ccd78-f9ac-47b7-a688-fe7828fe32df |
      | CD->ST under another CD | uid:055eacf5-c275-4cbf-a243-6f2f89e56376 |
      | ST->ST under same CD    | uid:a0a66a3a-2655-4f48-850f-64723394b784 |
      | ST->ST under diff CD    | uid:b9982c8d-c4ca-409b-a976-e3016993c2b4 |
      | ST->its CD              | uid:f9c9b675-cd90-46c4-b049-487f333c00f4 |
      | ST->another CD          | uid:d69b831a-8078-44e3-a9c6-c4e9b55e7b05 |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario: Create Hub - Van Inbound w/o Trip (uid:1ae0c8db-f594-49ee-a3d5-64c170f0bf74)
    Given API Operator creates 1 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator creates 1 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create "auto generated" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create "auto generated" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And Operator refresh page
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table
    Given API Operator creates 1 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is not deleted in hub_relation_schedules
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}" is not deleted in hub_relation_schedules
    Given API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table
    And DB Operator verify sla in movement_events table from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" is succeed for the following data:
      | hubRelationIds | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]},{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} |
      | shipmentIds    | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]},{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}           |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario: Activate Hub - Van Inbound w/o Trip (uid:e9da5cec-13e2-4dff-8c2d-5c96ceab4fbf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates hubs for "CD->CD" movement
    And API Operator reloads hubs cache
    And API Operator creates paths for "CD->CD" movement
    Given Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    When Operator disable hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    And Operator activate hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    And API Operator assign stations to its crossdock for "CD->CD" movement
    When API Operator creates schedules for "CD->CD" movement
    Given API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verify sla in movement events table for "CD->CD" movement with deleted movements
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario: Update Hub Facility Type - Van Inbound w/o Trip (uid:8e045648-1ed3-43bd-8230-d4e34968e791)
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
    Given API Operator create multiple 3 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 3 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create "manual" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 1 in movement_path table
    And API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 3 in movement_path table
    Given Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator update Hub column "facility type" with data:
      | facilityType | STATION |
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules
    And DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}" is deleted in hub_relation_schedules
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[1]}" is deleted in movement_path table
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[2]}" is deleted in movement_path table
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[3]}" is deleted in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    When API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]} |
    And DB Operator verify sla in movement_events table is "FAILED" no path for the following shipments from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}":
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]} |
    Given Operator refresh page
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator update Hub column "facility type" with data:
      | facilityType | CROSSDOCK HUB |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[6]} |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario: Update Hub LatLong - Van Inbound w/o Trip (uid:1871ff7b-b6e3-4ff5-89ff-c3d0a6de2dd2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates hubs for "CD->CD" movement
    Given API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator creates paths for "CD->CD" movement
    Then DB Operator verifies number of path for "CD->CD" movement existence
    And API Operator reloads hubs cache
    Given Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator update hub column longitude latitude for first hub into "103.3424231" and "1.39421"
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is not deleted in hub_relation_schedules
    Then DB Operator verifies number of path for "CD->CD" movement existence
    Given API Operator does the shipment van inbound scan for "CD->CD" movement "FAIL" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
    Given Operator refresh page
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator update hub column longitude latitude for first hub into "{KEY_LIST_OF_CREATED_HUBS[1].longitude}" and "{KEY_LIST_OF_CREATED_HUBS[1].latitude}"
    When API Operator creates schedules for "CD->CD" movement
    When API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 3 in movement_path table

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario Outline: Update Schedule - Van Inbound w/o Trip - <type> - (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates hubs for "<type>" movement
    And API Operator reloads hubs cache
    And API Operator creates paths for "<type>" movement
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Operator refresh page
    And Movement Management page is loaded
    And Operator updates schedule for "<type>" movement
    When API Operator creates schedules for "<type>" movement
    Given API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verify sla in movement events table for "<type>" movement with deleted movements
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 3 in movement_path table
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules
    And DB Operator verifies old path is deleted in path_schedule from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    Examples:
      | type                    | hiptest-uid                              |
      | CD->CD                  | uid:4758c7c0-3b64-448d-a610-799c67d17797 |
      | CD->its ST              | uid:dbb0a98d-079b-4d55-a54e-8cd266bc98c9 |
      | CD->ST under another CD | uid:5584f5a7-5353-4a72-b211-d82590a72e6b |
      | ST->ST under same CD    | uid:207792a9-1240-401e-afc8-0f82fc814fa4 |
      | ST->ST under diff CD    | uid:3acc101e-488b-4a3a-af93-f0f18dbe9f9d |
      | ST->its CD              | uid:ac329f12-8492-4e4a-b88c-ce799a2b0960 |
      | ST->another CD          | uid:1c16e9d7-ecd5-4d9e-8a0a-41528699980e |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeletePaths
  Scenario: Update Hub Crossdock - Van Inbound w/o Trip (uid:93382a6c-21b9-4af0-840f-57adbe0b6312)
    Given API Operator creates hubs for "ST->its CD" movement
    Given API Operator creates 1 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator creates paths for "ST->its CD" movement
    Then DB Operator verifies number of path for "ST->its CD" movement existence
    When API Operator update assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[3].id}" for crossdock detail id "{KEY_HUB_CROSSDOCK_DETAIL_ID}"
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    When API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    When API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[3].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    And DB Operator verify sla in movement_events table from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[3].name}" is succeed for the following data:
      | hubRelationIds | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]},{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[4]} |
      | shipmentIds    | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]},{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}           |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[3].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[3].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[3].id}" is 2 in movement_path table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op