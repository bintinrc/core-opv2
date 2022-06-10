@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @CreateOneTimeTrip
Feature: Movement Trip - Create One Time Trip

  @LaunchBrowser @ShouldAlwaysRun @runthis
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver @CancelTrip
  Scenario: Create One Time Trip with Assign > 4 drivers (uid:97eca75b-a487-4879-8979-d5645c351438)
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
    Given API Operator create 5 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator create One Time Trip on Movement Trips page using data below:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[2].name}          |
      | movementType      | Land Haul                                   |
      | departureTime     | GENERATED                                   |
      | duration          | GENERATED                                   |
      | departureDate     | GENERATED                                   |
      | assignDrivers     | 5                                           |
    And Operator clicks Submit button on Create One Trip page
    Then Operator verifies toast message display on create one time trip page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver @CancelTrip
  Scenario: Create One Time Trip with Assign Single Driver (uid:043eed30-91b2-4a88-83c2-6a0bd9629016)
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
    Given API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator create One Time Trip on Movement Trips page using data below:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[2].name}          |
      | movementType      | Land Haul                                   |
      | departureTime     | GENERATED                                   |
      | duration          | GENERATED                                   |
      | departureDate     | GENERATED                                   |
      | assignDrivers     | 1                                           |
    And Operator clicks Submit button on Create One Trip page
    Then Operator verifies toast message display on create one time trip page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver @CancelTrip
  Scenario: Create One Time Trip with Assign Multiple Drivers (uid:54ad5e4c-c2f0-48c5-8c19-3e2dd56dab73)
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
    Given API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator create One Time Trip on Movement Trips page using data below:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[2].name}          |
      | movementType      | Land Haul                                   |
      | departureTime     | GENERATED                                   |
      | duration          | GENERATED                                   |
      | departureDate     | GENERATED                                   |
      | assignDrivers     | 2                                           |
    And Operator clicks Submit button on Create One Trip page
    Then Operator verifies toast message display on create one time trip page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Create One Time Trip with same Origin and Destination Hub (uid:2669eafe-16bd-4417-993e-cfd71cff1fd6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 1 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator create One Time Trip on Movement Trips page using same hub:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
    Then Operator verifies same hub error messages on Create One Time Trip page
    And Operator verifies Submit button is disable on Create One Trip page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver @CancelTrip
  Scenario: Create One Time Trip with Assign Expired License Driver (uid:6a9d8b70-64cd-406b-983b-b0b833263f68)
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
    Given API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator create One Time Trip on Movement Trips page using data below:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[2].name}          |
      | movementType      | Land Haul                                   |
      | departureTime     | GENERATED                                   |
      | duration          | GENERATED                                   |
      | departureDate     | GENERATED                                   |
      | assignDrivers     | 1                                           |
    Then Operator verifies "driver" with value "{expired-driver-username}" is not shown on Create One Trip page
    Given Operator clicks Submit button on Create One Trip page
    Then Operator verifies toast message display on create one time trip page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver @CancelTrip
  Scenario: Create One Time Trip with Assign Expired Employment Driver (uid:d73a6e36-3c6b-4305-b170-47275b666bb9)
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
    Given API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator create One Time Trip on Movement Trips page using data below:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[2].name}          |
      | movementType      | Land Haul                                   |
      | departureTime     | GENERATED                                   |
      | duration          | GENERATED                                   |
      | departureDate     | GENERATED                                   |
      | assignDrivers     | 1                                           |
    Then Operator verifies "driver" with value "{inactive-driver-username}" is not shown on Create One Trip page
    Given Operator clicks Submit button on Create One Trip page
    Then Operator verifies toast message display on create one time trip page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver @CancelTrip
  Scenario: Create One Time Trip with disabled Origin Hub (uid:c5de607c-0e75-483f-a261-e2453b439d66)
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
    Given API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator verifies "origin hub" with value "{hub-disable-name}" is not shown on Create One Trip page
    And Operator create One Time Trip on Movement Trips page using data below:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[2].name}          |
      | movementType      | Land Haul                                   |
      | departureTime     | GENERATED                                   |
      | duration          | GENERATED                                   |
      | departureDate     | GENERATED                                   |
      | assignDrivers     | 1                                           |
    Given Operator clicks Submit button on Create One Trip page
    Then Operator verifies toast message display on create one time trip page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver @CancelTrip
  Scenario: Create One Time Trip with disabled Destination Hub (uid:c5de607c-0e75-483f-a261-e2453b439d66)
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
    Given API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator verifies "destination hub" with value "{hub-disable-name}" is not shown on Create One Trip page
    And Operator create One Time Trip on Movement Trips page using data below:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[2].name}          |
      | movementType      | Land Haul                                   |
      | departureTime     | GENERATED                                   |
      | duration          | GENERATED                                   |
      | departureDate     | GENERATED                                   |
      | assignDrivers     | 1                                           |
    Given Operator clicks Submit button on Create One Trip page
    Then Operator verifies toast message display on create one time trip page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver @CancelTrip
  Scenario: Create One Time Trip with Assign Active and Inactive Driver (uid:d25b8c2c-0d01-4a9b-b949-748ffb2ade11)
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
    Given API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator create One Time Trip on Movement Trips page using data below:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[2].name}          |
      | movementType      | Land Haul                                   |
      | departureTime     | GENERATED                                   |
      | duration          | GENERATED                                   |
      | departureDate     | GENERATED                                   |
      | assignDrivers     | 1                                           |
    Then Operator verifies "driver" with value "{inactive-driver-username}" is not shown on Create One Trip page
    Given Operator clicks Submit button on Create One Trip page
    Then Operator verifies toast message display on create one time trip page

  @DeleteHubsViaAPI @DeleteHubsViaDb @CancelTrip @runthis
  Scenario: Create One Time Trip without Assign Driver
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
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator clicks on Create One Time Trip Button
    And Operator verifies Create One Time Trip page is loaded
    And Operator create One Time Trip without driver on Movement Trips page using data below:
      | originHub         | {KEY_LIST_OF_CREATED_HUBS[1].name}          |
      | destinationHub    | {KEY_LIST_OF_CREATED_HUBS[2].name}          |
      | movementType      | Land Haul                                   |
      | departureTime     | GENERATED                                   |
      | duration          | GENERATED                                   |
      | departureDate     | GENERATED                                   |
    And Operator clicks Submit button on Create One Trip page
    Then Operator verifies toast message display on create one time trip page

  @KillBrowser @ShouldAlwaysRun @runthis
  Scenario: Kill Browser
    Given no-op