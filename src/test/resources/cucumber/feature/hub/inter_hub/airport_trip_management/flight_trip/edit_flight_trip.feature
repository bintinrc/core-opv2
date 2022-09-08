@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @EditFlightTrip @CWF
Feature: Airport Trip Management - Edit Flight Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @RT
  Scenario: Create Flight Trip
#    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                           |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}  |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}  |
      | flight_no           | 12345                                 |
      | mawb                | 123-12345679                          |
#    Given Operator go to menu Inter-Hub -> Airport Trip Management
#    And Operator verifies that the Airport Management Page is opened
#    When Operator fill the departure date for Airport Management
#      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
#      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
#    When Operator fill the Origin Or Destination for Airport Management
#      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
#    And Operator click on 'Load Trips' on Airport Management
#    Then Verify the parameters of loaded trips in Airport Management
#      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
#      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
#      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
#    And Operator click on 'Create Flight Trip' button in Airport Management page
#    And Create a new flight trip using below data:
#      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
#      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].airport_code}|
#      | departureTime       | 12:00                                     |
#      | durationhour        | 09                                       |
#      | durationminutes     | 25                                        |
#      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}            |
#      | originProcesshours  | 00                                        |
#      | originProcessminutes| 10                                        |
#      | destProcesshours    | 00                                        |
#      | destProcessminutes  | 09                                        |
#      | flightnumber        | 123456                                    |
#      | mawb                | 123-12345677                              |
#      | comments            | Created by Automation                     |
#    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_CREATED_AIRPORT_LIST[2].airport_code} (Airport) is created. View Details" created success message

  @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Create Flight Trip with Invalid MAWB
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
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
    And Operator click on 'Create Flight Trip' button in Airport Management page
    And Create a new flight trip using below data:
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].airport_code}|
      | mawb                | 123-1234                              |
    Then Operator verifies MAWB error messages on Create Flight Trip page
    And Operator verifies Submit button is disable on Create Airport Trip  page

  @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Create Flight Trip with disabled Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    And API Operator disable created airports
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
    And Operator click on 'Create Flight Trip' button in Airport Management page
    And Create a new flight trip using below data:
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].airport_code}|
      | departureTime       | 12:00                                     |
      | durationhour        | 09                                       |
      | durationminutes     | 25                                        |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}            |
      | originProcesshours  | 00                                        |
      | originProcessminutes| 10                                        |
      | destProcesshours    | 00                                        |
      | destProcessminutes  | 09                                        |
      | flightnumber        | 123456                                    |
      | mawb                | 123-12345677                              |
      | comments            | Created by Automation                     |
    Then Operator verifies toast messages below on Create Flight Trip page:
      |Status: 404                                                      |
      |URL: post /1.0/airhaul-trips                                     |
      |Error Message: Origin and destination airport is invalid/inactive|


  @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Create Flight Trip with zero flight duration time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
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
    And Operator click on 'Create Flight Trip' button in Airport Management page
    And Create a new flight trip using below data:
      | durationhour        | 00                                       |
      | durationminutes     | 00                                        |
    Then Operator verifies duration time error messages on "Create Flight Trip" page
    And Operator verifies Submit button is disable on Create Airport Trip  page

  @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Create Flight Trip with Flight Departure Date before today
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
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
    And Operator click on 'Create Flight Trip' button in Airport Management page
    Then Operator verifies past date picker "{gradle-previous-1-day-yyyy-MM-dd}" is disable on "Create Flight Trip" page
    And Operator verifies Submit button is disable on Create Airport Trip  page

  @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Create Flight Trip with Same Origin and Destination Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
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
    And Operator click on 'Create Flight Trip' button in Airport Management page
    And Create a new flight trip using below data:
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    Then Operator verifies same hub error messages on "Create Flight Trip" page
    And Operator verifies Submit button is disable on Create Airport Trip  page

  @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Create Flight Trip with Remove the filled value in the mandatory field
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
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
    And Operator click on 'Create Flight Trip' button in Airport Management page
    And Create a new flight trip using below data:
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator removes text of "Origin Airport" field on "Create Flight Trip" page
    Then Operator verifies Mandatory require error message of "Origin Airport" field on "Create Flight Trip" page
    And Operator verifies Submit button is disable on Create Airport Trip  page

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
