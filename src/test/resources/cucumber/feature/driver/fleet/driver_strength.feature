@OperatorV2 @Driver @Fleet @DriverStrengthV2 @RunThis
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
    And Operator load all data for driver on Driver Strength Page
    Then Operator verify driver strength params of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Update Driver Account (uid:6ddb814e-8b32-4097-9a5f-0900d0d8a3ca)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    When Operator edit created Driver on Driver Strength page using data below:
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 200                                                              |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 200                                                              |
      | contact              | GENERATED                                                        |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 2                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 2                                                                |
      | password             | GENERATED                                                        |
      | comments             | This driver is UPDATED by "Automation Test" for testing purpose. |
    Then Operator verifies that success react notification displayed:
      | top                | Driver Updated                 |
      | bottom             | Driver {KEY_CREATED_DRIVER_ID} |
      | waitUntilInvisible | true                           |
    And Operator filter driver strength using data below:
      | zones       | {zone-name-2}      |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    And Operator verify driver strength params of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Create New Driver Account and Verify Contact Detail is Correct (uid:fadb6a2a-6f2a-4c6f-94a9-e9f41c8795cc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    When API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    And Operator load all data for driver on Driver Strength Page
    Then Operator verify contact details of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Delete Driver Account (uid:4cdc0535-7095-463e-87da-ea108e500644)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator delete created driver on Driver Strength page
    Then Operator verify new driver is deleted successfully on Driver Strength page

  @DeleteDriver
  Scenario: Operator Should Be Able to Change The 'Coming' Value (uid:32abe41c-49be-4d54-8f11-3891bcd81afb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator change Coming value for created driver on Driver Strength page
    Then Operator verify Coming value for created driver has been changed on Driver Strength page

  @DeleteDriver
  Scenario: Filter Driver Account by Zones (uid:fa20ebea-5a9c-43bb-88ad-a93aa94ef18f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And  Operator filter driver strength using data below:
      | zones | {zone-name} |
    Then Operator verify driver strength is filtered by "{zone-name}" zone

  @DeleteDriver
  Scenario: Filter Driver Account by Driver Types (uid:74653b45-cba6-464b-a874-e9ddbc9759bb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | driverTypes | {driver-type-name} |
    Then Operator verify driver strength is filtered by "{driver-type-name}" driver type

  @DeleteDriver
  Scenario: Filter Driver Account by Resigned - Yes (uid:aa65bb50-5bd7-44e7-87cd-8621953e95f6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","employmentEndDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | resigned | Yes |
    Then Operator verify driver strength is filtered by "Yes" resigned

  @DeleteDriver
  Scenario: Filter Driver Account by Resigned - No (uid:d587886b-6721-4b48-9e5d-749a0d0eed22)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | resigned | No |
    Then Operator verify driver strength is filtered by "No" resigned

  @DeleteDriver
  Scenario: Filter Driver Account by Driver Zones, Driver Types, and Resigned - Yes (uid:dd1e88b6-ecd4-410c-a1f4-0d7cf468f3cd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","employmentEndDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | Yes                |
    Then Operator verify driver strength is filtered by "{zone-name}" zone
    Then Operator verify driver strength is filtered by "{driver-type-name}" driver type
    #To be unlocked when slide/horizontal scroll action is solved on react page
    #Then Operator verify driver strength is filtered by "Yes" resigned

  @DeleteDriver
  Scenario: Filter Driver Account by Driver Types, Zones, and Resigned - No (uid:3227cea9-887f-47df-b403-de16558eaf68)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    Then Operator verify driver strength is filtered by "{zone-name}" zone
    Then Operator verify driver strength is filtered by "{driver-type-name}" driver type
    #To be unlocked when slide/horizontal scroll action is solved on react page
    #Then Operator verify driver strength is filtered by "No" resigned

  @DeleteDriver
  Scenario: Filter Driver Account by Edit Search Filter after Load Driver without using Search Filter first (uid:1083c42d-5fcb-4e08-a838-0072a7e1e36f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{{{DRIVER_CONTACT_DETAIL}}}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator load all data for driver on Driver Strength Page
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    Then Operator verify driver strength is filtered by "{zone-name}" zone
    Then Operator verify driver strength is filtered by "{driver-type-name}" driver type
    #To be unlocked when slide/horizontal scroll action is solved on react page
    #Then Operator verify driver strength is filtered by "No" resigned

  @DeleteDriver
  Scenario: Filter Driver Account by Edit Search Filter after Load Driver with using Search Filter first (uid:481ba3a2-07a5-4156-ae14-8bae483d0773)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | zones       | {zone-name-2}        |
      | driverTypes | {driver-type-name-2} |
      | resigned    | Yes                  |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    Then Operator verify driver strength is filtered by "{zone-name}" zone
    Then Operator verify driver strength is filtered by "{driver-type-name}" driver type
    Then Operator verify driver strength is filtered by "No" resigned

  Scenario: Can Not Create New Driver Account Without Active Contact (uid:30bcd5fd-376f-45be-bbf5-2e420a760f2c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Add Driver dialog on Driver Strength
    And Operator fill Add Driver form on Driver Strength page using data below:
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 100                                                              |
      | hub                  | {hub-name}                                                       |
      | employmentStartDate  | {gradle-current-date-yyyy-MM-dd}                                 |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 100                                                              |
      | zoneId               | {zone-name}                                                      |
      | zoneMin              | 1                                                                |
      | zoneMax              | 1                                                                |
      | zoneCost             | 1                                                                |
      | username             | GENERATED                                                        |
      | password             | GENERATED                                                        |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    And Operator click Submit button in Add Driver dialog
    And Operator verifies hint "At least one contact required." is displayed in Add Driver dialog

  Scenario: Can Not Create New Driver Account Without Active Vehicle (uid:faf2e60a-730e-4d7a-b67e-7a17fba22f6e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Add Driver dialog on Driver Strength
    And Operator fill Add Driver form on Driver Strength page using data below:
      | firstName           | GENERATED                                                        |
      | lastName            | GENERATED                                                        |
      | licenseNumber       | GENERATED                                                        |
      | codLimit            | 100                                                              |
      | hub                 | {hub-name}                                                       |
      | employmentStartDate | {gradle-current-date-yyyy-MM-dd}                                 |
      | contactType         | {contact-type-name}                                              |
      | contact             | GENERATED                                                        |
      | zoneId              | {zone-name}                                                      |
      | zoneMin             | 1                                                                |
      | zoneMax             | 1                                                                |
      | zoneCost            | 1                                                                |
      | username            | GENERATED                                                        |
      | password            | GENERATED                                                        |
      | comments            | This driver is created by "Automation Test" for testing purpose. |
    Then Operator click Submit button in Add Driver dialog
    And Operator verifies hint "At least one vehicle required." is displayed in Add Driver dialog

  Scenario: Can Not Create New Driver Account Without Preferred Zone and Capacity (uid:a7f36604-0398-4d3d-ab5f-b4fb554bb8a7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Add Driver dialog on Driver Strength
    And Operator fill Add Driver form on Driver Strength page using data below:
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
      | username             | GENERATED                                                        |
      | password             | GENERATED                                                        |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    Then Operator click Submit button in Add Driver dialog
    And Operator verifies hint "At least one preferred zone required." is displayed in Add Driver dialog

  @DeleteDriver
  Scenario: Can Not Update Driver Account Without Active Contact (uid:d2db97f9-190d-4b03-8bb5-249fd1bf60c5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Edit Driver dialog for created driver on Driver Strength page
    And  Operator removes contact details on Edit Driver dialog on Driver Strength page
    Then Operator verifies Submit button in Add Driver dialog is disabled
    And Operator verifies hint "At least one contact required." is displayed in Add Driver dialog

  @DeleteDriver
  Scenario: Can Not Update Driver Account Without Active Vehicle (uid:9d7f097d-2f46-4fda-b171-9c90723b8b57)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Edit Driver dialog for created driver on Driver Strength page
    And  Operator removes vehicle details on Edit Driver dialog on Driver Strength page
    Then Operator verifies Submit button in Add Driver dialog is disabled
    And Operator verifies hint "At least one vehicle required." is displayed in Add Driver dialog

  @DeleteDriver
  Scenario: Can Not Update Driver Account Without Preferred Zone and Capacity (uid:113be9c8-1f19-4765-a94e-b98a2fb25c0f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"{{DRIVER_CONTACT_DETAIL}}"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Edit Driver dialog for created driver on Driver Strength page
    And  Operator removes zone preferences on Edit Driver dialog on Driver Strength page
    Then Operator verifies Submit button in Add Driver dialog is disabled
    And Operator verifies hint "At least one preferred zone requireduired." is displayed in Add Driver dialog

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
