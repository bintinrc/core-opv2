@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @CompleteToFromAirportTrip
Feature: Airport Trip Management - Complete To From Airport Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Complete Warehouse to Airport Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{local-hub-3-id}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers":[{"driver_id":{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id},"primary":true,"username":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}","license_expiry_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].licenseExpiryDate}","employment_start_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentStartDate}","employment_end_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentEndDate}"}]}                                                                        |
    When API MM - Operator refreshes these movement trips details "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS"
    And API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    And API MM - Operator "arrive" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
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
    When Operator completes trip "{KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id} has completed" display on Port Trip Management page
    And Operator verifies "COMPLETED" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Complete Warehouse to Airport Trip with Expired Employment Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{local-hub-3-id}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers":[{"driver_id":{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id},"primary":true,"username":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}","license_expiry_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].licenseExpiryDate}","employment_start_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentStartDate}","employment_end_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentEndDate}"}]}                                                                        |
    When API MM - Operator refreshes these movement trips details "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS"
    And API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    And API MM - Operator deactivate "employment status" for driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]"
    And API MM - Operator "arrive" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
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
    When Operator completes trip "{KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id} has completed" display on Port Trip Management page
    And Operator verifies "COMPLETED" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Complete Warehouse to Airport Trip with Expired License Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{local-hub-3-id}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers":[{"driver_id":{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id},"primary":true,"username":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}","license_expiry_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].licenseExpiryDate}","employment_start_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentStartDate}","employment_end_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentEndDate}"}]}                                                                        |
    When API MM - Operator refreshes these movement trips details "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS"
    And API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    And API MM - Operator deactivate "license status" for driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]"
    And API MM - Operator "arrive" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
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
    When Operator completes trip "{KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id} has completed" display on Port Trip Management page
    And Operator verifies "COMPLETED" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Complete Warehouse to Airport Trip with Expired Employment and License Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{local-hub-3-id}","origin_hub_system_id":"sg","destination_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers":[{"driver_id":{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id},"primary":true,"username":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}","license_expiry_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].licenseExpiryDate}","employment_start_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentStartDate}","employment_end_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentEndDate}"}]}                                                                        |
    When API MM - Operator refreshes these movement trips details "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS"
    And API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    And API MM - Operator deactivate "employment status" for driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]"
    And API MM - Operator deactivate "license status" for driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]"
    And API MM - Operator "arrive" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
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
    When Operator completes trip "{KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id} has completed" display on Port Trip Management page
    And Operator verifies "COMPLETED" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Complete Airport to Warehouse Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{local-hub-3-id}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers":[{"driver_id":{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id},"primary":true,"username":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}","license_expiry_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].licenseExpiryDate}","employment_start_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentStartDate}","employment_end_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentEndDate}"}]}                                                                        |
    When API MM - Operator refreshes these movement trips details "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS"
    And API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    And API MM - Operator "arrive" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
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
    When Operator completes trip "{KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id} has completed" display on Port Trip Management page
    And Operator verifies "COMPLETED" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Complete Airport to Warehouse Trip with Expired Employment Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{local-hub-3-id}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers":[{"driver_id":{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id},"primary":true,"username":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}","license_expiry_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].licenseExpiryDate}","employment_start_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentStartDate}","employment_end_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentEndDate}"}]}                                                                        |
    When API MM - Operator refreshes these movement trips details "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS"
    And API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    And API MM - Operator deactivate "employment status" for driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]"
    And API MM - Operator "arrive" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
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
    When Operator completes trip "{KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id} has completed" display on Port Trip Management page
    And Operator verifies "COMPLETED" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Complete Airport to Warehouse Trip with Expired License Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{local-hub-3-id}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers":[{"driver_id":{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id},"primary":true,"username":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}","license_expiry_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].licenseExpiryDate}","employment_start_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentStartDate}","employment_end_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentEndDate}"}]}                                                                        |
    When API MM - Operator refreshes these movement trips details "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS"
    And API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    And API MM - Operator deactivate "license status" for driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]"
    And API MM - Operator "arrive" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
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
    When Operator completes trip "{KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id} has completed" display on Port Trip Management page
    And Operator verifies "COMPLETED" button is shown on Port Trip Management page

  @DeleteCreatedPorts @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Complete Airport to Warehouse Trip with Expired Employment and License Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{KEY_MM_LIST_OF_CREATED_PORTS[1].hubId}","origin_hub_system_id":"sg","destination_hub_id":"{local-hub-3-id}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers":[{"driver_id":{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].id},"primary":true,"username":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}","license_expiry_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].licenseExpiryDate}","employment_start_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentStartDate}","employment_end_date":"{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].employmentEndDate}"}]}                                                                        |
    When API MM - Operator refreshes these movement trips details "KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS"
    And API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    And API MM - Operator deactivate "employment status" for driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]"
    And API MM - Operator deactivate "license status" for driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]"
    And API MM - Operator "arrive" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
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
    When Operator completes trip "{KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id}" on Port Trip Management page
    Then Operator verifies trip message "Trip {KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id} has completed" display on Port Trip Management page
    And Operator verifies "COMPLETED" button is shown on Port Trip Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
