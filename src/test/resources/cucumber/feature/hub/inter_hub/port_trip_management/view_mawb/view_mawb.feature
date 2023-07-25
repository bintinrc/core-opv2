@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @ViewMAWB
Feature: Airport Trip Management - View MAWB

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments @DeleteCreatedPorts @DeleteCreatedHubs @CancelCreatedMovementTrips
  Scenario: View MAWB on Pending Flight Trip
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 0 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
    When API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When API MM - Update shipment dimension with id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" to weight: 1.0, length: 2.0, width: 3.0, and height: 4.0
    When API MM - Link single or multiple shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" to AWB "RANDOM" with "airport" id from "{KEY_MM_LIST_OF_CREATED_PORTS[1].id}" to "{KEY_MM_LIST_OF_CREATED_PORTS[2].id}" and vendor id "{vendor-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator assigns MAWB to flight trip on Port Trip Management page with data below:
      | tripID | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_MM_LIST_OF_CREATED_MAWBS[1]}              |
    Then Operator verifies assigned MAWB success message on Port Trip Management page
    When Operator clicks "View MAWB" button on Port Trip Management page
    Then Operator verifies can view assigned MAWB on Flight Trip in Port Trip Management page

  @DeleteCreatedShipments @DeleteCreatedMAWBsV2 @DeleteCreatedPorts @DeleteCreatedHubs @CancelCreatedMovementTrips
  Scenario: View MAWB on Transit Flight Trip
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 0 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
    When API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When API MM - Update shipment dimension with id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" to weight: 1.0, length: 2.0, width: 3.0, and height: 4.0
    When API MM - Link single or multiple shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" to AWB "RANDOM" with "airport" id from "{KEY_MM_LIST_OF_CREATED_PORTS[1].id}" to "{KEY_MM_LIST_OF_CREATED_PORTS[2].id}" and vendor id "{vendor-id}"
    And API MM - Operator "depart" air haul trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]"
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator assigns MAWB to flight trip on Port Trip Management page with data below:
      | tripID | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_MM_LIST_OF_CREATED_MAWBS[1]}              |
    Then Operator verifies assigned MAWB success message on Port Trip Management page
    When Operator clicks "View MAWB" button on Port Trip Management page
    Then Operator verifies can view assigned MAWB on Flight Trip in Port Trip Management page

  @DeleteCreatedShipments @DeleteCreatedMAWBsV2 @DeleteCreatedPorts @DeleteCreatedHubs @CancelCreatedMovementTrips
  Scenario: View MAWB on Arrived Flight Trip
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 0 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
    When API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When API MM - Update shipment dimension with id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" to weight: 1.0, length: 2.0, width: 3.0, and height: 4.0
    When API MM - Link single or multiple shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" to AWB "RANDOM" with "airport" id from "{KEY_MM_LIST_OF_CREATED_PORTS[1].id}" to "{KEY_MM_LIST_OF_CREATED_PORTS[2].id}" and vendor id "{vendor-id}"
    And API MM - Operator "depart" air haul trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]"
    And API MM - Operator "arrive" air haul trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]"
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator assigns MAWB to flight trip on Port Trip Management page with data below:
      | tripID | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_MM_LIST_OF_CREATED_MAWBS[1]}              |
    Then Operator verifies assigned MAWB success message on Port Trip Management page
    When Operator clicks "View MAWB" button on Port Trip Management page
    Then Operator verifies can view assigned MAWB on Flight Trip in Port Trip Management page

  @DeleteCreatedShipments @DeleteCreatedMAWBsV2 @DeleteCreatedPorts @DeleteCreatedHubs @CancelCreatedMovementTrips
  Scenario: View MAWB on Completed Flight Trip
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 0 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
    When API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When API MM - Update shipment dimension with id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" to weight: 1.0, length: 2.0, width: 3.0, and height: 4.0
    When API MM - Link single or multiple shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" to AWB "RANDOM" with "airport" id from "{KEY_MM_LIST_OF_CREATED_PORTS[1].id}" to "{KEY_MM_LIST_OF_CREATED_PORTS[2].id}" and vendor id "{vendor-id}"
    And API MM - Operator "depart" air haul trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]"
    And API MM - Operator "arrive" air haul trip "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1]"
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator assigns MAWB to flight trip on Port Trip Management page with data below:
      | tripID | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_MM_LIST_OF_CREATED_MAWBS[1]}              |
    Then Operator verifies assigned MAWB success message on Port Trip Management page
    When Operator clicks "View MAWB" button on Port Trip Management page
    Then Operator verifies can view assigned MAWB on Flight Trip in Port Trip Management page

  @DeleteCreatedShipments @DeleteCreatedMAWBsV2 @DeleteCreatedPorts @DeleteCreatedHubs @CancelCreatedMovementTrips
  Scenario: View MAWB on Cancelled Flight Trip
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 0 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                                                   |
    When API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    When API MM - Update shipment dimension with id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" to weight: 1.0, length: 2.0, width: 3.0, and height: 4.0
    When API MM - Link single or multiple shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" to AWB "RANDOM" with "airport" id from "{KEY_MM_LIST_OF_CREATED_PORTS[1].id}" to "{KEY_MM_LIST_OF_CREATED_PORTS[2].id}" and vendor id "{vendor-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator assigns MAWB to flight trip on Port Trip Management page with data below:
      | tripID | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_MM_LIST_OF_CREATED_MAWBS[1]}              |
    Then Operator verifies assigned MAWB success message on Port Trip Management page
    When Operator cancel trip "{KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId}" on Port Trip Management page
    And Operator select Cancellation Reason on Cancel Trip Page
    Then Operator verifies the Cancellation Reason are correct
    When Operator clicks "Cancel Flight Trip" button on cancel trip dialog
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} cancelled" display on Port Trip Management page
    And Operator verify "View MAWB" button is disabled on Port Trip page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op