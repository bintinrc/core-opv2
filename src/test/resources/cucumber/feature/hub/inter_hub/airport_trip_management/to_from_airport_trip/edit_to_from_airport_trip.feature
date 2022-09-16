@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @EditToFromAirportTrip
Feature: Airport Trip Management - Edit To From Airport Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Edit To/from Airport Trip - Comments
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}    |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator open edit airport trip page with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                       |
    And Operator edit data on Edit Trip page:
      | tripType | ToFrom Airport Trip              |
      | comment  | API automation update            |
      | drivers  | -                                |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    And Operator click on 'Load Trips' on Airport Management
    Then Operator verify parameters of air trip on Airport Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | comment | API automation update|


  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Edit To/from Airport Trip with Assign Single Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}    |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator open edit airport trip page with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                       |
    And Operator edit data on Edit Trip page:
      | tripType | ToFrom Airport Trip              |
      | comment  | API automation update            |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    And Operator click on 'Load Trips' on Airport Management
    Then Operator verify parameters of air trip on Airport Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
      | comment | API automation update|

  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Edit To/from Airport Trip with Assign Multiple Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}    |
    And API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator open edit airport trip page with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                       |
    And Operator edit data on Edit Trip page:
      | tripType | ToFrom Airport Trip              |
      | comment  | API automation update            |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username}|
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    And Operator click on 'Load Trips' on Airport Management
    Then Operator verify parameters of air trip on Airport Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username}|
      | comment | API automation update|

  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Edit To/from Airport Trip with Assign Multiple Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}    |
    And API Operator create 4 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator open edit airport trip page with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                       |
    And Operator edit data on Edit Trip page:
      | tripType | ToFrom Airport Trip              |
      | comment  | API automation update            |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username},{KEY_LIST_OF_CREATED_DRIVERS[3].username},{KEY_LIST_OF_CREATED_DRIVERS[4].username}|
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    And Operator click on 'Load Trips' on Airport Management
    Then Operator verify parameters of air trip on Airport Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username},{KEY_LIST_OF_CREATED_DRIVERS[3].username},{KEY_LIST_OF_CREATED_DRIVERS[4].username}|
      | comment | API automation update|

  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Edit To/from Airport Trip with Assign >4 Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}    |
    And API Operator create 5 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator open edit airport trip page with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                       |
    And Operator edit data on Edit Trip page:
      | tripType | ToFrom Airport Trip              |
      | comment  | API automation update            |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username},{KEY_LIST_OF_CREATED_DRIVERS[3].username},{KEY_LIST_OF_CREATED_DRIVERS[4].username},{KEY_LIST_OF_CREATED_DRIVERS[5].username}|
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    And Operator click on 'Load Trips' on Airport Management
    Then Operator verify parameters of air trip on Airport Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username},{KEY_LIST_OF_CREATED_DRIVERS[3].username},{KEY_LIST_OF_CREATED_DRIVERS[4].username}|
      | comment | API automation update|

  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Edit To/from Airport Trip with Assign Expired License Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}    |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator open edit airport trip page with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                       |
    And Operator verify "expired" license driver "{expired-driver-username}" is not displayed on Create Airport Trip page
    And Operator edit data on Edit Trip page:
      | tripType | ToFrom Airport Trip              |
      | comment  | API automation update            |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    And Operator click on 'Load Trips' on Airport Management
    Then Operator verify parameters of air trip on Airport Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
      | comment | API automation update|

  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Edit To/from Airport Trip with Assign Expired Employment Date Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}    |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator open edit airport trip page with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                       |
    And Operator verify "expired" license driver "{inactive-driver-username}" is not displayed on Create Airport Trip page
    And Operator edit data on Edit Trip page:
      | tripType | ToFrom Airport Trip              |
      | comment  | API automation update            |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    And Operator click on 'Load Trips' on Airport Management
    Then Operator verify parameters of air trip on Airport Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
      | comment | API automation update|

  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Edit To/from Airport Trip with Assign Expired License Driver before Submit
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}    |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator open edit airport trip page with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                       |
    And Operator verify "expired" license driver "{expired-driver-username}" is not displayed on Create Airport Trip page
    And Operator edit data on Edit Trip page:
      | tripType | ToFrom Airport Trip              |
      | comment  | API automation update            |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    And Operator click on 'Load Trips' on Airport Management
    Then Operator verify parameters of air trip on Airport Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
      | comment | API automation update|

  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Edit To/from Airport Trip with Assign Expired Employment Date Driver before Submit
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}    |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator open edit airport trip page with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                       |
    And Operator verify "expired" license driver "{inactive-driver-username}" is not displayed on Create Airport Trip page
    And Operator edit data on Edit Trip page:
      | tripType | ToFrom Airport Trip              |
      | comment  | API automation update            |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    And Operator click on 'Load Trips' on Airport Management
    Then Operator verify parameters of air trip on Airport Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username}|
      | comment | API automation update|

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
