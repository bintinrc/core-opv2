@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @CreateOneTimeTrip
Feature: Movement Trip - Create One Time Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create One Time Trip with Assign > 4 drivers (uid:97eca75b-a487-4879-8979-d5645c351438)
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
	Given API MM - Operator creates 5 new generated Middle Mile Drivers
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator create One Time Trip with drivers on Movement Trips page using data below:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}    |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}    |
	  | movementType   | Land Haul                                  |
	  | departureTime  | GENERATED                                  |
	  | duration       | GENERATED                                  |
	  | departureDate  | GENERATED                                  |
	  | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS |
	And Operator clicks Submit button on Create One Trip page
	Then Operator verifies toast message display on create one time trip page

  @HappyPath @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create One Time Trip with Assign Single Driver (uid:043eed30-91b2-4a88-83c2-6a0bd9629016)
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
	Given API MM - Operator creates 1 new generated Middle Mile Drivers
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator create One Time Trip with drivers on Movement Trips page using data below:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}       |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}       |
	  | movementType   | Land Haul                                     |
	  | departureTime  | GENERATED                                     |
	  | duration       | GENERATED                                     |
	  | departureDate  | GENERATED                                     |
	  | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
	And Operator clicks Submit button on Create One Trip page
	Then Operator verifies toast message display on create one time trip page

  @HappyPath @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create One Time Trip with Assign Multiple Drivers (uid:54ad5e4c-c2f0-48c5-8c19-3e2dd56dab73)
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
	Given API MM - Operator creates 2 new generated Middle Mile Drivers
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator create One Time Trip with drivers on Movement Trips page using data below:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}                                                     |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}                                                     |
	  | movementType   | Land Haul                                                                                   |
	  | departureTime  | GENERATED                                                                                   |
	  | duration       | GENERATED                                                                                   |
	  | departureDate  | GENERATED                                                                                   |
	  | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1],KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2] |
	And Operator clicks Submit button on Create One Trip page
	Then Operator verifies toast message display on create one time trip page

  @HappyPath @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create One Time Trip with same Origin and Destination Hub (uid:2669eafe-16bd-4417-993e-cfd71cff1fd6)
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
	Given API MM - Operator creates 1 new generated Middle Mile Drivers
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator create One Time Trip on Movement Trips page using same hub:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
	Then Operator verifies same hub error messages on Create One Time Trip page
	And Operator verifies Submit button is disable on Create One Trip page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create One Time Trip with Assign Expired License Driver (uid:6a9d8b70-64cd-406b-983b-b0b833263f68)
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
	Given API MM - Operator creates 1 new generated Middle Mile Drivers
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator create One Time Trip with drivers on Movement Trips page using data below:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}       |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}       |
	  | movementType   | Land Haul                                     |
	  | departureTime  | GENERATED                                     |
	  | duration       | GENERATED                                     |
	  | departureDate  | GENERATED                                     |
	  | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
	Then Operator verifies "driver" with value "{expired-driver-username}" is not shown on Create One Trip page
	Given Operator clicks Submit button on Create One Trip page
	Then Operator verifies toast message display on create one time trip page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create One Time Trip with Assign Expired Employment Driver (uid:d73a6e36-3c6b-4305-b170-47275b666bb9)
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
	Given API MM - Operator creates 1 new generated Middle Mile Drivers
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator create One Time Trip with drivers on Movement Trips page using data below:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}       |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}       |
	  | movementType   | Land Haul                                     |
	  | departureTime  | GENERATED                                     |
	  | duration       | GENERATED                                     |
	  | departureDate  | GENERATED                                     |
	  | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
	Then Operator verifies "driver" with value "{inactive-driver-username}" is not shown on Create One Trip page
	Given Operator clicks Submit button on Create One Trip page
	Then Operator verifies toast message display on create one time trip page

  @HappyPath @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create One Time Trip with disabled Origin Hub (uid:c5de607c-0e75-483f-a261-e2453b439d66)
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
	Given API MM - Operator creates 1 new generated Middle Mile Drivers
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator verifies "origin hub" with value "{hub-disable-name}" is not shown on Create One Trip page
	And Operator create One Time Trip with drivers on Movement Trips page using data below:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}       |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}       |
	  | movementType   | Land Haul                                     |
	  | departureTime  | GENERATED                                     |
	  | duration       | GENERATED                                     |
	  | departureDate  | GENERATED                                     |
	  | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
	Given Operator clicks Submit button on Create One Trip page
	Then Operator verifies toast message display on create one time trip page

  @HappyPath @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create One Time Trip with disabled Destination Hub (uid:c5de607c-0e75-483f-a261-e2453b439d66)
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
	Given API MM - Operator creates 1 new generated Middle Mile Drivers
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator verifies "destination hub" with value "{hub-disable-name}" is not shown on Create One Trip page
	And Operator create One Time Trip with drivers on Movement Trips page using data below:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}       |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}       |
	  | movementType   | Land Haul                                     |
	  | departureTime  | GENERATED                                     |
	  | duration       | GENERATED                                     |
	  | departureDate  | GENERATED                                     |
	  | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
	Given Operator clicks Submit button on Create One Trip page
	Then Operator verifies toast message display on create one time trip page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Create One Time Trip with Assign Active and Inactive Driver (uid:d25b8c2c-0d01-4a9b-b949-748ffb2ade11)
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
	Given API MM - Operator creates 1 new generated Middle Mile Drivers
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator create One Time Trip with drivers on Movement Trips page using data below:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}       |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}       |
	  | movementType   | Land Haul                                     |
	  | departureTime  | GENERATED                                     |
	  | duration       | GENERATED                                     |
	  | departureDate  | GENERATED                                     |
	  | drivers        | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
	Then Operator verifies "driver" with value "{inactive-driver-username}" is not shown on Create One Trip page
	Given Operator clicks Submit button on Create One Trip page
	Then Operator verifies toast message display on create one time trip page

  @HappyPath @DeleteCreatedHubs
  Scenario: Create One Time Trip without Assign Driver
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	And Operator clicks on Create One Time Trip Button
	And Operator verifies Create One Time Trip page is loaded
	And Operator create One Time Trip without driver on Movement Trips page using data below:
	  | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
	  | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name} |
	  | movementType   | Land Haul                               |
	  | departureTime  | GENERATED                               |
	  | duration       | GENERATED                               |
	  | departureDate  | GENERATED                               |
	And Operator clicks Submit button on Create One Trip page
	Then Operator verifies toast message display on create one time trip page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op