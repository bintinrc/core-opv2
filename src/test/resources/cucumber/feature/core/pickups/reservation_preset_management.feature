@OperatorV2 @Core @PickUps @ReservationPresetManagement @Debug
Feature: Reservation Preset Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteReservationGroup
  Scenario: Operator Create New Group to Assign Driver on Reservation Preset Management Page (uid:5e413315-ed96-4c3a-92b6-9b58b2d34a25)
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params

  @DeleteDriver @DeleteReservationGroup
  Scenario: Operator Edit Reservation Group on Reservation Preset Management Page (uid:c4721621-2712-410e-b8c7-561e2999361e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator edit created Reservation Group on Reservation Preset Management page using data below:
      | name | GENERATED    |
      | hub  | {hub-name-2} |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page

  @DeleteDriver @DeleteReservationGroup
  Scenario: Operator Delete Reservation Group on Reservation Preset Management Page (uid:3c303ac8-8409-4337-b854-786a22b50f62)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator delete created Reservation Group on Reservation Preset Management page
    And Operator refresh page
    Then Operator verify created Reservation Group was deleted successfully on Reservation Preset Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
