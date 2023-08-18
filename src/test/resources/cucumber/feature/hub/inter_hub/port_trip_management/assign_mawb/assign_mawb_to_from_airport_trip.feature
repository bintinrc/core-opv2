@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AssignMAWBToFromAirportTrip
Feature: Airport Trip Management - Assign MAWB Trip To/from Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Assign MAWB To/from Airport Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{local-hub-3-id}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 0 days next, yyyy-MM-dd-HH-mm}                          |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                          |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
    Then Operator verify "Assign MAWB" button is disabled on Port Trip page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op