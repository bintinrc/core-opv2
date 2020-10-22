@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @UpdateDriver
Feature: Middle Mile Driver Management - Update Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Update Driver Availability - From Yes to No (uid:bb0ba3dc-dd22-4a49-bb8f-819051ba5a44)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose {gradle-next-0-day-yyyy-MM-dd}","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator clicks "No" button on the middle mile driver page
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same

  @DeleteDriver
  Scenario: Update Driver Availability - From No to Yes (uid:21cf2a39-50c0-440d-9ce3-7b8181b02958)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose {gradle-next-0-day-yyyy-MM-dd}","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator clicks "No" button on the middle mile driver page
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same
    Given API Driver gets all the driver
    When Operator clicks "Yes" button on the middle mile driver page
    Given API Driver gets all the driver
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same

  @DeleteDriver
  Scenario: Bulk Update Driver Availability - Set All to Coming (uid:c71410a2-90eb-4343-85fb-5e1878c0da7a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator sets all selected middle mile driver to "Yes"
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same

  @DeleteDriver
  Scenario: Bulk Update Driver Availability - Set All to Not Coming (uid:dff6c846-bb9d-4897-b2b9-40fc7254b157)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator sets all selected middle mile driver to "Yes"
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same
    Given API Driver gets all the driver
    When Operator sets all selected middle mile driver to "No"
    Given API Driver gets all the driver
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op