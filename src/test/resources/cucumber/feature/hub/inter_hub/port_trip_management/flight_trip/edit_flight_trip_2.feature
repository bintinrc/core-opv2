@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditFlightTrip2
Feature: Airport Trip Management - Edit Flight Trip 2

  @LaunchBrowser @ShouldAlwaysRun @runthis
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteCreatedPorts
  Scenario: Edit Pending Flight Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    Given API MM - Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                             |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[2].hubId} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                          |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                          |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType  | Flight Trip           |
      | flight_no | NLI 4321 NV           |
      | comment   | API automation update |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID    | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | comment   | API automation update                      |
      | flight_no | NLI 4321 NV                                |

  @CancelTrip @DeleteCreatedPorts @runthis
  Scenario: Edit Flight Trip from Existing Flight Number to New Flight Number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) |
    And Operator click on 'Create Flight Trip' button in Port Management page
    And Create a new flight trip on Port Trip Management using below data:
      | originFacility       | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility  | {KEY_MM_LIST_OF_CREATED_PORTS[2].portCode} |
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
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].portCode} (Airport) is created. View Details" created success message on Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                          |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                          |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType  | Flight Trip          |
      | flight_no | Edited Flight Number |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID    | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | flight_no | Edited Flight Number                       |

  @CancelTrip @DeleteCreatedPorts
  Scenario: Edit Flight Trip from Existing Flight Number to Empty Flight Number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    Given API MM - Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                             |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[2].hubId} |
      | flight_no           | NLI 4321 NV                             |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                          |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                          |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType  | Flight Trip |
      | flight_no |             |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID    | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | flight_no |                                            |

  @KillBrowser @ShouldAlwaysRun @runthis
  Scenario: Kill Browser
    Given no-op