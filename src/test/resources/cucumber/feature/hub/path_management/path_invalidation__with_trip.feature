@OperatorV2 @MiddleMile @Hub @PathManagement @PathInvalidation @WithTrip @CFW
Feature: Path Invalidation - With Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments @DeleteHubsViaDb @DeleteDriver @SoftDeleteAllCreatedMovementsViaDb @RT
  Scenario: Disable Hub - Van Inbound w/ Trip (uid:9508ba48-a19a-4632-bff5-1f58f51cfada)
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator create "manual" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And API Operator create "manual" path with movement schedule id "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 4 in movement_path table
    Given Operator go to menu Hubs -> Facilities Management
    When Operator disable hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    Then DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" is deleted in hub_relation_schedules
    And DB Operator verify "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}" is deleted in hub_relation_schedules
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[1]}" is deleted in movement_path table
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[2]}" is deleted in movement_path table
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[3]}" is deleted in movement_path table
    And DB Operator verify "{KEY_LIST_OF_CREATED_PATH_ID[4]}" is deleted in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 0 in movement_path table
    Given API Operator does the "van-inbound" scan from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}" for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]} |
    And DB Operator verify sla in movement_events table is "FAILED" no path for the following shipments from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}":
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]} |
    And DB Operator verify path in movement_path table is not found for shipments from "{KEY_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    When Operator activate hub with name "{KEY_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[3].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[4].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[4].id}"
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[6]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[4].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[4]}              |
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "LAND_HAUL" is created in movement_path table
    Then DB Operator verifies "default" path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" with type "AIR_HAUL" is created in movement_path table
    Then DB Operator verifies number of path with origin "{KEY_LIST_OF_CREATED_HUBS[1].id}" and "{KEY_LIST_OF_CREATED_HUBS[2].id}" is 2 in movement_path table


  @DeleteShipments @DeleteHubsViaDb @DeleteDriver @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Create Schedule (CD->CD) - Van Inbound w/ Trip (uid:46da887e-b5b5-4467-b3fa-523bc849e964)
    Given no-op

  @DeleteShipments @DeleteHubsViaDb @DeleteDriver @SoftDeleteAllCreatedMovementsViaDb
  Scenario: Create Hub - Van Inbound w/ Trip (uid:81204411-101b-4a3e-9d27-1bc0a8799ca9)
    Given no-op

  @DeleteShipments @DeleteHubsViaDb @DeleteDriver @SoftDeleteAllCreatedMovementsViaDb @SoftDeleteCrossdockDetailsViaDb
  Scenario Outline: Create Schedule - Van Inbound w/ Trip (<hiptest-uid>)
    Given no-op
    Examples:
      | type                    | hiptest-uid                              |
      | CD->its ST              | uid:399b75c2-1cc9-43f1-b1ae-c06bd009ecfb |
      | CD->ST under another CD | uid:c76fe7ad-8546-4cc6-8aa1-de13d81f2cd4 |
      | ST->ST under same CD    | uid:013f79ad-a09f-45b9-a545-1b83d8ebc711 |
      | ST->ST under diff CD    | uid:b02e9b5e-451d-4512-8990-20e10ed36fed |
      | ST->its CD              | uid:e5f7b489-120d-4ba9-b1ac-323430349498 |
      | ST->another CD          | uid:126c6464-a9ed-4ec1-b231-404e17d43c55 |

  @DeleteShipments @DeleteHubsViaDb @DeleteDriver @SoftDeleteAllCreatedMovementsViaDb @SoftDeleteCrossdockDetailsViaDb
  Scenario Outline: Delete Schedule - Van Inbound w/ Trip (<hiptest-uid>)
    Given no-op
    Examples:
      | Type                    | hiptest-uid                              |
      | CD->CD                  | uid:d7b5f328-d925-49ec-b588-bf83361f94fd |
      | CD->its ST              | uid:7ac35d22-467d-4568-867a-1da0768aff76 |
      | CD->ST under another CD | uid:85bab802-0b36-4a43-b2e8-f290b4016c95 |
      | ST->ST under same CD    | uid:17af7f47-7cf3-4989-b692-c2f576ecda2e |
      | ST->ST under diff CD    | uid:a55f4523-07b5-46d3-9356-e14c47227e60 |
      | ST->its CD              | uid:dea31cba-d6b7-4da5-a093-ca88d817f3cd |
      | ST->another CD          | uid:cf1708e4-be28-4f7e-b43d-5d8eeb2feab9 |

  @DeleteShipments @DeleteHubsViaDb @DeleteDriver @SoftDeleteAllCreatedMovementsViaDb @SoftDeleteCrossdockDetailsViaDb
  Scenario Outline: Update Hub Facility Type - Van Inbound w/ Trip (<hiptest-uid>)
    Given no-op
    Examples:
      | name                                           | hiptest-uid                              |
      | Crossdock to Crossdock                         | uid:3199582c-3eb0-4c72-b1a0-fb27b91753f7 |
      | Crossdock to its Station                       | uid:8ccefc09-f6d7-4016-b945-82b4508016be |
      | Crossdock to another Crossdock's Station       | uid:570fadaf-ed34-4f70-af21-d211b3f01121 |
      | Station to Station under the same Crossdock    | uid:39218116-db23-4266-825e-6f9456c3f210 |
      | Station to Station under a different Crossdock | uid:fc72ce77-f150-49c4-9e4f-a4824646cb39 |
      | Station to its Crossdock                       | uid:81e4e681-9bf7-415b-8338-ec7667c2f3ab |
      | Station to different Crossdock                 | uid:9fa1bb89-baad-480d-8e38-08c667ea1e2a |

  @DeleteShipments @DeleteHubsViaDb @DeleteDriver @SoftDeleteAllCreatedMovementsViaDb @SoftDeleteCrossdockDetailsViaDb
  Scenario Outline: Update Hub LatLong - Van Inbound w/ Trip (<hiptest-uid>)
    Given no-op
    Examples:
      | name                                           | hiptest-uid                              |
      | Crossdock to Crossdock                         | uid:fa5b0310-38a2-489f-9914-e18d523d1ebf |
      | Crossdock to its Station                       | uid:6a57c1ef-cf16-4c73-a0b0-bffeaff6274f |
      | Crossdock to another Crossdock's Station       | uid:02d51f9b-b7c3-4527-a902-53ba407005ed |
      | Station to Station under the same Crossdock    | uid:d71939f2-8245-4c9c-98a8-63ed504c329b |
      | Station to Station under a different Crossdock | uid:812d3bb3-8e4f-41cd-ac56-4c2c29fc87f1 |
      | Station to its Crossdock                       | uid:a041410f-d8e2-4bbc-9e85-db73e080366b |
      | Station to different Crossdock                 | uid:bb9173f7-50ae-47c5-a59c-876d61a537b9 |

  @DeleteShipments @DeleteHubsViaDb @DeleteDriver @SoftDeleteAllCreatedMovementsViaDb @SoftDeleteCrossdockDetailsViaDb
  Scenario Outline: Activate Hub - Van Inbound w/ Trip (<hiptest-uid>)
    Given no-op
    Examples:
      | name                                           | hiptest-uid                              |
      | Crossdock to Crossdock                         | uid:d822d773-d61f-4623-bdca-f56879a63814 |
      | Crossdock to its Station                       | uid:ce32c286-fb30-4308-9da3-04f75d90e60a |
      | Crossdock to another Crossdock's Station       | uid:be20ecaf-dfca-417c-8114-84355e3e0869 |
      | Station to Station under the same Crossdock    | uid:5924659b-806d-43fb-854c-08fd9b4414cd |
      | Station to Station under a different Crossdock | uid:db4b4b48-7c74-42b0-8780-cd53f0083f11 |
      | Station to its Crossdock                       | uid:d26cdc17-907c-4b8b-b607-4a7c01b76070 |
      | Station to different Crossdock                 | uid:e7061ba4-0bee-4a9d-b220-66d2a2c1d60a |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op