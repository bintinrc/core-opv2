@OperatorV2 @Driver @Fleet  @DriverStrengthV2
Feature: Driver Strength

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Create New Driver Account (uid:7b2078bd-589f-4c9a-a06e-156098e34cf2)
    Given Operator go to menu Fleet -> Driver Strength
    When Operator create new Driver on Driver Strength page using data below:
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 100                                                              |
      | hub                  | {hub-name}                                                       |
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
  Scenario: Update Driver Account (uid:6ddb814e-8b32-4097-9a5f-0900d0d8a3ca)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
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
  Scenario: Create New Driver Account and Verify Contact Detail is Correct (uid:fadb6a2a-6f2a-4c6f-94a9-e9f41c8795cc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    When API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    Then Operator verify contact details of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Delete Driver Account (uid:4cdc0535-7095-463e-87da-ea108e500644)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator delete created driver on Driver Strength page
    Then Operator verify new driver is deleted successfully on Driver Strength page

  @DeleteDriver
  Scenario: Operator Should Be Able to Change The 'Coming' Value (uid:32abe41c-49be-4d54-8f11-3891bcd81afb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator change Coming value for created driver on Driver Strength page
    Then Operator verify Coming value for created driver has been changed on Driver Strength page

  @DeleteDriver
  Scenario: Filter Driver Account by Zones (uid:fa20ebea-5a9c-43bb-88ad-a93aa94ef18f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator filter driver strength by "{zone-name}" zone
    Then Operator verify driver strength is filtered by "{zone-name}" zone

  @DeleteDriver
  Scenario: Filter Driver Account by Driver Types (uid:74653b45-cba6-464b-a874-e9ddbc9759bb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator filter driver strength by "{driver-type-name}" driver type
    Then Operator verify driver strength is filtered by "{driver-type-name}" driver type

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op