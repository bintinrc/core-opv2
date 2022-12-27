@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @SearchDriver3
Feature: Middle Mile Driver Management - Search Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Search Driver on Search Field Employment Type (uid:29cddc59-7ceb-4ccf-a850-581a6ed69ad3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "employment type" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Employment Status (uid:edcf5cdb-1fd4-4b5f-9da4-2809758e28ca)
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "employment status" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field License Type (uid:2d12f8e0-a6e2-4738-8c70-f9118823ee78)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "license type" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field License Status (uid:3b4d5a2a-2838-46d0-a522-678ab24917e6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "license status" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Comment (uid:813a82e7-0ce2-4206-b269-646dc2cc76bd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose {gradle-next-0-day-yyyy-MM-dd}","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator refresh drivers data
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "comments" and verifies the created username

  Scenario Outline: Sort Driver on Name column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "Name" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Name"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on ID column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "ID" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "ID"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op