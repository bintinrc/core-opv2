@HappyPath @Hub @InterHub @MovementSchedules @CrossdockHubs
Feature: Crossdock Hubs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Crossdock Hub (uid:404c88ce-33e8-475b-b242-a6f1ef067c6d)
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
    When Movement Management page is loaded
    And Operator opens Add Movement Schedule modal on Movement Management page
    Then Operator can select "{KEY_LIST_OF_CREATED_HUBS[1].name}" crossdock hub when create crossdock movement schedule

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Crossdock Movement Schedule - Add schedule for new Crossdock Hub relation (uid:9343dc42-f3cf-499d-b647-f406b202dde3)
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
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Crossdock Movement Schedule - Add schedule for existing Crossdock Hub relation (uid:a61c229a-456f-4b74-9b3d-5b0a52c055aa)
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
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | schedules[1].movementType   | Land Haul                                                     |
      | schedules[1].departureTime  | 17:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 18:30                                                         |
      | schedules[1].daysOfWeek     | monday                                                        |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Crossdock Movement Schedule - Add multiple schedules (uid:3f4229ad-c97c-4136-8317-7655563424d4)
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
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: View Crossdock Movement Schedule (uid:48847e62-55ab-4d23-8123-65dddaa97c5d)
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
    And Operator load schedules on Movement Management page
    And Operator filters schedules list on Movement Management page using data below:
      | originHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify schedules list on Movement Management page using data below:
      | originHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    When Operator load schedules on Movement Management page
    And Operator filters schedules list on Movement Management page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify schedules list on Movement Management page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator filters schedules list on Movement Management page using data below:
      | originHub | WRONG_HUB_NAME |
    Then Operator verify schedules list is empty on Movement Management page
    When Operator load schedules on Movement Management page
    And Operator filters schedules list on Movement Management page using data below:
      | destinationHub | WRONG_HUB_NAME |
    Then Operator verify schedules list is empty on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Delete Crossdock Movement Schedule (uid:58702888-b2c4-4514-ba95-5192e7fc3eee)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator deletes created movement schedule on Movement Management page
    Then Operator verifies movement schedule deleted toast is shown on Movement Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op