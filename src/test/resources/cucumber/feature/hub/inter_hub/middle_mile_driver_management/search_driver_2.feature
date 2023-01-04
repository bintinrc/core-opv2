@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @SearchDriver2
Feature: Middle Mile Driver Management - Search Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Load Driver by Filter - Employment Status Inactive and License Status Active(uid:74fe1b41-427f-4d03-b263-bf4024b3df50)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-current-date-yyyy-MM-dd}"}} |
    And API Operator deactivate "employment status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=inactive&licenseStatus=active |
      | Employment Status | Inactive                                                                                                  |
      | License Status    | Active                                                                                                    |

  @DeleteDriver
  Scenario: Load Driver by Filter - Employment Status Active and License Status Inactive(uid:8fe481c5-13db-4dc6-be5b-9a7c67cc6c93)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-current-date-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator deactivate "license status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&licenseStatus=inactive |
      | Employment Status | Active                                                                                                    |
      | License Status    | Inactive                                                                                                  |

  @DeleteDriver
  Scenario: Load Driver by Filter - Hub, Employment Status Inactive and License Status Inactive (uid:e1d54146-6e85-4b1b-884e-e7f1f9a89070)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator get info of hub details id "{hub-id}"
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-0-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-0-day-yyyy-MM-dd}"}} |
    And API Driver get all middle mile driver using hub filter with value "{hub-id}"
    And API Operator deactivate "license status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Operator deactivate "employment status" for driver "{KEY_CREATED_DRIVER_ID}"
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=inactive&hubIds=<id>&licenseStatus=inactive |
      | Hub               | {KEY_HUB_INFO.name}                                                                                                     |
      | Employment Status | Inactive                                                                                                                |
      | License Status    | Inactive                                                                                                                |

  @DeleteDriver
  Scenario: Search Driver on Search Field Name (uid:f1863d5a-2151-4430-98e0-228cbfbd9853)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "NAME_FILTER" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field ID (uid:dcebd212-12c5-42e6-82fb-76e894f36d73)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "ID_FILTER" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Username (uid:5975fcb7-c611-4aa3-9e01-5af1d3ea036b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "USERNAME_FILTER" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Hub (uid:e2590d24-9767-4daf-b9e7-148929184731)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "HUB_FILTER" and verifies the created username

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op