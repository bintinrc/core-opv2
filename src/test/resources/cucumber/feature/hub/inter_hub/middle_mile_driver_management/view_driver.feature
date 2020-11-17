@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @ViewDriver
Feature: Middle Mile Driver Management - View Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: View Driver (uid:23112b2d-8f62-4c9d-a354-ff51da408b8f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose {gradle-next-0-day-yyyy-MM-dd}","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator clicks view button on the middle mile driver page
    Then Operator verifies that the details of the middle mile driver is true

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op