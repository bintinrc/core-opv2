@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @CreateToFromAirportTripManagement2
Feature: Port Trip Management - Create To From Airport Trip 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Create To/from Airport Trip with disabled Destination Hub in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator verifies "destination facility" with value "{hub-disable-name}" is not shown on Create Airport Trip Port Trip Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | {KEY_LIST_OF_CREATED_DRIVERS[1].username}  |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @DeleteCreatedPorts @DeleteDriverV2
  Scenario: Create To/from Airport Trip with disabled Origin Hub in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator verifies "origin facility" with value "{hub-disable-name}" is not shown on Create Airport Trip Port Trip Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | {KEY_LIST_OF_CREATED_DRIVERS[1].username}  |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @DeleteCreatedPorts
  Scenario: Create To/from Airport Trip with Flight Departure Date before today in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    Then Operator verifies past date picker "{gradle-previous-1-day-yyyy-MM-dd}" is disable on "Create Airport Trip" Port Trip Management page
    And Operator verifies Submit button is disable on Create Airport Trip Port Trip Management page

  @DeleteCreatedPorts
  Scenario: Create To/from Airport Trip without Assign Driver in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}             |
      | drivers             | -                                          |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {KEY_LIST_OF_CREATED_HUBS[1].name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @DeleteCreatedPorts
  Scenario: Create To/from Airport Trip with Remove the filled value in the mandatory field in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator fill new airport trip on Create Airport Trip Port Trip Management page using data below:
      | originFacility | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
    And Operator removes text of "Origin Facility" field on "Create Airport Trip" Port Trip Management page
    Then Operator verifies Mandatory require error message of "Origin Facility" field on "Create Airport Trip" Port Trip Management page
    And Operator verifies Submit button is disable on Create Airport Trip Port Trip Management page

  @DeleteCreatedPorts
  Scenario: Create To/from Airport Trip with Same Origin and Destination in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
    And API Operator assign these hubs as created hubs
      | hubIds | {local-hub-3-id} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator fill new airport trip on Create Airport Trip Port Trip Management page using data below:
      | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verifies same hub error messages on "Create Airport Trip" Port Trip Management page
    And Operator verifies Submit button is disable on Create Airport Trip Port Trip Management page

  @DeleteCreatedPorts
  Scenario: Create To/from Airport Trip with zero duration time in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    And API MM - Operator refreshes "Airport" cache
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
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator fill new airport trip on Create Airport Trip Port Trip Management page using data below:
      | durationminutes | 00 |
      | durationhour    | 00 |
    Then Operator verifies duration time error messages on "Create Airport Trip" Port Trip Management page
    And Operator verifies Submit button is disable on Create Airport Trip Port Trip Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op