@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @ViewFlightTripAirportTrip
Feature: Airport Trip Management - View Trip Flight Trip Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: View Pending Flight Trip Details - Trip Events
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
	When Operator opens view Airport Trip on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | Flight Trip                                       |
	Then Operator verifies trip status is "PENDING" on Port Trip details page
	And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: View Transit Flight Trip Details - Trip Events
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
	When Operator departs trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management page
	When Operator opens view Airport Trip on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | Flight Trip                                       |
	Then Operator verifies trip status is "TRANSIT" on Port Trip details page
	And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @HappyPath @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: View Arrive Flight Trip Details - Trip Events
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
	When Operator departs trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management page
	When Operator arrives trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management page
	When Operator opens view Airport Trip on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | Flight Trip                                       |
	Then Operator verifies trip status is "COMPLETED" on Port Trip details page
	And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: View Cancel Flight Trip Details - Trip Events
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
	When Operator cancel trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management page
	And Operator select Cancellation Reason on Cancel Trip Page
	Then Operator verifies the Cancellation Reason are correct
	And Operator verifies the Cancel Trip button in Trip Management page is "enable"
	When Operator clicks "Cancel Flight Trip" button on cancel trip dialog
	Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} cancelled" display on Port Trip Management page
	When Operator opens view Airport Trip on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | Flight Trip                                       |
	Then Operator verifies trip status is "CANCELLED" on Port Trip details page
	And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op