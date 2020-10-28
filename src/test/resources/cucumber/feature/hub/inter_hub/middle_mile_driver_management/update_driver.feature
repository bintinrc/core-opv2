@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @UpdateDriver
Feature: Middle Mile Driver Management - Update Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Update Driver Details - Name (uid:c6c8e619-1437-4a8d-ab3e-954e9e1ad863)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose {gradle-next-0-day-yyyy-MM-dd}","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator selects the hub on the Middle Mile Drivers Page with value "{hub-name}"
    When Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    When Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "id" with value "{KEY_LIST_OF_CREATED_DRIVERS[1].id}"
    When Operator clicks edit button on the middle mile driver page
    And Operator edit "name" on edit driver dialog with value "{KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].id}"
    When Operator refresh page
    And Operator verifies middle mile driver management page is loaded
    When Operator selects the hub on the Middle Mile Drivers Page with value "{hub-name}"
    When Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    When Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "id" with value "{KEY_LIST_OF_CREATED_DRIVERS[1].id}"
    Then Operator verifies "name" is updated with value "{KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].id}"


  @DeleteDriver
  Scenario: Update Driver Details - Contact Number (uid:9ec5adc6-aa82-40d5-93a4-a593033154fb)
    Given no-op

  @DeleteDriver
  Scenario: Update Driver Details - Hub (uid:1892577e-d469-45dc-8ad5-48cbb0ddbf2a)
    Given no-op

  @DeleteDriver
  Scenario: Update Driver License - License Number (uid:869dea40-d9e0-4a59-82b0-59b1f503bca5)
    Given no-op

  @DeleteDriver
  Scenario: Update Driver License - Expiry Date (uid:def761b9-8aca-463d-ba5c-1641915a3477)
    Given no-op

  @DeleteDriver
  Scenario: Update Driver License - License Type (uid:213c5760-5212-4fd8-b0be-9806886da126)
    Given no-op

  @DeleteDriver
  Scenario: Update Employment Details - Employment Type (uid:feb6e6ab-4c9c-408d-975b-8c4301feea5a)
    Given no-op

  @DeleteDriver
  Scenario: Update Employment Details - Employment Start Date (uid:51d4a35e-8453-4c9a-9b35-3f16638b22e8)
    Given no-op

  @DeleteDriver
  Scenario: Update Employment Details - Employment End Date (uid:e2b5d826-6669-46f0-8a08-b8e00dd6c51f)
    Given no-op

  @DeleteDriver
  Scenario: Update Driver Availability - From Yes to No (uid:bb0ba3dc-dd22-4a49-bb8f-819051ba5a44)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
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
    And Operator verifies middle mile driver management page is loaded
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
    And Operator verifies middle mile driver management page is loaded
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
    And Operator verifies middle mile driver management page is loaded
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