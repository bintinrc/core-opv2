@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditFlightTrip
Feature: Airport Trip Management - Edit Flight Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteCreatedPorts @hp
  Scenario: Edit Flight Trip - Comments
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
      | flight_no           | 12345                                   |
      | mawb                | 123-12345679                            |
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
      | tripType | Flight Trip           |
      | comment  | API automation update |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | comment | API automation update                      |

  @CancelTrip @DeleteCreatedPorts @hp
  Scenario: Edit Flight Trip - Flight Number
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
      | flight_no           | 12345                                   |
      | mawb                | 123-12345679                            |
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
      | flight_no | 23456       |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page

  @CancelTrip @DeleteCreatedPorts
  Scenario: Edit Flight Trip - Unable to edit all mandatory field
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
      | flight_no           | 12345                                   |
      | mawb                | 123-12345679                            |
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
