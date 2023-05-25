@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditToFromAirportTrip
Feature: Airport Trip Management - Edit To From Airport Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts
  Scenario: Edit To/from Airport Trip - Comments
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                        |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType | ToFrom Airport Trip   |
      | comment  | API automation update |
      | drivers  | -                     |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | comment | API automation update                      |


  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Edit To/from Airport Trip with Assign Single Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                        |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType | ToFrom Airport Trip                       |
      | comment  | API automation update                     |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username} |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username}  |
      | comment | API automation update                      |

  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Edit To/from Airport Trip with Assign Multiple Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    And API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                        |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType | ToFrom Airport Trip                                                                 |
      | comment  | API automation update                                                               |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username} |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}                                          |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username} |
      | comment | API automation update                                                               |

  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Edit To/from Airport Trip with Assign Multiple Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    And API Operator create 4 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                        |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType | ToFrom Airport Trip                                                                                                                                                     |
      | comment  | API automation update                                                                                                                                                   |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username},{KEY_LIST_OF_CREATED_DRIVERS[3].username},{KEY_LIST_OF_CREATED_DRIVERS[4].username} |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}                                                                                                                              |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username},{KEY_LIST_OF_CREATED_DRIVERS[3].username},{KEY_LIST_OF_CREATED_DRIVERS[4].username} |
      | comment | API automation update                                                                                                                                                   |

  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Edit To/from Airport Trip with Assign >4 Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    And API Operator create 5 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                        |
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType | ToFrom Airport Trip                                                                                                                                                                                               |
      | comment  | API automation update                                                                                                                                                                                             |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username},{KEY_LIST_OF_CREATED_DRIVERS[3].username},{KEY_LIST_OF_CREATED_DRIVERS[4].username},{KEY_LIST_OF_CREATED_DRIVERS[5].username} |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}                                                                                                                              |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username},{KEY_LIST_OF_CREATED_DRIVERS[2].username},{KEY_LIST_OF_CREATED_DRIVERS[3].username},{KEY_LIST_OF_CREATED_DRIVERS[4].username} |
      | comment | API automation update                                                                                                                                                   |

  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Edit To/from Airport Trip with Assign Expired License Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                        |
    And Operator verify "expired" license driver "{expired-driver-username}" is not displayed on Create Airport Trip page
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType | ToFrom Airport Trip                       |
      | comment  | API automation update                     |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username} |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username}  |
      | comment | API automation update                      |

  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Edit To/from Airport Trip with Assign Expired Employment Date Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                        |
    And Operator verify "expired" license driver "{inactive-driver-username}" is not displayed on Create Airport Trip page
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType | ToFrom Airport Trip                       |
      | comment  | API automation update                     |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username} |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username}  |
      | comment | API automation update                      |

  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Edit To/from Airport Trip with Assign Expired License Driver before Submit
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                        |
    And Operator verify "expired" license driver "{expired-driver-username}" is not displayed on Create Airport Trip page
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType | ToFrom Airport Trip                       |
      | comment  | API automation update                     |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username} |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username}  |
      | comment | API automation update                      |

  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Edit To/from Airport Trip with Assign Expired Employment Date Driver before Submit
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given API MM - Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                    |
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].hubId} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].id}        |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
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
    When Operator open edit airport trip on Port Trip Management page with data below:
      | tripID   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | tripType | ToFrom Airport Trip                        |
    And Operator verify "expired" license driver "{inactive-driver-username}" is not displayed on Create Airport Trip page
    And Operator edit data on Edit Trip Port Trip Management page:
      | tripType | ToFrom Airport Trip                       |
      | comment  | API automation update                     |
      | drivers  | {KEY_LIST_OF_CREATED_DRIVERS[1].username} |
    Then Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is updated. View Details" created success message on Port Trip Management page
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click on 'Load Trips' on Port Management
    Then Operator verify parameters of air trip on Port Trip Management page:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | drivers | {KEY_LIST_OF_CREATED_DRIVERS[1].username}  |
      | comment | API automation update                      |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
