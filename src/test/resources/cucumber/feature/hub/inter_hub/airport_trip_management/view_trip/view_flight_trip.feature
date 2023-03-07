@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @ViewFlightTripAirportTrip
Feature: Airport Trip Management - View Trip Flight Trip Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteCreatedPorts
  Scenario: View Pending Flight Trip Details - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
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
    When Operator opens view Airport Trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    Then Operator verifies trip status is "PENDING" on Port Trip details page
    And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @CancelTrip @DeleteCreatedPorts
  Scenario: View Transit Flight Trip Details - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
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
    When Operator departs trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Airport Trip Management page
    When Operator opens view Airport Trip page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    Then Operator verifies trip status is "TRANSIT" on Port Trip details page
    And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @CancelTrip @DeleteCreatedPorts
  Scenario: View Arrive Flight Trip Details - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
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
    When Operator departs trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Airport Trip Management page
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Airport Trip Management page
    When Operator opens view Airport Trip page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    Then Operator verifies trip status is "COMPLETED" on Port Trip details page
    And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @CancelTrip @DeleteCreatedPorts
  Scenario: View Cancel Flight Trip Details - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
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
    When Operator cancel trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Airport Trip Management page
    And Operator select Cancellation Reason on Cancel Trip Page
    Then Operator verifies the Cancellation Reason are correct
    And Operator verifies the Cancel Trip button is "enable"
    When Operator clicks "Cancel Flight Trip" button on cancel trip dialog
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} cancelled" display on Airport Trip Management page
    When Operator opens view Airport Trip page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | Flight Trip                                |
    Then Operator verifies trip status is "CANCELLED" on Port Trip details page
    And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op