@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AssignDrivers2
Feature: Airport Trip Management - Assign Drivers 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign Single Driver To/from Airport Trip - Trip Details
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
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
    When Operator opens view Airport Trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | ToFrom Airport Trip                        |
    And Operator clicks Assign Driver button on Port Trip details page
    And Operator selects drivers "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS" on Port Trip Management using data below:
      | assignDrivers | 1 |
    And Operator clicks Save button on Assign Driver popup on Port Trip Management page
    Then Operator successful message "%s driver(s) successfully assigned to the trip" display on Assigned Drivers "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS" popup on Port Trip Management

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign Multiple Driver To/from Airport Trip - Trip Details
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
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
    When Operator opens view Airport Trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | ToFrom Airport Trip                        |
    And Operator clicks Assign Driver button on Port Trip details page
    And Operator selects drivers "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS" on Port Trip Management using data below:
      | assignDrivers | 2 |
    And Operator clicks Save button on Assign Driver popup on Port Trip Management page
    Then Operator successful message "%s driver(s) successfully assigned to the trip" display on Assigned Drivers "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS" popup on Port Trip Management

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign Four Drivers To/from Airport Trip - Trip Details
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
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
    When Operator opens view Airport Trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | ToFrom Airport Trip                        |
    And Operator clicks Assign Driver button on Port Trip details page
    And Operator selects drivers "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS" on Port Trip Management using data below:
      | assignDrivers | 4 |
    And Operator clicks Save button on Assign Driver popup on Port Trip Management page
    Then Operator successful message "%s driver(s) successfully assigned to the trip" display on Assigned Drivers "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS" popup on Port Trip Management

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign more than Four Drivers To/from Airport Trip - Trip Details
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
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
    When Operator opens view Airport Trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | ToFrom Airport Trip                        |
    And Operator clicks Assign Driver button on Port Trip details page
    And Operator selects drivers "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS" on Port Trip Management using data below:
      | assignDrivers | 5 |
    And Operator clicks Save button on Assign Driver popup on Port Trip Management page

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Assign Driver with Inactive License Status To/from Airport Trip - Trip Details
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
    When Operator opens view Airport Trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | ToFrom Airport Trip                        |
    And Operator clicks Assign Driver button on Port Trip details page
    Then Operator verifies driver with value "{expired-driver-username}" is not shown on Port Trip Management page

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Assign Driver with Inactive Employment Status To/from Airport Trip - Trip Details
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
    When Operator opens view Airport Trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | ToFrom Airport Trip                        |
    And Operator clicks Assign Driver button on Port Trip details page
    Then Operator verifies driver with value "{inactive-driver-username}" is not shown on Port Trip Management page

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Unassign All Drivers To/from Airport Trip - Trip Details
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
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
    When Operator opens view Airport Trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | ToFrom Airport Trip                        |
    And Operator clicks Assign Driver button on Port Trip details page
    And Operator selects drivers "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS" on Port Trip Management using data below:
      | assignDrivers | 4 |
    And Operator clicks Save button on Assign Driver popup on Port Trip Management page
    Then Operator successful message "%s driver(s) successfully assigned to the trip" display on Assigned Drivers "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS" popup on Port Trip Management
    And Operator clicks Assign Driver button on Port Trip details page
    And Operator clicks Unassign All button on Assign Driver popup on Port Trip Management
    And Operator clicks Save button on Assign Driver popup on Port Trip Management page

  @ForceCompleteCreatedMovementTrips @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Cannot Assign Driver to Flight Trip - Trip Details
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    Given API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[2].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 0 days next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
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
    When Operator opens view Airport Trip on Port Trip Management page with data below:
      | tripID   | {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} |
      | tripType | Flight Trip                                |
    And Operator verify Assign Driver field not appear in Airport Flight Trip Details page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op