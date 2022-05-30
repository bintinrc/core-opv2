@MiddleMile @Hub @InterHub @MovementSchedules @CrossdockHubs2
Feature: Crossdock Hubs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Crossdock Movement Schedule - Add multiple schedule with existing schedules data (uid:a3d80ad7-e554-495e-aa7d-e3c6da95449e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator opens Add Movement Schedule modal on Movement Management page
    And Operator fill Add Movement Schedule form using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
      | schedules[2].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[2].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[2].movementType   | Land Haul                                                      |
      | schedules[2].departureTime  | 15:15                                                         |
      | schedules[2].durationDays   | 1                                                             |
      | schedules[2].durationTime   | 16:30                                                         |
      | schedules[2].daysOfWeek     | all                                                           |
      | schedules[2].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator click "Create" button on Add Movement Schedule dialog
    Then Operator verify "Schedule already exists" error Message is displayed in Add Crossdock Movement Schedule dialog

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Crossdock Movement Schedule - Add multiple schedules (uid:9f15a576-6e91-4a5d-82c2-748de2a910eb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
      | schedules[2].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[2].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[2].movementType   | Land Haul                                                     |
      | schedules[2].departureTime  | 17:15                                                         |
      | schedules[2].durationDays   | 2                                                             |
      | schedules[2].durationTime   | 18:30                                                         |
      | schedules[2].daysOfWeek     | monday,wednesday,friday                                       |
      | schedules[2].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules and verifies on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Crossdock Movement Schedule - Merged into Same Wave (uid:168af889-e0a1-44ca-948f-4a1799f4c9b0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | tuesday,thursday                                              |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
      | schedules[2].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[2].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[2].movementType   | Land Haul                                                     |
      | schedules[2].departureTime  | 17:15                                                         |
      | schedules[2].durationDays   | 2                                                             |
      | schedules[2].durationTime   | 18:30                                                         |
      | schedules[2].daysOfWeek     | monday,wednesday,friday                                       |
      | schedules[2].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create Crossdock Movement Schedule - Same Wave - Search by Origin Hub (uid:734e4fb3-17a6-46a8-a3b9-bc82d397520c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | tuesday,thursday                                              |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
      | schedules[2].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[2].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[2].movementType   | Land Haul                                                     |
      | schedules[2].departureTime  | 17:15                                                         |
      | schedules[2].durationDays   | 2                                                             |
      | schedules[2].durationTime   | 18:30                                                         |
      | schedules[2].daysOfWeek     | monday,wednesday,friday                                       |
      | schedules[2].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create Crossdock Movement Schedule - Same Wave - Search by Destination Hub (uid:7f8e8674-beee-4e23-815e-573465a05cf1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                      |
      | schedules[1].departureTime  | 15:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | tuesday,thursday                                              |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
      | schedules[2].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[2].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[2].movementType   | Land Haul                                                     |
      | schedules[2].departureTime  | 17:15                                                         |
      | schedules[2].durationDays   | 2                                                             |
      | schedules[2].durationTime   | 18:30                                                         |
      | schedules[2].daysOfWeek     | monday,wednesday,friday                                       |
      | schedules[2].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies a new schedule is created on Movement Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op



