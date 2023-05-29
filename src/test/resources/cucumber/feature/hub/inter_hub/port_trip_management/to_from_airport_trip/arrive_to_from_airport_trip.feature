@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @ArriveToFromAirportTrip
Feature: Airport Trip Management - Arrive To From Airport Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts @DeleteMiddleMileDriver @CancelTrip
  Scenario: Arrive Warehouse to Airport Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    And API Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
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
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} arrived" display on Port Trip Management page
    When Operator refresh page
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
    And Operator verifies "COMPLETE" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @CancelTrip
  Scenario: Arrive Airport to Warehouse Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    And API Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
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
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} arrived" display on Port Trip Management page
    When Operator refresh page
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
    And Operator verifies "COMPLETE" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @CancelTrip
  Scenario: Arrive Warehouse to Airport Trip with Expired Employment Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    And API Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator deactivate "employment status" for driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}"
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
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} arrived" display on Port Trip Management page
    When Operator refresh page
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
    And Operator verifies "COMPLETE" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @CancelTrip
  Scenario: Arrive Warehouse to Airport Trip with Expired License Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    And API Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator deactivate "license status" for driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}"
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
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} arrived" display on Port Trip Management page
    When Operator refresh page
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
    And Operator verifies "COMPLETE" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @CancelTrip
  Scenario: Arrive Warehouse to Airport Trip with Expired Employment and License Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    And API Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator deactivate "employment status" for driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}"
    And API Operator deactivate "license status" for driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}"
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
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} arrived" display on Port Trip Management page
    When Operator refresh page
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
    And Operator verifies "COMPLETE" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @CancelTrip
  Scenario: Arrive Airport to Warehouse Trip with Expired Employment Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    And API Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator deactivate "employment status" for driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}"
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
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} arrived" display on Port Trip Management page
    When Operator refresh page
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
    And Operator verifies "COMPLETE" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @CancelTrip
  Scenario: Arrive Airport to Warehouse Trip with Expired License Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    And API Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator deactivate "license status" for driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}"
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
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} arrived" display on Port Trip Management page
    When Operator refresh page
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
    And Operator verifies "COMPLETE" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @CancelTrip
  Scenario: Arrive Airport to Warehouse Trip with Expired Employment and License Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
      | destinationFacility | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    And API Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    And API Operator deactivate "employment status" for driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}"
    And API Operator deactivate "license status" for driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id}"
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
    When Operator arrives trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} arrived" display on Port Trip Management page
    When Operator refresh page
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
    And Operator verifies "COMPLETE" button is shown on Port Trip Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
