@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AssignMAWBFlightTrip
Feature: Airport Trip Management - Assign MAWB to Flight Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedPorts
  Scenario: Assign MAWB to Pending Flight Trip
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                             |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[2].hubId} |
      | flight_no           | 12345                                   |
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                               |
      | destinationAirportId | {KEY_MM_LIST_OF_CREATED_PORTS[2].id} |
      | originAirportId      | {KEY_MM_LIST_OF_CREATED_PORTS[1].id} |
      | vendorId             | {vendor-id}                          |
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator assigns MAWB to flight trip on Port Trip Management page with data below:
      | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
    Then Operator verifies assigned MAWB success message on Port Trip Management page

  @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedPorts
  Scenario: Assign MAWB to Transit Flight Trip
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                             |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[2].hubId} |
      | flight_no           | 12345                                   |
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                               |
      | destinationAirportId | {KEY_MM_LIST_OF_CREATED_PORTS[2].id} |
      | originAirportId      | {KEY_MM_LIST_OF_CREATED_PORTS[1].id} |
      | vendorId             | {vendor-id}                          |
    And API Operator depart flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator assigns MAWB to flight trip on Port Trip Management page with data below:
      | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
    Then Operator verifies assigned MAWB success message on Port Trip Management page

  @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedPorts
  Scenario: Assign MAWB to Arrived Flight Trip
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                             |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[2].hubId} |
      | flight_no           | 12345                                   |
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                               |
      | destinationAirportId | {KEY_MM_LIST_OF_CREATED_PORTS[2].id} |
      | originAirportId      | {KEY_MM_LIST_OF_CREATED_PORTS[1].id} |
      | vendorId             | {vendor-id}                          |
    And API Operator depart flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    And API Operator arrive flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator assigns MAWB to flight trip on Port Trip Management page with data below:
      | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
    Then Operator verifies assigned MAWB success message on Port Trip Management page

  @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedPorts
  Scenario: Assign MAWB to Completed Flight Trip
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                             |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[2].hubId} |
      | flight_no           | 12345                                   |
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                               |
      | destinationAirportId | {KEY_MM_LIST_OF_CREATED_PORTS[2].id} |
      | originAirportId      | {KEY_MM_LIST_OF_CREATED_PORTS[1].id} |
      | vendorId             | {vendor-id}                          |
    And API Operator depart flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    And API Operator arrive flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator assigns MAWB to flight trip on Port Trip Management page with data below:
      | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
    Then Operator verifies assigned MAWB success message on Port Trip Management page

  @DeleteCreatedPorts
  Scenario: Assign MAWB to Cancelled Flight Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                             |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[2].hubId} |
      | flight_no           | 12345                                   |
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
    When Operator cancel trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Port Trip Management page
    And Operator select Cancellation Reason on Cancel Trip Page
    Then Operator verifies the Cancellation Reason are correct
    And Operator verifies the Cancel Trip button is "enable"
    When Operator clicks "Cancel Flight Trip" button on cancel trip dialog
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} cancelled" display on Port Trip Management page
    And Operator verify "Assign MAWB" button is disabled on Port Trip page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op