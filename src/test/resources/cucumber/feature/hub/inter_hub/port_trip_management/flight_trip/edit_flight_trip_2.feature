@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditFlightTrip2
Feature: Airport Trip Management - Edit Flight Trip 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Pending Flight Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 1 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | Flight Trip                                |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType  | Flight Trip           |
      | flight_no | NLI 4321 NV           |
      | comment   | API automation update |
    Then Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]" on Port Trip Management page:
      | comment   | API automation update                      |
      | flight_no | NLI 4321 NV                                |

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Transit Flight Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 1 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 0 days next, yyyy-MM-dd-HH-mm}                       |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                       |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) |
    When Operator departs trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management page
    Then Operator verifies depart trip message "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" display on Port Trip Management page
    And Operator verifies action buttons below are disable on Port Trip Management page:
      | Edit         |
      | Cancel       |
      | assignDriver |

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Completed Flight Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 1 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
    And API MM - Operator "depart" air haul trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]"
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 0 days next, yyyy-MM-dd-HH-mm}                       |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                       |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) |
    When Operator arrives trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} has completed" display on Port Trip Management page
    When Operator refresh page
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 0 days next, yyyy-MM-dd-HH-mm}                       |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                       |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) |
    And Operator verifies "COMPLETED" button is shown on Port Trip Management page
    And Operator search created flight trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip table
    And Operator verifies action buttons below are disable on Port Trip Management page:
      | Edit         |
      | Cancel       |
      | assignDriver |

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Cancelled Flight Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 1 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
      | flight_no           | 12345                                   |
      | mawb                | 123-12345679                            |
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
    When Operator cancel trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management page
    And Operator select Cancellation Reason on Cancel Trip Page
    Then Operator verifies the Cancellation Reason are correct
    And Operator verifies the Cancel Trip button in Trip Management page is "enable"
    When Operator clicks "Cancel Flight Trip" button on cancel trip dialog
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} cancelled" display on Port Trip Management page
    And Operator verifies "CANCELLED" button is shown on Port Trip Management page
    And Operator search created flight trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip table
    And Operator verifies action buttons below are disable on Port Trip Management page:
      | Edit         |
      | Cancel       |
      | assignDriver |

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Flight Trip from Existing Flight Number to New Flight Number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 1 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
      | flight_no           | NLI 4321 NV                             |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | Flight Trip                                |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType  | Flight Trip          |
      | flight_no | Edited Flight Number |
    Then Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]" on Port Trip Management page:
      | flight_no | Edited Flight Number                       |

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Flight Trip from Existing Flight Number to Empty Flight Number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 1 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
      | flight_no           | NLI 4321 NV                             |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | Flight Trip                                |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType  | Flight Trip |
      | flight_no | empty       |
    Then Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]" on Port Trip Management page:
      | flight_no | empty                                      |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op