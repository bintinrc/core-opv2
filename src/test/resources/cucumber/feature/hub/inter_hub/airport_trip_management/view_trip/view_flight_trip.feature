@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @ViewFlightTripAirportTrip
Feature: Airport Trip Management - View Trip Flight Trip Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: View Pending Flight Trip Details - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                          |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
      | flight_no           | 12345                                |
      | mawb                | 123-12345679                         |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) |
    When Operator opens view Airport Trip page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    Then Operator verifies trip status is "PENDING" on Airport Trip details page
    And Operator verifies the element of "Trip Events" tab on Airport Trip details page are correct

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: View Transit Flight Trip Details - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                          |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
      | flight_no           | 12345                                |
      | mawb                | 123-12345679                         |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) |
    When Operator departs trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Airport Trip Management page
    When Operator opens view Airport Trip page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    Then Operator verifies trip status is "TRANSIT" on Airport Trip details page
    And Operator verifies the element of "Trip Events" tab on Airport Trip details page are correct

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: View Arrive Flight Trip Details - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                          |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
      | flight_no           | 12345                                |
      | mawb                | 123-12345679                         |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) |
    When Operator departs trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Airport Trip Management page
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Airport Trip Management page
    When Operator opens view Airport Trip page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    Then Operator verifies trip status is "COMPLETED" on Airport Trip details page
    And Operator verifies the element of "Trip Events" tab on Airport Trip details page are correct

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: View Cancel Flight Trip Details - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                          |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
      | flight_no           | 12345                                |
      | mawb                | 123-12345679                         |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) |
    When Operator cancel trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Airport Trip Management page
    And Operator select Cancellation Reason on Cancel Trip Page
    Then Operator verifies the Cancellation Reason are correct
    And Operator verifies the Cancel Trip button is "enable"
    When Operator clicks "Cancel Flight Trip" button on cancel trip dialog
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} cancelled" display on Airport Trip Management page
    When Operator opens view Airport Trip page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    Then Operator verifies trip status is "CANCELLED" on Airport Trip details page
    And Operator verifies the element of "Trip Events" tab on Airport Trip details page are correct

  @KillBrowser
  Scenario: Kill Browser
    Given no-op