@OperatorV2 @MiddleMile @Hub @PathInvalidation @WithTrip
Feature: Path Invalidation - With Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario: Disable Hub - Van Inbound w/ Trip (uid:9508ba48-a19a-4632-bff5-1f58f51cfada)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates hubs for "CD->CD" movement
    And API Operator reloads hubs cache
    And API Operator creates paths for "CD->CD" movement
    Given Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    When Operator disable hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario: Create Schedule (CD->CD) - Van Inbound w/ Trip (uid:46da887e-b5b5-4467-b3fa-523bc849e964)
    Given API Operator creates hubs for "CD->CD" movement
    And API Operator reloads hubs cache
    Given API Operator creates paths for "CD->CD" movement
    Then DB Operator verifies number of path for "CD->CD" movement existence
    When API Operator creates schedules for "CD->CD" movement
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver to movement schedules for "CD->CD" movement
    Then DB Operator verifies number of path for "CD->CD" movement existence
    When API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the shipment van inbound scan for "CD->CD" movement "SUCCESS" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verify sla in movement events table for "CD->CD" movement
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path for "CD->CD" movement existence after van inbound
    And DB Operator verify created hub relation schedules is not deleted

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario: Create Hub - Van Inbound w/ Trip (uid:81204411-101b-4a3e-9d27-1bc0a8799ca9)
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
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table
    And DB Operator verify sla in movement_events table from "{KEY_LIST_OF_CREATED_HUBS[1].name}" to "{KEY_LIST_OF_CREATED_HUBS[2].name}" is succeed for the following data:
      | hubRelationIds | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]},{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} |
      | shipmentIds    | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]},{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}           |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario Outline: Create Schedule - Van Inbound w/ Trip - <dataset_name> (<hiptest-uid>)
    Given API Operator creates hubs for "<type>" movement
    And API Operator reloads hubs cache
    Given API Operator creates paths for "<type>" movement
    Then DB Operator verifies number of path for "<type>" movement existence
    When API Operator creates schedules for "<type>" movement
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver to movement schedules for "<type>" movement
    Then DB Operator verifies number of path for "<type>" movement existence
    When API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the shipment van inbound scan for "<type>" movement "SUCCESS" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verify sla in movement events table for "<type>" movement
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path for "<type>" movement existence after van inbound
    And DB Operator verify created hub relation schedules is not deleted
    Examples:
      | type                    | hiptest-uid                              | dataset_name             |
      | CD->its ST              | uid:399b75c2-1cc9-43f1-b1ae-c06bd009ecfb | CD->its ST               |
      | CD->ST under another CD | uid:c76fe7ad-8546-4cc6-8aa1-de13d81f2cd4 | CD->ST under another CD  |
      | ST->ST under same CD    | uid:013f79ad-a09f-45b9-a545-1b83d8ebc711 | ST->ST under same CD     |
      | ST->ST under diff CD    | uid:b02e9b5e-451d-4512-8990-20e10ed36fed | ST->ST under diff CD     |
      | ST->its CD              | uid:e5f7b489-120d-4ba9-b1ac-323430349498 | ST->its CD               |
      | ST->another CD          | uid:126c6464-a9ed-4ec1-b231-404e17d43c55 | ST->another CD           |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario Outline: Delete Schedule - Van Inbound w/ Trip - <dataset_name> (<hiptest-uid>)
    Given API Operator creates hubs for "<type>" movement
    And API Operator creates paths for "<type>" movement
    Then DB Operator verifies number of path for "<type>" movement existence
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver to movement schedules for "<type>" deleted movement
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Operator refresh page
    And Movement Management page is loaded
    And Operator deletes schedule for "<type>" movement
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules
    When API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the shipment van inbound scan for "<type>" movement "FAIL" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Examples:
      | type                    | hiptest-uid                              | dataset_name             |
      | CD->CD                  | uid:d7b5f328-d925-49ec-b588-bf83361f94fd | CD->CD                   |
      | CD->its ST              | uid:7ac35d22-467d-4568-867a-1da0768aff76 | CD->its ST               |
      | CD->ST under another CD | uid:85bab802-0b36-4a43-b2e8-f290b4016c95 | CD->ST under another CD  |
      | ST->ST under same CD    | uid:17af7f47-7cf3-4989-b692-c2f576ecda2e | ST->ST under same CD     |
      | ST->ST under diff CD    | uid:a55f4523-07b5-46d3-9356-e14c47227e60 | ST->ST under diff CD     |
      | ST->its CD              | uid:dea31cba-d6b7-4da5-a093-ca88d817f3cd | ST->its CD               |
      | ST->another CD          | uid:cf1708e4-be28-4f7e-b43d-5d8eeb2feab9 | ST->another CD           |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario Outline: Update Hub Facility Type - Van Inbound w/ Trip - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates hubs for "<type>" movement
    And API Operator reloads hubs cache
    Given API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator creates paths for "<type>" movement
    Then DB Operator verifies number of path for "<type>" movement existence
    Given Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    And Operator update hub column facility type for first hub into type "DP"
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules
    And DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    Given API Operator does the shipment van inbound scan for "<type>" movement "FAIL" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
    Given Operator refresh page
    When Operator revert hub column facility type for first hub for type "<type>"
    And API Operator assign stations to its crossdock for "<type>" movement
    And API Operator creates schedules for "<type>" movement
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver to movement schedules for "<type>" movement
    Given API Operator does the shipment van inbound scan for "<type>" movement for the following shipments with new schedules
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table
    Examples:
      | name                                           | hiptest-uid                              | type                    | dataset_name                                    |
      | Crossdock to Crossdock                         | uid:3199582c-3eb0-4c72-b1a0-fb27b91753f7 | CD->CD                  | Crossdock to Crossdock                          |
      | Crossdock to its Station                       | uid:8ccefc09-f6d7-4016-b945-82b4508016be | CD->its ST              | Crossdock to its Station                        |
      | Crossdock to another Crossdock's Station       | uid:570fadaf-ed34-4f70-af21-d211b3f01121 | CD->ST under another CD | Crossdock to another Crossdock's Station        |
      | Station to Station under the same Crossdock    | uid:39218116-db23-4266-825e-6f9456c3f210 | ST->ST under same CD    | Station to Station under the same Crossdock     |
      | Station to Station under a different Crossdock | uid:fc72ce77-f150-49c4-9e4f-a4824646cb39 | ST->ST under diff CD    | Station to Station under a different Crossdock  |
      | Station to its Crossdock                       | uid:81e4e681-9bf7-415b-8338-ec7667c2f3ab | ST->its CD              | Station to its Crossdock                        |
      | Station to different Crossdock                 | uid:9fa1bb89-baad-480d-8e38-08c667ea1e2a | ST->another CD          | Station to different Crossdock                  |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario Outline: Update Hub LatLong - Van Inbound w/ Trip - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates hubs for "<type>" movement
    Given API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator creates paths for "<type>" movement
    Then DB Operator verifies number of path for "<type>" movement existence
    And API Operator reloads hubs cache
    Given Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator update hub column longitude latitude for first hub into "103.3424231" and "1.39421"
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is not deleted in hub_relation_schedules
    Then DB Operator verifies number of path for "<type>" movement existence
    Given API Operator does the shipment van inbound scan for "<type>" movement "FAIL" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
    Given Operator refresh page
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator update hub column longitude latitude for first hub into "{KEY_LIST_OF_CREATED_HUBS[1].longitude}" and "{KEY_LIST_OF_CREATED_HUBS[1].latitude}"
    When API Operator creates schedules for "<type>" movement
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver to movement schedules for "<type>" movement
    Given API Operator does the shipment van inbound scan for "<type>" movement for the following shipments with new schedules
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 3 in movement_path table
    Examples:
      | name                                           | hiptest-uid                              | type                    | dataset_name                                    |
      | Crossdock to Crossdock                         | uid:fa5b0310-38a2-489f-9914-e18d523d1ebf | CD->CD                  | Crossdock to Crossdock                          |
      | Crossdock to its Station                       | uid:6a57c1ef-cf16-4c73-a0b0-bffeaff6274f | CD->its ST              | Crossdock to its Station                        |
      | Crossdock to another Crossdock's Station       | uid:02d51f9b-b7c3-4527-a902-53ba407005ed | CD->ST under another CD | Crossdock to another Crossdock's Station        |
      | Station to Station under the same Crossdock    | uid:d71939f2-8245-4c9c-98a8-63ed504c329b | ST->ST under same CD    | Station to Station under the same Crossdock     |
      | Station to Station under a different Crossdock | uid:812d3bb3-8e4f-41cd-ac56-4c2c29fc87f1 | ST->ST under diff CD    | Station to Station under a different Crossdock  |
      | Station to its Crossdock                       | uid:a041410f-d8e2-4bbc-9e85-db73e080366b | ST->its CD              | Station to its Crossdock                        |
      | Station to different Crossdock                 | uid:bb9173f7-50ae-47c5-a59c-876d61a537b9 | ST->another CD          | Station to different Crossdock                  |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario Outline: Activate Hub - Van Inbound w/ Trip - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates hubs for "<type>" movement
    And API Operator reloads hubs cache
    And API Operator creates paths for "<type>" movement
    Given Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    When Operator disable hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    And Operator activate hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    And API Operator assign stations to its crossdock for "<type>" movement
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When API Operator creates schedules for "<type>" movement
    And API Operator assign driver to movement schedules for "<type>" movement
    Given API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the shipment van inbound scan for "<type>" movement for the following shipments with new schedules
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verify sla in movement events table for "<type>" movement with deleted movements
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table
    Examples:
      | name                                           | hiptest-uid                              | type                    | dataset_name                                   |
      | Crossdock to Crossdock                         | uid:d822d773-d61f-4623-bdca-f56879a63814 | CD->CD                  | Crossdock to Crossdock                         |
      | Crossdock to its Station                       | uid:ce32c286-fb30-4308-9da3-04f75d90e60a | CD->its ST              | Crossdock to its Station                       |
      | Crossdock to another Crossdock's Station       | uid:be20ecaf-dfca-417c-8114-84355e3e0869 | CD->ST under another CD | Crossdock to another Crossdock's Station       |
      | Station to Station under the same Crossdock    | uid:5924659b-806d-43fb-854c-08fd9b4414cd | ST->ST under same CD    | Station to Station under the same Crossdock    |
      | Station to Station under a different Crossdock | uid:db4b4b48-7c74-42b0-8780-cd53f0083f11 | ST->ST under diff CD    | Station to Station under a different Crossdock |
      | Station to its Crossdock                       | uid:d26cdc17-907c-4b8b-b607-4a7c01b76070 | ST->its CD              | Station to its Crossdock                       |
      | Station to different Crossdock                 | uid:e7061ba4-0bee-4a9d-b220-66d2a2c1d60a | ST->another CD          | Station to different Crossdock                 |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario Outline: Update Schedule - Van Inbound w/ Trip - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates hubs for "<type>" movement
    And API Operator reloads hubs cache
    And API Operator creates paths for "<type>" movement
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Operator refresh page
    And Movement Management page is loaded
    And Operator updates schedule for "<type>" movement
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When API Operator creates schedules for "<type>" movement
    And API Operator assign driver to movement schedules for "<type>" movement
    Given API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator does the shipment van inbound scan for "<type>" movement for the following shipments with new schedules
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then DB Operator verify sla in movement events table for "<type>" movement with deleted movements
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    And DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 3 in movement_path table
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules
    And DB Operator verifies old path is deleted in path_schedule from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    Examples:
      | type                    | hiptest-uid                              | dataset_name             |
      | CD->CD                  | uid:52443762-c03e-4779-864d-57bc3d5bc39c | CD->CD                   |
      | CD->its ST              | uid:1b378bd2-5ba1-4267-b1be-93c3fa44e46d | CD->its ST               |
      | CD->ST under another CD | uid:34ed9af1-618b-4bd7-a288-f3e92801e8d3 | CD->ST under another CD  |
      | ST->ST under same CD    | uid:efc92644-cee9-4333-bdd7-1fe6ca2a482f | ST->ST under same CD     |
      | ST->ST under diff CD    | uid:9bdf6347-cf8a-4838-be33-2e7901e89af4 | ST->ST under diff CD     |
      | ST->its CD              | uid:d67fe776-092e-40a2-9f71-8c8acff3fd16 | ST->its CD               |
      | ST->another CD          | uid:d1ef4590-f8a0-4f80-95a6-07a9e43bf437 | ST->another CD           |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipments @DeleteDriver @DeletePaths
  Scenario: Update Hub Crossdock - Van Inbound w/ Trip (uid:52bb9070-535d-4005-8a0e-dbae60e08f0b)
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver to movement schedules for "ST->its CD" deleted movement
    When API Operator update assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[3].id}" for crossdock detail id "{KEY_HUB_CROSSDOCK_DETAIL_ID}"
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver to movement schedules for "ST->its CD" movement
    When API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Operator does the shipment van inbound scan for "ST->its CD" movement for the following shipments with new schedules
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