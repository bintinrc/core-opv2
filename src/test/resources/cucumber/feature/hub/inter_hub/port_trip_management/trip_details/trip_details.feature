@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @TripDetails
Feature: Airport Trip Management - Trip Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @CancelCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Trip Details Warehouse To Airport - Trip Events
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
  	When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
	  | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{local-hub-3-id}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
  	Then Operator opens trip detail page for trip id "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management
	Then Operator verifies it direct to trip details on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | ToFrom Airport Trip                               |
	And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @HappyPath @CancelCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Trip Details Warehouse To Airport - Shipments
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
  	When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
	  | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{local-hub-3-id}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
  	Then Operator opens trip detail page for trip id "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management
  	Then Operator verifies it direct to trip details on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | ToFrom Airport Trip                               |
	And Operator verifies the element of "Shipments" tab on Port Trip details page are correct

  @CancelCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Trip Details Airport To Warehouse - Trip Events
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
	Given Operator go to menu Inter-Hub -> Port Trip Management
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
  	  | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{local-hub-3-id}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
    Then Operator opens trip detail page for trip id "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management
    Then Operator verifies it direct to trip details on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | ToFrom Airport Trip                               |
	And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @CancelCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Trip Details Airport To Warehouse - Shipments
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
	Given Operator go to menu Inter-Hub -> Port Trip Management
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
  	  | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{local-hub-3-id}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
    Then Operator opens trip detail page for trip id "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management
	  Then Operator verifies it direct to trip details on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | ToFrom Airport Trip                               |
	And Operator verifies the element of "Shipments" tab on Port Trip details page are correct

  @HappyPath @CancelCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Trip Details Flight Trip - Trip Events
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
	Given API MM - Operator creates new Port with data below:
	  | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
  	  | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
    Then Operator opens trip detail page for trip id "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management
    Then Operator verifies it direct to trip details on Port Trip Management page with data below:
	  | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
	  | tripType | Flight Trip                                       |
	And Operator verifies the element of "Trip Events" tab on Port Trip details page are correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op