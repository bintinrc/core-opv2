@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @TripDetails
Feature: Airport Trip Management - Trip Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Trip Details Warehouse To Airport - Trip Events
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
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | -                                          |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) to {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) is created. View Details" created success message
    When Operator clicks View Details action link on successful toast created to from airport trip
    Then Operator verifies it direct to trip details page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | ToFrom Airport Trip            |
    And Operator verifies the element of "Trip Events" tab on Airport Trip details page are correct

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Trip Details Warehouse To Airport - Shipments
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
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | -                                          |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) to {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) is created. View Details" created success message
    When Operator clicks View Details action link on successful toast created to from airport trip
    Then Operator verifies it direct to trip details page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | ToFrom Airport Trip            |
    And Operator verifies the element of "Shipments" tab on Airport Trip details page are correct

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Trip Details Airport To Warehouse - Trip Events
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
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | -                                          |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is created. View Details" created success message
    When Operator clicks View Details action link on successful toast created to from airport trip
    Then Operator verifies it direct to trip details page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | ToFrom Airport Trip            |
    And Operator verifies the element of "Trip Events" tab on Airport Trip details page are correct

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Trip Details Airport To Warehouse - Shipments
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
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | -                                          |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is created. View Details" created success message
    When Operator clicks View Details action link on successful toast created to from airport trip
    Then Operator verifies it direct to trip details page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | ToFrom Airport Trip            |
    And Operator verifies the element of "Shipments" tab on Airport Trip details page are correct

  @CancelTrip @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Trip Details Flight Trip - Trip Events
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
    And Operator click on 'Create Flight Trip' button in Airport Management page
    And Create a new flight trip using below data:
      | originFacility       | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
      | destinationFacility  | {KEY_CREATED_AIRPORT_LIST[2].airport_code} |
      | departureTime        | 12:00                                      |
      | durationhour         | 09                                         |
      | durationminutes      | 25                                         |
      | departureDate        | {gradle-next-1-day-yyyy-MM-dd}             |
      | originProcesshours   | 00                                         |
      | originProcessminutes | 10                                         |
      | destProcesshours     | 00                                         |
      | destProcessminutes   | 09                                         |
      | flightnumber         | 123456                                     |
      | comments             | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) to {KEY_CREATED_AIRPORT_LIST[2].airport_code} (Airport) is created. View Details" created success message
    When Operator clicks View Details action link on successful toast created to from airport trip
    Then Operator verifies it direct to trip details page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | Flight Trip                    |
    And Operator verifies the element of "Trip Events" tab on Airport Trip details page are correct

  @KillBrowser
  Scenario: Kill Browser
    Given no-op