@MiddleMile @Hub @InterHub @MovementSchedules @CrossdockHubsAddMultipleSchedules
Feature: Crossdock Hubs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create New Crossdock Movement Schedule - Create with Single Driver (uid:5a5db671-e5e7-48ea-890c-20bd18e65396)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    And API MM - Operator creates 1 new generated Middle Mile Drivers
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 15 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | all                                                                |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
    When Operator click "ok" button on Add Movement Schedule dialog
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name} |
    And API MM - Operator gets Movement Schedule from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    And API MM - Operator gets the next 8 days of Movement Trips departed at "{KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2].schedules[1].startTime}" from Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"
    And API MM - Operator verifies trips are generated for Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create New Crossdock Movement Schedule - Create with Multiple Drivers (uid:9267b27e-7a72-4c67-baf0-64d95018cc2a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    And API MM - Operator creates 2 new generated Middle Mile Drivers
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 20 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | all                                                                |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1],KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2] |
    When Operator click "ok" button on Add Movement Schedule dialog
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name} |
    And API MM - Operator gets Movement Schedule from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    And API MM - Operator gets the next 8 days of Movement Trips departed at "{KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2].schedules[1].startTime}" from Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"
    And API MM - Operator verifies trips are generated for Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create New Crossdock Movement Schedule - Create with 4 Drivers (uid:366d4221-9c99-4b4a-9f03-4ec479ee2345)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    And API MM - Operator creates 4 new generated Middle Mile Drivers
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 25 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | all                                                                |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS |
    When Operator click "ok" button on Add Movement Schedule dialog
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name} |
    And API MM - Operator gets Movement Schedule from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    And API MM - Operator gets the next 8 days of Movement Trips departed at "{KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2].schedules[1].startTime}" from Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"
    And API MM - Operator verifies trips are generated for Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create New Crossdock Movement Schedule - Create with > 4 Drivers (uid:97200116-acee-4a3b-a403-90e41b19c0b0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    And API MM - Operator creates 5 new generated Middle Mile Drivers
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 15 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | all                                                                |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS |
    When Operator click "ok" button on Add Movement Schedule dialog
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name} |
    And API MM - Operator gets Movement Schedule from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    And API MM - Operator gets the next 8 days of Movement Trips departed at "{KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2].schedules[1].startTime}" from Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"
    And API MM - Operator verifies trips are generated for Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create New Crossdock Movement Schedule - Create with Inactive License Status Driver (uid:b8e5456a-2a83-4606-913a-d19df430f306)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    And API MM - Operator creates 1 new generated Middle Mile Drivers
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 20 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | all                                                                |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
    When Operator click "ok" button on Add Movement Schedule dialog
    And Operator refresh page
    And Movement Management page is loaded
    Then Operator verifies "driver" with value "{inactive-driver-username}" is not shown on Crossdock page
    And Operator click "Cancel" button on Add Movement Schedule dialog
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name} |
    And API MM - Operator gets Movement Schedule from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    And API MM - Operator gets the next 8 days of Movement Trips departed at "{KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2].schedules[1].startTime}" from Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"
    And API MM - Operator verifies trips are generated for Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create New Crossdock Movement Schedule - Create with Inactive Employment Status Driver (uid:c803b569-759a-4ca9-89cb-c74be22c933d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    And API MM - Operator creates 1 new generated Middle Mile Drivers
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 25 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | all                                                                |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
    When Operator click "ok" button on Add Movement Schedule dialog
    And Operator refresh page
    And Movement Management page is loaded
    Then Operator verifies "driver" with value "{expired-driver-username}" is not shown on Crossdock page
    And Operator click "Cancel" button on Add Movement Schedule dialog
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name} |
    And API MM - Operator gets Movement Schedule from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    And API MM - Operator gets the next 8 days of Movement Trips departed at "{KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2].schedules[1].startTime}" from Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"
    And API MM - Operator verifies trips are generated for Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[2]"

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriverV2
  Scenario: Create New Crossdock Movement Schedule - Add Multiple Schedules with Single Driver (uid:58995063-2777-4d7c-8d00-7de3d45155ee)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:00                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:00                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].numberOfDrivers| 1                                                             |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
      | schedules[2].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[2].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[2].movementType   | Land Haul                                                     |
      | schedules[2].departureTime  | 17:00                                                         |
      | schedules[2].durationDays   | 2                                                             |
      | schedules[2].durationTime   | 18:00                                                         |
      | schedules[2].daysOfWeek     | monday,wednesday,friday                                       |
      | schedules[2].numberOfDrivers| 1                                                             |
      | schedules[2].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules and verifies on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriverV2
  Scenario: Create New Crossdock Movement Schedule - Add Multiple Schedules with Multiple Drivers (uid:58995063-2777-4d7c-8d00-7de3d45155ee)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:00                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:00                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].numberOfDrivers| 2                                                             |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
      | schedules[2].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[2].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[2].movementType   | Land Haul                                                     |
      | schedules[2].departureTime  | 17:00                                                         |
      | schedules[2].durationDays   | 2                                                             |
      | schedules[2].durationTime   | 18:00                                                         |
      | schedules[2].daysOfWeek     | monday,wednesday,friday                                       |
      | schedules[2].numberOfDrivers| 2                                                             |
      | schedules[2].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules and verifies on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriverV2
  Scenario: Create New Crossdock Movement Schedule - Add Multiple Schedules with 4 Drivers (uid:36f10f8f-ba71-4e25-bbe2-c4e9033430a8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator create 4 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:00                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:00                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].numberOfDrivers| 4                                                             |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
      | schedules[2].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[2].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[2].movementType   | Land Haul                                                     |
      | schedules[2].departureTime  | 17:00                                                         |
      | schedules[2].durationDays   | 2                                                             |
      | schedules[2].durationTime   | 18:00                                                         |
      | schedules[2].daysOfWeek     | monday,wednesday,friday                                       |
      | schedules[2].numberOfDrivers| 4                                                             |
      | schedules[2].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules and verifies on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriverV2
  Scenario: Create New Crossdock Movement Schedule - Add Multiple Schedules with >4 Drivers (uid:37166d72-193c-4f1b-97e9-4087efaeec3a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator create 5 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:00                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:00                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].numberOfDrivers| 5                                                             |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
      | schedules[2].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[2].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[2].movementType   | Land Haul                                                     |
      | schedules[2].departureTime  | 17:00                                                         |
      | schedules[2].durationDays   | 2                                                             |
      | schedules[2].durationTime   | 18:00                                                         |
      | schedules[2].daysOfWeek     | monday,wednesday,friday                                       |
      | schedules[2].numberOfDrivers| 5                                                             |
      | schedules[2].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules and verifies on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op



