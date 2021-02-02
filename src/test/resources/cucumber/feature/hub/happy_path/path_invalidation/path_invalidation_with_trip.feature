@OperatorV2 @HappyPath @Hub @PathInvalidation @WithTrip
Feature: Path Invalidation - With Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteShipments @DeleteDriver
  Scenario: Disable Hub - Van Inbound w/ Trip (uid:ccacfd65-f06e-4894-bd3e-13805e9a0563)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates hubs for "CD->CD" movement
    And API Operator reloads hubs cache
    And API Operator creates paths for "CD->CD" movement
    Given Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    When Operator disable hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table

  @DeleteHubsViaAPI @DeleteShipments @DeleteDriver
  Scenario Outline: Create Schedule - Van Inbound w/ Trip - <type> - (<hiptest-uid>)
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
      | type                    | hiptest-uid                              |
      | CD->its ST              | uid:23c96087-4936-48ad-a51c-00e7d2a1b5ab |
      | CD->ST under another CD | uid:d747a8b6-096f-4f5b-8fdd-e475d8859c42 |
      | ST->ST under same CD    | uid:9405c9a4-7a01-4666-8437-14b624b5d60b |
      | ST->ST under diff CD    | uid:4b6b06f4-95c3-4fc2-b9ae-69f84f0c8527 |
      | ST->its CD              | uid:f4d92967-25df-42d9-b0fe-6943140df265 |
      | ST->another CD          | uid:30e1fe63-c920-43db-8838-23f60ef5f0b5 |

  @DeleteHubsViaAPI @DeleteShipments @DeleteDriver
  Scenario: Create Schedule (CD->CD) - Van Inbound w/ Trip (uid:13c6c5a7-b889-40f8-a1a2-480d38bf192a)
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

  @DeleteHubsViaAPI @DeleteShipments @DeleteDriver
  Scenario Outline: Update Schedule - Van Inbound w/ Trip - (<type>) - (<hiptest-uid>)
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
      | type                    | hiptest-uid                              |
      | CD->CD                  | uid:8fe30856-ab34-41b5-b9b0-865ad2e5dfe5 |
      | CD->its ST              | uid:bd46bca6-411e-483a-9fda-8e12b5c69947 |
      | CD->ST under another CD | uid:60d5a956-ed3c-4dd5-a788-622f5f0fda12 |
      | ST->ST under same CD    | uid:5f617c12-31d0-4859-88f8-e5af037c5f97 |
      | ST->ST under diff CD    | uid:fbff044e-eb5d-4133-8aeb-29f096780385 |
      | ST->its CD              | uid:0cb2af56-3c14-4e98-92d3-f26161167f71 |
      | ST->another CD          | uid:f0bf3668-5740-4fa5-8658-457a23fa4687 |

  @DeleteHubsViaAPI @DeleteShipments @DeleteDriver
  Scenario Outline: Delete Schedule - Van Inbound w/ Trip - <type> - (<hiptest-uid>)
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
      | type                    | hiptest-uid                              |
      | CD->CD                  | uid:15ba9100-2e9e-4251-ba2b-7da197f5767d |
      | CD->its ST              | uid:76d240e4-1985-4265-83c8-c1bb36d225c5 |
      | CD->ST under another CD | uid:ef51feaa-a2b6-492b-99ad-5bd5fac3fe54 |
      | ST->ST under same CD    | uid:0995cf18-4177-46bf-bb2f-3e91836e55c8 |
      | ST->ST under diff CD    | uid:ff8af3c5-b57f-44c3-84ab-d557ddaa9009 |
      | ST->its CD              | uid:fc0fee7b-b7a4-4781-8eb0-666c00c1cdcf |
      | ST->another CD          | uid:e9f964f4-b2c8-4ba4-bcac-98957b35c949 |

  @DeleteHubsViaAPI @DeleteShipments @DeleteDriver
  Scenario Outline: Update Hub Facility Type - Van Inbound w/ Trip - <name> - (<hiptest-uid>)
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
      | name                                           | hiptest-uid                              | type                    |
      | Crossdock to Crossdock                         | uid:d3ee340d-e0aa-4a53-8aee-b2b79ebb8a8f | CD->CD                  |
      | Crossdock to its Station                       | uid:58bb6ce8-36ef-4628-a0e0-e3a8e3b3091f | CD->its ST              |
      | Crossdock to another Crossdock's Station       | uid:d9f1f670-ce98-4c5f-b9d0-656a879694b2 | CD->ST under another CD |
      | Station to Station under the same Crossdock    | uid:afb31544-1328-406b-aef7-1995928c3364 | ST->ST under same CD    |
      | Station to Station under a different Crossdock | uid:234fa38b-223e-4f83-8bb4-92955b71acaa | ST->ST under diff CD    |
      | Station to its Crossdock                       | uid:59eaf7f5-eb64-45f1-be05-53ef33709a79 | ST->its CD              |
      | Station to different Crossdock                 | uid:8182c2b2-2f65-4c7a-9beb-9356c3330429 | ST->another CD          |

  @DeleteHubsViaAPI @DeleteShipments @DeleteDriver
  Scenario Outline: Update Hub LatLong - Van Inbound w/ Trip - <name> - (<hiptest-uid>)
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
      | name                                           | hiptest-uid                              | type                    |
      | Crossdock to Crossdock                         | uid:809cb8eb-15ec-4cf7-9ef1-134173100772 | CD->CD                  |
      | Crossdock to its Station                       | uid:e1069cc8-ca2f-4016-8128-b999286655b6 | CD->its ST              |
      | Crossdock to another Crossdock's Station       | uid:72d24634-75ed-4114-977d-cf6bcd6ae168 | CD->ST under another CD |
      | Station to Station under the same Crossdock    | uid:d42272d1-3ea4-4c25-90a7-40c094edaf29 | ST->ST under same CD    |
      | Station to Station under a different Crossdock | uid:9d6fe333-17e1-452f-beb6-c1af7a398623 | ST->ST under diff CD    |
      | Station to its Crossdock                       | uid:920fd545-4fc0-4549-8fd4-9b42bbf10c7e | ST->its CD              |
      | Station to different Crossdock                 | uid:52ebbf20-c974-4f52-bba5-d8931ff0d84b | ST->another CD          |

  @DeleteHubsViaAPI @DeleteShipments @DeleteDriver
  Scenario: Update Hub Crossdock - Van Inbound w/ Trip (uid:8814b598-b88b-4019-97d6-4f2844852a46)
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