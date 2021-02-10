@OperatorV2 @HappyPath @Hub @InterHub @MiddleMileDrivers @SearchDriver
Feature: Middle Mile Driver Management - Search Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Load All Drivers (uid:fa3e21f0-971c-4462-bbd9-f41afab8b7ce)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Driver gets all the driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given API Driver get all middle mile driver
    When Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator verifies that the data shown has the same value

  @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb 
  Scenario: Load Driver by Filter - Hub (uid:4ac4ea89-688a-4d62-9192-6f59dc8d292c)
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{KEY_CREATED_HUB.id},"hub":"{KEY_CREATED_HUB.name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details string id "{KEY_CREATED_HUB.id}"
    Given API Driver get all middle mile driver using hub filter with value "{KEY_CREATED_HUB.id}"
    When Operator selects the hub on the Middle Mile Drivers Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator verifies that the data shown has the same value

  @DeleteDriver
  Scenario: Search Driver on Search Field Name (uid:4bb863bc-52fe-4880-a2ac-5891dbe108e6)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field ID (uid:6a4af29f-1e7c-41ed-a1f6-8257ef10a5fd)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "id" and verifies the created username

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op