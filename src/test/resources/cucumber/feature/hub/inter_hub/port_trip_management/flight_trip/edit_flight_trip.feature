@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditFlightTrip
Feature: Airport Trip Management - Edit Flight Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Flight Trip - Comments
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
	When API MM - Operator creates new "Flight" Air Haul Trip with data below:
	  | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 1 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
	  | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                                                 |
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	When Operator fill the Origin Or Destination for Port Management
	  | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
	And Operator click on 'Load Trips' on Port Management
	Then Verify the parameters of loaded trips in Port Management
	  | startDate           | {date: 0 days next, yyyy-MM-dd-HH-mm}                   |
	  | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                   |
	  | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
	When Operator open edit airport trip on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | Flight Trip                                       |
	And Operator edit data on Edit Trip Port Trip Management page:
	  | tripType | Flight Trip           |
	  | comment  | API automation update |
	Then Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	And Operator click on 'Load Trips' on Port Management
	Then Operator verify parameters of air trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]" on Port Trip Management page:
	  | comment | API automation update |

  @HappyPath @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Flight Trip - Flight Number
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
	When API MM - Operator creates new "Flight" Air Haul Trip with data below:
	  | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 1 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
	  | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                                                 |
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	When Operator fill the Origin Or Destination for Port Management
	  | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
	And Operator click on 'Load Trips' on Port Management
	Then Verify the parameters of loaded trips in Port Management
	  | startDate           | {date: 0 days next, yyyy-MM-dd-HH-mm}                   |
	  | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                   |
	  | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
	When Operator open edit airport trip on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | Flight Trip                                       |
	And Operator edit data on Edit Trip Port Trip Management page:
	  | tripType  | Flight Trip |
	  | flight_no | 23456       |
	Then Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) to {KEY_MM_LIST_OF_CREATED_PORTS[2].airportCode} (Airport) is updated. View Details" created success message on Port Trip Management page
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	And Operator click on 'Load Trips' on Port Management
	Then Operator verify parameters of air trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]" on Port Trip Management page:
	  | flight_no | 23456 |

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Flight Trip - Unable to edit all mandatory field
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
	When API MM - Operator creates new "Flight" Air Haul Trip with data below:
	  | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 1 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
	  | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                                                 |
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 0 days next, yyyy-MM-dd-HH-mm} |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	When Operator fill the Origin Or Destination for Port Management
	  | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
	And Operator click on 'Load Trips' on Port Management
	Then Verify the parameters of loaded trips in Port Management
	  | startDate           | {date: 0 days next, yyyy-MM-dd-HH-mm}                   |
	  | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                   |
	  | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].airportCode} (Airport) |
	When Operator open edit airport trip on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | Flight Trip                                       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op
