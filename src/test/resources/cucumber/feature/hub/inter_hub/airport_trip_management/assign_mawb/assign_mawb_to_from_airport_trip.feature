@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AssignMAWBToFromAirportTrip
Feature: Airport Trip Management - Assign MAWB Trip To/from Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Assign MAWB To/from Airport Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
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
      | airtripType         | TO_FROM_AIRPORT_TRIP                 |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}     |
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
    Then Operator verify "Assign MAWB" button is disabled on Airport Trip page

  @KillBrowser
  Scenario: Kill Browser
    Given no-op