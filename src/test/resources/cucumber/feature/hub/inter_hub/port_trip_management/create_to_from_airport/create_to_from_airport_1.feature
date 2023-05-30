@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @CreateToFromAirportTripManagement1
Feature: Port Trip Management - Create To From Airport Trip 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts @DeleteMiddleMileDriver @ForceCompleteCreatedMovementTrips
  Scenario: Create To/from Airport Trip with Assign > 4 Driver in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode}                                                                                                                                                                        |
      | destinationFacility | {local-hub-3-name}                                                                                                                                                                                |
      | departureTime       | 12:00                                                                                                                                                                                                             |
      | durationhour        | 01                                                                                                                                                                                                                |
      | durationminutes     | 55                                                                                                                                                                                                                |
      | departureDate       | {date: 1 days next, yyyy-MM-dd}                                                                                                                                                                                    |
      | drivers             | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username};{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username};{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[3].username};{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[4].username};{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[5].username} |
      | comments            | Created by Automation                                                                                                                                                                                             |
     And Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {local-hub-3-name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @exclude @DeleteCreatedPorts @DeleteMiddleMileDriver @ForceCompleteCreatedMovementTrips
  Scenario: Create To/from Airport Trip with Assign Active and Inactive Driver in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator verify "inactive" license driver "{inactive-driver-username}" is not displayed on Create Airport Trip page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {local-hub-3-name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {date: 1 days next, yyyy-MM-dd}             |
      | drivers             | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}  |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {local-hub-3-name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @exclude @DeleteCreatedPorts @DeleteMiddleMileDriver @ForceCompleteCreatedMovementTrips
  Scenario: Create To/from Airport Trip with Assign Expired Employment Driver in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator verify "expired" license driver "{inactive-driver-username}" is not displayed on Create Airport Trip page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {local-hub-3-name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {date: 1 days next, yyyy-MM-dd}             |
      | drivers             | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}  |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {local-hub-3-name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @exclude @DeleteCreatedPorts @DeleteMiddleMileDriver @ForceCompleteCreatedMovementTrips
  Scenario: Create To/from Airport Trip with Assign Expired License Driver in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator verify "expired" license driver "{expired-driver-username}" is not displayed on Create Airport Trip page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {local-hub-3-name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {date: 1 days next, yyyy-MM-dd}             |
      | drivers             | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}  |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {local-hub-3-name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @ForceCompleteCreatedMovementTrips
  Scenario: Create To/from Airport Trip with Assign Four Driver in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode}                                                                                                                              |
      | destinationFacility | {local-hub-3-name}                                                                                                                                      |
      | departureTime       | 12:00                                                                                                                                                                   |
      | durationhour        | 01                                                                                                                                                                      |
      | durationminutes     | 55                                                                                                                                                                      |
      | departureDate       | {date: 1 days next, yyyy-MM-dd}                                                                                                                                          |
      | drivers             | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username};{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username};{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[3].username};{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[4].username} |
      | comments            | Created by Automation                                                                                                                                                   |
    And Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {local-hub-3-name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @ForceCompleteCreatedMovementTrips
  Scenario: Create To/from Airport Trip with Assign Single Driver in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 0 days next, yyyy-MM-dd} |
      | endDate   | {date: 1 days next, yyyy-MM-dd} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 0 days next, yyyy-MM-dd}                       |
      | endDate             | {date: 1 days next, yyyy-MM-dd}                       |
      | originOrDestination | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) |
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | destinationFacility | {local-hub-3-name}         |
      | departureTime       | 12:00                                      |
      | durationhour        | 01                                         |
      | durationminutes     | 55                                         |
      | departureDate       | {date: 1 days next, yyyy-MM-dd}             |
      | drivers             | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}  |
      | comments            | Created by Automation                      |
    And Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {local-hub-3-name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @DeleteCreatedPorts @DeleteMiddleMileDriver @ForceCompleteCreatedMovementTrips
  Scenario: Create To/from Airport Trip with Assign Multiple Driver in Port Trip Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    And Operator click on 'Create Tofrom Airport Trip' button in Port Management page
    And Operator create new airport trip on Port Trip Management page using below data:
      | originFacility      | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode}                                          |
      | destinationFacility | {local-hub-3-name}                                                  |
      | departureTime       | 12:00                                                                               |
      | durationhour        | 01                                                                                  |
      | durationminutes     | 55                                                                                  |
      | departureDate       | {date: 1 days next, yyyy-MM-dd}                                                      |
      | drivers             | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username};{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
      | comments            | Created by Automation                                                               |
    And Verify the new airport trip "Trip {KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS[1].tripId} from {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} (Airport) to {local-hub-3-name} (Warehouse) is created. View Details" created success message on Port Trip Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op