@OperatorV2 @OperatorV2Part2 @DriverStrengthV2 @Saas @ShouldAlwaysRun
Feature: Driver Strength

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Operator should be able to add a new Driver
    Given Operator go to menu Fleet -> Driver Strength
    When Operator create new Driver on Driver Strength page using data below:
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 100                                                              |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 100                                                              |
      | contactType          | Email                                                            |
      | contact              | GENERATED                                                        |
      | zoneId               | Z-Out of Zone                                                    |
      | zoneMin              | 1                                                                |
      | zoneMax              | 1                                                                |
      | zoneCost             | 1                                                                |
      | username             | GENERATED                                                        |
      | password             | GENERATED                                                        |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    And DB Operator get data of created driver
    Then Operator verify driver strength params of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to edit new Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"Ops","availability":false,"codLimit":100,"vehicles":[{"capacity":100,"active":true,"vehicleType":"Car","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"Email","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":1.3597220659709373,"longitude":103.82701942695314,"rank":1,"zoneId":1,"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator edit created Driver on Driver Strength page using data below:
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 200                                                              |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 200                                                              |
      | contact              | GENERATED                                                        |
      | zoneId               | ZZZ-All Zones                                                    |
      | zoneMin              | 2                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 2                                                                |
      | password             | GENERATED                                                        |
      | comments             | This driver is UPDATED by "Automation Test" for testing purpose. |
    Then Operator verify driver strength params of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to add a new Driver and verify the 'Contact Details' is correct
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    When API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"Ops","availability":false,"codLimit":100,"vehicles":[{"capacity":100,"active":true,"vehicleType":"Car","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"Email","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":1.3597220659709373,"longitude":103.82701942695314,"rank":1,"zoneId":1,"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    Then Operator verify contact details of created driver on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to delete a Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"Ops","availability":false,"codLimit":100,"vehicles":[{"capacity":100,"active":true,"vehicleType":"Car","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"Email","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":1.3597220659709373,"longitude":103.82701942695314,"rank":1,"zoneId":1,"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator delete created driver on Driver Strength page
    Then Operator verify new driver is deleted successfully on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to change the 'Coming' value
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"Ops","availability":false,"codLimit":100,"vehicles":[{"capacity":100,"active":true,"vehicleType":"Car","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"Email","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":1.3597220659709373,"longitude":103.82701942695314,"rank":1,"zoneId":1,"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator change Coming value for created driver on Driver Strength page
    Then Operator verify Coming value for created driver has been changed on Driver Strength page

  @DeleteDriver
  Scenario: Operator should be able to filter Driver by 'Zones'
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"Ops","availability":false,"codLimit":100,"vehicles":[{"capacity":100,"active":true,"vehicleType":"Car","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"Email","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":1.3597220659709373,"longitude":103.82701942695314,"rank":1,"zoneId":1,"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator filter driver strength by "Z-Out of Zone" zone
    Then Operator verify driver strength is filtered by "Z-Out of Zone" zone

  @DeleteDriver
  Scenario: Operator should be able to filter Driver by 'Driver Types'
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver on Driver Strength page using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"Ops","availability":false,"codLimit":100,"vehicles":[{"capacity":100,"active":true,"vehicleType":"Car","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"Email","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":1.3597220659709373,"longitude":103.82701942695314,"rank":1,"zoneId":1,"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    When Operator filter driver strength by "Ops" driver type
    Then Operator verify driver strength is filtered by "Ops" driver type

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
