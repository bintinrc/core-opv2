@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @TripDetails
Feature: Airport Trip Management - Trip Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteCreatedPorts
  Scenario: Trip Details Warehouse To Airport - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
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
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | -                                          |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is created. View Details" created success message on Port Trip Management page
    When Operator clicks View Details action link on successful toast created to from airport trip on Port Trip Management page
    Then Operator verifies it direct to trip details on Port Trip Management page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | ToFrom Airport Trip            |
    And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @CancelTrip @DeleteCreatedPorts
  Scenario: Trip Details Warehouse To Airport - Shipments
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
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
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | -                                          |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is created. View Details" created success message on Port Trip Management page
    When Operator clicks View Details action link on successful toast created to from airport trip on Port Trip Management page
    Then Operator verifies it direct to trip details on Port Trip Management page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | ToFrom Airport Trip            |
    And Operator verifies the element of "Shipments" tab on Port Trip details page are correct

  @CancelTrip @DeleteCreatedPorts
  Scenario: Trip Details Airport To Warehouse - Trip Events
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
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
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | -                                          |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is created. View Details" created success message on Port Trip Management page
    When Operator clicks View Details action link on successful toast created to from airport trip on Port Trip Management page
    Then Operator verifies it direct to trip details on Port Trip Management page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | ToFrom Airport Trip            |
    And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @CancelTrip @DeleteCreatedPorts
  Scenario: Trip Details Airport To Warehouse - Shipments
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
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
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | -                                          |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is created. View Details" created success message on Port Trip Management page
    When Operator clicks View Details action link on successful toast created to from airport trip on Port Trip Management page
    Then Operator verifies it direct to trip details on Port Trip Management page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | ToFrom Airport Trip            |
    And Operator verifies the element of "Shipments" tab on Port Trip details page are correct

  @CancelTrip @DeleteCreatedPorts
  Scenario: Trip Details Flight Trip - Trip Events
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
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                          |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                          |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
    And Operator click on 'Create Flight Trip' button in Port Management page
    And Create a new flight trip using below data:
      | originFacility       | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} |
      | destinationFacility  | {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} |
      | departureTime        | 12:00                                         |
      | durationhour         | 09                                            |
      | durationminutes      | 25                                            |
      | departureDate        | {gradle-next-1-day-yyyy-MM-dd}                |
      | originProcesshours   | 00                                            |
      | originProcessminutes | 10                                            |
      | destProcesshours     | 00                                            |
      | destProcessminutes   | 09                                            |
      | flightnumber         | 123456                                        |
      | comments             | Created by Automation                         |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is created. View Details" created success message on Port Trip Management page
    When Operator clicks View Details action link on successful toast created to from airport trip on Port Trip Management page
    Then Operator verifies it direct to trip details on Port Trip Management page with data below:
      | tripID   | {KEY_CURRENT_MOVEMENT_TRIP_ID} |
      | tripType | Flight Trip                    |
    And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op