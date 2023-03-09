@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @CreateFlightTrip
Feature: Airport Trip Management - Create Flight Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteCreatedPorts
  Scenario: Create Flight Trip
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

  @DeleteCreatedPorts
  Scenario: Create Flight Trip with disabled Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API MM - Operator disables latest port from "KEY_MM_LIST_OF_CREATED_PORTS"
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
    Then Operator verifies toast messages below on Create Flight Trip Port Trip Management page:
      | Status: 404                                                       |
      | URL: post /1.0/airhaul-trips                                      |
      | Error Message: Origin and destination airport is invalid/inactive |


  @DeleteCreatedPorts
  Scenario: Create Flight Trip with zero flight duration time
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Create a new flight trip using below data:
      | durationhour    | 00 |
      | durationminutes | 00 |
    Then Operator verifies duration time error messages on "Create Flight Trip" Port Trip Management page
    And Operator verifies Submit button is disable on Create Airport Trip Port Trip Management page

  @DeleteCreatedPorts
  Scenario: Create Flight Trip with Flight Departure Date before today
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator verifies past date picker "{gradle-previous-1-day-yyyy-MM-dd}" is disable on "Create Flight Trip" Port Trip Management page
    And Operator verifies Submit button is disable on Create Airport Trip Port Trip Management page

  @DeleteCreatedPorts
  Scenario: Create Flight Trip with Same Origin and Destination Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Create a new flight trip using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
    Then Operator verifies same hub error messages on "Create Flight Trip" Port Trip Management page
    And Operator verifies Submit button is disable on Create Airport Trip Port Trip Management page

  @DeleteCreatedPorts
  Scenario: Create Flight Trip with Remove the filled value in the mandatory field
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Create a new flight trip using below data:
      | originFacility | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
    And Operator removes text of "Origin Airport" field on "Create Flight Trip" page
    Then Operator verifies Mandatory require error message of "Origin Airport" field on "Create Flight Trip" Port Trip Management page
    And Operator verifies Submit button is disable on Create Airport Trip Port Trip Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
