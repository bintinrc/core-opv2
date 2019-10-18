@OperatorV2 @OperatorV2Part2 @DriverStrengthV2 @Saas
Feature: Driver Strength

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Operator should be able to add a new Driver (uid:70921910-cb0a-4283-93ad-34431fd86b98)
    Given Operator go to menu Fleet -> Driver Strength
    When Operator create new Driver on Driver Strength page using data below:
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 100                                                              |
      | employmentStartDate  | {gradle-current-date-yyyy-MM-dd}                                 |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 100                                                              |
      | contactType          | {contact-type-name}                                              |
      | contact              | GENERATED                                                        |
      | zoneId               | {zone-name}                                                      |
      | zoneMin              | 1                                                                |
      | zoneMax              | 1                                                                |
      | zoneCost             | 1                                                                |
      | username             | GENERATED                                                        |
      | password             | GENERATED                                                        |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    And DB Operator get data of created driver
    Then Operator verify driver strength params of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to edit new Driver (uid:3f54984e-aaa1-494c-a27b-68af2d809071)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator edit created Driver on Driver Strength page using data below:
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 200                                                              |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 200                                                              |
      | contact              | GENERATED                                                        |
      | zoneId               | {zone-name}                                                      |
      | zoneMin              | 2                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 2                                                                |
      | password             | GENERATED                                                        |
      | comments             | This driver is UPDATED by "Automation Test" for testing purpose. |
    Then Operator verify driver strength params of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to add a new Driver and verify the 'Contact Details' is correct (uid:b7a6c2b2-66c0-4e7d-890c-b0099cef4b5a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    When API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    Then Operator verify contact details of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to delete a Driver (uid:9e1d4874-d927-438a-abdf-8cde0308f35b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator delete created driver on Driver Strength page
    Then Operator verify new driver is deleted successfully on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to change the 'Coming' value (uid:bd210076-fd96-4d1a-8277-ec119286680c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator change Coming value for created driver on Driver Strength page
    Then Operator verify Coming value for created driver has been changed on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to filter Driver by 'Zones' (uid:830216ec-bc25-4921-8950-40e6bd8818af)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator filter driver strength by "{zone-name}" zone
    Then Operator verify driver strength is filtered by "{zone-name}" zone

  @DeleteDriver
  Scenario: Operator should be able to filter Driver by 'Driver Types' (uid:204f21ef-8b0c-4b74-a6e0-c191199d3f5a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator filter driver strength by "{driver-type-name}" driver type
    Then Operator verify driver strength is filtered by "{driver-type-name}" driver type

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
