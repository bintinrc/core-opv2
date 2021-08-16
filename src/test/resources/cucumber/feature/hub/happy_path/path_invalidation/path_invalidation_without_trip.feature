@OperatorV2 @HappyPath @Hub @PathInvalidation @WithoutTrip
Feature: Path Invalidation - Without Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteShipments @DeleteHubsViaDb @DeletePaths
  Scenario: Disable Hub - Van Inbound w/o Trip (uid:9061e7dc-4fd6-4c4a-89af-089dbcd1ee27)
    Given API Operator creates hubs for "CD->CD" movement
    And API Operator reloads hubs cache
    Given API Operator creates paths for "CD->CD" movement
    Then DB Operator verifies number of path for "CD->CD" movement existence
    When API Operator creates schedules for "CD->CD" movement
    Then DB Operator verifies number of path for "CD->CD" movement existence
    When API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    When Operator activate hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    And API Operator reloads hubs cache
    Given API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
    And DB Operator verify sla in movement_events table is "FAILED" no path for the following shipments from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}":
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
    And DB Operator verify path in movement_path table is not found for shipments from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table

  @DeleteHubsViaAPI @DeleteShipments @DeleteHubsViaDb @DeletePaths
  Scenario Outline: Create Schedule - Van Inbound w/o Trip - <dataset_name> (<hiptest-uid>)
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
      | type                    | hiptest-uid                              | dataset_name            |
      | CD->its ST              | uid:612b4e0a-6623-4490-a492-2e3e362c4a62 | CD->its ST              |
      | CD->ST under another CD | uid:d14c3714-735f-4b89-9cb9-95bdf2920b96 | CD->ST under another CD |
      | ST->ST under same CD    | uid:479c63a9-7583-426a-9e39-615dc9fb404c | ST->ST under same CD    |
      | ST->ST under diff CD    | uid:295ed544-9af4-4bdc-9ffa-6f525a532416 | ST->ST under diff CD    |
      | ST->its CD              | uid:90291ecf-4506-477f-820c-7bbdf498b67c | ST->its CD              |
      | ST->another CD          | uid:13fbf917-2049-441d-86f3-53532277175a | ST->another CD          |

  @DeleteHubsViaAPI @DeleteShipments @DeleteHubsViaDb @DeletePaths
  Scenario: Create Schedule (CD->CD) - Van Inbound w/o Trip (uid:367bcf45-aa5d-45f2-8745-e864d79aa368)
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

  @DeleteHubsViaAPI @DeleteShipments @DeleteHubsViaDb @DeletePaths
  Scenario Outline: Update Schedule - Van Inbound w/o Trip - <dataset_name> (<hiptest-uid>)
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
      | type                    | hiptest-uid                              | dataset_name            |
      | CD->CD                  | uid:53a62f62-fb75-4e31-a5ed-165090f62087 | CD->CD                  |
      | CD->its ST              | uid:5a63fa06-1ff9-4eec-ba4a-72bce3ce9c22 | CD->its ST              |
      | CD->ST under another CD | uid:d03bb631-6127-447d-bdd3-062dcbf85bba | CD->ST under another CD |
      | ST->ST under same CD    | uid:d86f0aef-bfb9-4232-812a-f8e59b975784 | ST->ST under same CD    |
      | ST->ST under diff CD    | uid:d6f59d15-df78-4552-88b7-415324faca1a | ST->ST under diff CD    |
      | ST->its CD              | uid:27b0fcb8-9545-4805-93a2-4a570c61db88 | ST->its CD              |
      | ST->another CD          | uid:c7abd7cf-3be2-4630-a8bb-c20160394c40 | ST->another CD          |

  @DeleteHubsViaAPI @DeleteShipments @DeleteHubsViaDb @DeletePaths
  Scenario Outline: Delete Schedules - Van Inbound w/o Trip - <dataset_name> (<hiptest-uid>)
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
    And API Operator reloads hubs cache
    Given API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    And DB Operator verify sla in movement_events table for "<type>" no path for the following shipments from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}":
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Examples:
      | type                    | hiptest-uid                              | dataset_name            |
      | CD->CD                  | uid:144c1e0b-0308-4902-ab7d-5d44c7d1de05 | CD->CD                  |
      | CD->its ST              | uid:546b25dc-47f0-48c3-96c6-46fc4dd3799e | CD->its ST              |
      | CD->ST under another CD | uid:afa96b18-a413-4566-93e5-f64fa9065cad | CD->ST under another CD |
      | ST->ST under same CD    | uid:41e7d0f3-5f42-4982-b390-cedd77094e68 | ST->ST under same CD    |
      | ST->ST under diff CD    | uid:c7d5f5ee-6193-4351-bb9e-22072110d1a4 | ST->ST under diff CD    |
      | ST->its CD              | uid:b70e11e4-a04e-46e1-9306-e8ad296cab2a | ST->its CD              |
      | ST->another CD          | uid:5e5a078b-a995-4431-870b-711e9d63df4f | ST->another CD          |

  @DeleteHubsViaAPI @DeleteShipments @DeleteHubsViaDb @DeletePaths
  Scenario: Update Hub Facility Type - Van Inbound w/o Trip (uid:1ae6ad5d-87a0-4480-803a-97e3425d1ef3)
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
    And API Operator reloads hubs cache
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
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[6]} |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table

  @DeleteHubsViaAPI @DeleteShipments @DeleteHubsViaDb @DeletePaths
  Scenario: Update Hub LatLong - Van Inbound w/o Trip (uid:639901be-0c49-4328-976f-d8f8c32f0e35)
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
    And API Operator reloads hubs cache
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

  @DeleteHubsViaAPI @DeleteShipments @DeleteHubsViaDb @DeletePaths
  Scenario: Update Hub Crossdock - Van Inbound w/o Trip (uid:985f6f95-07ed-4916-b465-1a0e6958ffb4)
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