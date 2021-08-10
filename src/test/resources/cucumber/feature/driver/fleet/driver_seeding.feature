@OperatorV2 @Driver @Fleet @DriverSeeding
Feature: Driver Seeding

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedZone @DeleteDriver
  Scenario: Load Driver Involved by Selecting Zone - Checks on Inactive Drivers Checkbox (uid:edf11da5-c3e1-409d-87c7-5c20edf094ea)
    Given API Operator create zone using data below:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"availability":true,"codLimit":100,"comments":"This driver is created by \"Automation Test\" for testing purpose.","contacts":[{"active":true,"details":"{{DRIVER_CONTACT_DETAIL}}","type":"{contact-type-name}"}],"driverType":"{driver-type-name}","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","hubId":381,"lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","maxOnDemandJobs":1,"password":"D00{{TIMESTAMP}}","tags":{},"username":"D{{TIMESTAMP}}","vehicles":[{"active":true,"capacity":100,"ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}","vehicleType":"{vehicle-type}"}],"zonePreferences":[{"cost":1,"latitude":"{{RANDOM_LATITUDE}}","longitude":"{{RANDOM_LONGITUDE}}","maxWaypoints":1,"minWaypoints":1,"rank":1,"zoneId":{KEY_CREATED_ZONE.id}}]}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"availability":false,"codLimit":100,"comments":"This driver is created by \"Automation Test\" for testing purpose.","contacts":[{"active":true,"details":"{{DRIVER_CONTACT_DETAIL}}","type":"{contact-type-name}"}],"driverType":"{driver-type-name}","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","hubId":381,"lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","maxOnDemandJobs":1,"password":"D00{{TIMESTAMP}}","tags":{},"username":"D{{TIMESTAMP}}","vehicles":[{"active":true,"capacity":100,"ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}","vehicleType":"{vehicle-type}"}],"zonePreferences":[{"cost":1,"latitude":"{{RANDOM_LATITUDE}}","longitude":"{{RANDOM_LONGITUDE}}","maxWaypoints":1,"minWaypoints":1,"rank":1,"zoneId":{KEY_CREATED_ZONE.id}}]}} |
    When Operator go to menu Fleet -> Driver Seeding
    And Operator selects zones on Driver Seeding page:
      | {KEY_CREATED_ZONE.name} |
    Then Following drivers are listed on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
    And Following drivers are displayed on the map on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
    When Operator check 'Inactive Drivers' checkbox on Driver Seeding page
    Then Following drivers are listed on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
    And Following drivers are displayed on the map on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |

  @DeleteCreatedZone @DeleteDriver
  Scenario: Load Driver Involved by Selecting Zone - Checks on All Preferred Zones Checkbox (uid:d2df2edd-a328-44aa-909c-50558c4be619)
    Given API Operator create zone using data below:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    Given API Operator create zone using data below:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"availability":true,"codLimit":100,"comments":"This driver is created by \"Automation Test\" for testing purpose.","contacts":[{"active":true,"details":"{{DRIVER_CONTACT_DETAIL}}","type":"{contact-type-name}"}],"driverType":"{driver-type-name}","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","hubId":381,"lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","maxOnDemandJobs":1,"password":"D00{{TIMESTAMP}}","tags":{},"username":"D{{TIMESTAMP}}","vehicles":[{"active":true,"capacity":100,"ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}","vehicleType":"{vehicle-type}"}],"zonePreferences":[{"cost":1,"latitude":"{{RANDOM_LATITUDE}}","longitude":"{{RANDOM_LONGITUDE}}","maxWaypoints":1,"minWaypoints":1,"rank":1,"zoneId":{KEY_LIST_OF_CREATED_ZONES_ID[2]}}]}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"availability":true,"codLimit":100,"comments":"This driver is created by \"Automation Test\" for testing purpose.","contacts":[{"active":true,"details":"{{DRIVER_CONTACT_DETAIL}}","type":"{contact-type-name}"}],"driverType":"{driver-type-name}","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","hubId":381,"lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","maxOnDemandJobs":1,"password":"D00{{TIMESTAMP}}","tags":{},"username":"D{{TIMESTAMP}}","vehicles":[{"active":true,"capacity":100,"ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}","vehicleType":"{vehicle-type}"}],"zonePreferences":[{"cost":1,"latitude":"{{RANDOM_LATITUDE}}","longitude":"{{RANDOM_LONGITUDE}}","maxWaypoints":1,"minWaypoints":1,"rank":1,"zoneId":{KEY_LIST_OF_CREATED_ZONES_ID[1]}},{"cost":1,"latitude":"{{RANDOM_LATITUDE}}","longitude":"{{RANDOM_LONGITUDE}}","maxWaypoints":1,"minWaypoints":1,"rank":2,"zoneId":{KEY_LIST_OF_CREATED_ZONES_ID[2]}}]}} |
    When Operator go to menu Fleet -> Driver Seeding
    And Operator selects zones on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_ZONES[2].name} |
    Then Following drivers are listed on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
    And Following drivers are displayed on the map on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
    When Operator check 'All Preferred Zones' checkbox on Driver Seeding page
    Then Following drivers are listed on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
    And Following drivers are displayed on the map on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |

  @DeleteCreatedZone @DeleteDriver
  Scenario: Load Driver Involved by Selecting Zone - Checks on Reserve Fleet Drivers (uid:b8e1a010-0513-4703-90ac-07898beeacca)
    Given API Operator create zone using data below:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"availability":true,"codLimit":100,"comments":"This driver is created by \"Automation Test\" for testing purpose.","contacts":[{"active":true,"details":"{{DRIVER_CONTACT_DETAIL}}","type":"{contact-type-name}"}],"driverType":"{driver-type-name}","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","hubId":381,"lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","maxOnDemandJobs":1,"password":"D00{{TIMESTAMP}}","tags":{},"username":"D{{TIMESTAMP}}","vehicles":[{"active":true,"capacity":100,"ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}","vehicleType":"{vehicle-type}"}],"zonePreferences":[{"cost":1,"latitude":"{{RANDOM_LATITUDE}}","longitude":"{{RANDOM_LONGITUDE}}","maxWaypoints":1,"minWaypoints":1,"rank":1,"zoneId":{KEY_LIST_OF_CREATED_ZONES_ID[1]}}]}} |
    And DB Operator sets flags of driver with id "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to 1
    When Operator go to menu Fleet -> Driver Seeding
    And Operator selects zones on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_ZONES[1].name} |
    And Operator check 'Reserve Fleet Drivers' checkbox on Driver Seeding page
    Then Following drivers are listed on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
    And Following drivers are displayed on the map on Driver Seeding page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |

  @DeleteCreatedZone @DeleteDriver
  Scenario:   Scenario: Changing Zone Preference of the Driver by Moving It to Another Zone (uid:216f28e3-ea31-47d3-9828-ede8a4621350)
    Given API Operator create zone using data below:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"availability":true,"codLimit":100,"comments":"This driver is created by \"Automation Test\" for testing purpose.","contacts":[{"active":true,"details":"{{DRIVER_CONTACT_DETAIL}}","type":"{contact-type-name}"}],"driverType":"{driver-type-name}","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","hubId":381,"lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","maxOnDemandJobs":1,"password":"D00{{TIMESTAMP}}","tags":{},"username":"D{{TIMESTAMP}}","vehicles":[{"active":true,"capacity":100,"ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}","vehicleType":"{vehicle-type}"}],"zonePreferences":[{"cost":1,"latitude":"{{RANDOM_LATITUDE}}","longitude":"{{RANDOM_LONGITUDE}}","maxWaypoints":1,"minWaypoints":1,"rank":1,"zoneId":{KEY_CREATED_ZONE.id}}]}} |
    When Operator go to menu Fleet -> Driver Seeding
    And Operator selects zones on Driver Seeding page:
      | {KEY_CREATED_ZONE.name} |
    And Operator move "{KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}" driver on the map on Driver Seeding page
    Then API Operator verifies coordinates of created driver were updated

  @KillBrowser
  Scenario: Kill Browser
    Given no-op