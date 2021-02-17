@OperatorV2 @HappyPath @Hub @InterHub @MiddleMileDrivers @UpdateDriver
Feature: Middle Mile Driver Management - Update Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Update Driver Details - Contact Number (uid:d7cb2360-8d10-4270-836d-826aa7551f21)
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
    And Operator edit "contactNumber" on edit driver dialog with value "52568567180"
    Then DB Operator verifies driver "contactNumber" with username "{KEY_LIST_OF_CREATED_DRIVERS[1].username}" and value "52568567180" is updated

  @DeleteDriver
  Scenario: Update Driver Details - Hub (uid:58f3e310-5a91-4352-adfe-40225aed35d7)
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
    And Operator edit "hub" on edit driver dialog with value "{hub-name-2}"
    Then DB Operator verifies driver "hub" with username "{KEY_LIST_OF_CREATED_DRIVERS[1].username}" and value "{hub-id-2}" is updated

  @DeleteDriver
  Scenario: Update Driver License - Expiry Date (uid:fea77ac3-f5f0-4f4a-873a-29183c637371)
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
    And Operator edit "licenseExpiryDate" on edit driver dialog with value "{gradle-next-3-day-yyyy-MM-dd}"
    Then DB Operator verifies driver "licenseExpiryDate" with username "{KEY_LIST_OF_CREATED_DRIVERS[1].username}" and value "{gradle-next-3-day-yyyy-MM-dd}" is updated

  @DeleteDriver
  Scenario: Update Employment Details - Employment Type (uid:5cb4be10-8ff6-4d77-966f-a2d7d84562e8)
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
    And Operator edit "employmentType" on edit driver dialog with value "Vendor"
    Then DB Operator verifies driver "employmentType" with username "{KEY_LIST_OF_CREATED_DRIVERS[1].username}" and value "Vendor" is updated

  @DeleteDriver
  Scenario: Update Employment Details - Employment End Date (uid:faaba5ad-ef68-4551-955f-29688893c8a6)
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
    And Operator edit "employmentEndDate" on edit driver dialog with value "{gradle-next-3-day-yyyy-MM-dd}"
    Then DB Operator verifies driver "employmentEndDate" with username "{KEY_LIST_OF_CREATED_DRIVERS[1].username}" and value "{gradle-next-3-day-yyyy-MM-dd}" is updated

  @DeleteDriver
  Scenario: Update Driver Availability - From No to Yes (uid:cf05dd18-6e41-4d9f-8b6d-c0ec5575ca32)
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
  Scenario: Update Driver Availability - From Yes to No (uid:353c5748-066c-434d-b62c-ad71d5b8871f)
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
  Scenario: Bulk Update Driver Availability - Set All to Coming (uid:d38e8010-252c-4581-bac5-16a4068ba393)
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op