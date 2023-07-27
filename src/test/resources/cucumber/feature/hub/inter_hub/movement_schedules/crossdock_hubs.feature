@MiddleMile @Hub @InterHub @MovementSchedules @CrossdockHubs
Feature: Crossdock Hubs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Crossdock Hub (uid:c25c8b85-445d-4caa-a737-bd26c75a9a40)
	When API Operator creates new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | CROSSDOCK |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	When Operator go to menu Inter-Hub -> Movement Schedules
	When Movement Management page is loaded
	And Operator opens Add Movement Schedule modal on Movement Management page
	Then Operator can select "{KEY_LIST_OF_CREATED_HUBS[1].name}" crossdock hub when create crossdock movement schedule

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Create New Crossdock Movement Schedule - Add schedule for new Crossdock Hub relation (uid:a339c376-b12f-4a18-a553-ce776576083d)
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
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	And Operator adds new Movement Schedule on Movement Management page using data below:
	  | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
	  | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
	  | schedules[1].movementType   | Land Haul                                                     |
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
  Scenario: Create New Crossdock Movement Schedule - Add schedule for existing Crossdock Hub relation (uid:c774d293-0a5b-47d5-a961-854231d0ec40)
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
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	And Operator adds new Movement Schedule on Movement Management page using data below:
	  | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
	  | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
	  | schedules[1].movementType   | Land Haul                                                     |
	  | schedules[1].departureTime  | 15:15                                                         |
	  | schedules[1].durationDays   | 1                                                             |
	  | schedules[1].durationTime   | 16:30                                                         |
	  | schedules[1].daysOfWeek     | all                                                           |
	  | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
	And Operator load schedules and verifies on Movement Management page with retry using data below:
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
	And Operator load schedules and verifies on Movement Management page with retry using data below:
	  | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	Then Operator verifies a new schedule is created on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Cancel Create New Crossdock Movement Schedule (uid:5c65e255-6ea6-4049-99ba-f1e1d92b33c6)
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
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	And Operator opens Add Movement Schedule modal on Movement Management page
	And Operator fill Add Movement Schedule form using data below:
	  | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
	  | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
	  | schedules[1].movementType   | Land Haul                                                     |
	  | schedules[1].departureTime  | 15:15                                                         |
	  | schedules[1].durationDays   | 1                                                             |
	  | schedules[1].durationTime   | 16:30                                                         |
	  | schedules[1].daysOfWeek     | all                                                           |
	  | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
	And Operator click "Cancel" button on Add Movement Schedule dialog
	Then Operator verifies Add Movement Schedule dialog is closed on Movement Management page
	And Operator opens Add Movement Schedule modal on Movement Management page
	Then Operator verify Add Movement Schedule form is empty

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: View Crossdock Movement Schedule (uid:56b4708c-607e-40fd-8e20-5b0fa7caf652)
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
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	And Operator adds new Movement Schedule on Movement Management page using data below:
	  | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
	  | schedules[1].destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
	  | schedules[1].movementType   | Land Haul                                                     |
	  | schedules[1].departureTime  | 15:15                                                         |
	  | schedules[1].durationDays   | 1                                                             |
	  | schedules[1].durationTime   | 16:30                                                         |
	  | schedules[1].daysOfWeek     | all                                                           |
	  | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
	And Operator load schedules and verifies on Movement Management page with retry using data below:
	  | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	Then Operator verifies a new schedule is created on Movement Management page
	And Operator filters schedules list on Movement Management page using data below:
	  | originHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	Then Operator verify schedules list on Movement Management page using data below:
	  | originHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	And Operator load schedules and verifies on Movement Management page with retry using data below:
	  | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	And Operator filters schedules list on Movement Management page using data below:
	  | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	Then Operator verify schedules list on Movement Management page using data below:
	  | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	And Operator filters schedules list on Movement Management page using data below:
	  | originHub | WRONG_HUB_NAME |
	Then Operator verify schedules list is empty on Movement Management page
	And Operator load schedules and verifies on Movement Management page with retry using data below:
	  | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	And Operator filters schedules list on Movement Management page using data below:
	  | destinationHub | WRONG_HUB_NAME |
	Then Operator verify schedules list is empty on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Delete Crossdock Movement Schedule (uid:6cc194d0-758b-4991-9caa-b22008e1a216)
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
	Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
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
