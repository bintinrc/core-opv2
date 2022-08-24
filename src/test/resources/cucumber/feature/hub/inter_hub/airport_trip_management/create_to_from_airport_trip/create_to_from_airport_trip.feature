@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AirportLoadTrip
Feature: Airport Trip Management - Load Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder
  Scenario: Create To/from Airport Trip without Assign Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D+0    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | CDG (Airport);    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D+0               |
      | endDate               | D+1               |
      | originOrDestination   | CDG (Airport)     |
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | CDG (Airport)           |
      | destinationFacility | AA-SG-01 (Warehouse)    |
      | departureTime       | 12:00                   |
      | durationhour        | 01                      |
      | durationminutes     | 55                      |
      | departureDate       | D+1                     |
      | drivers             | -                       |
      | comments            | Created by Automation   |
    And Verify the new airport trip "from CDG (Airport) to AA-SG-01 (Warehouse) is created. View Details" created success message

  @ForceSuccessOrder @DeleteDriver
  Scenario: Create To/from Airport Trip with Assign Single Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D+0    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | CDG (Airport);    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D+0               |
      | endDate               | D+1               |
      | originOrDestination   | CDG (Airport)     |
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | CDG (Airport)           |
      | destinationFacility | AA-SG-01 (Warehouse)    |
      | departureTime       | 12:00                   |
      | durationhour        | 01                      |
      | durationminutes     | 55                      |
      | departureDate       | D+1                     |
      | drivers             | {KEY_LIST_OF_CREATED_DRIVERS[1].username}                       |
      | comments            | Created by Automation   |
    And Verify the new airport trip "from CDG (Airport) to AA-SG-01 (Warehouse) is created. View Details" created success message

  @ForceSuccessOrder @DeleteDriver
  Scenario: Create To/from Airport Trip with Assign Multiple Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D+0    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | CDG (Airport);    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D+0               |
      | endDate               | D+1               |
      | originOrDestination   | CDG (Airport)     |
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | CDG (Airport)           |
      | destinationFacility | AA-SG-01 (Warehouse)    |
      | departureTime       | 12:00                   |
      | durationhour        | 01                      |
      | durationminutes     | 55                      |
      | departureDate       | D+1                     |
      | drivers             | {KEY_LIST_OF_CREATED_DRIVERS[1].username};{KEY_LIST_OF_CREATED_DRIVERS[2].username}                       |
      | comments            | Created by Automation   |
    And Verify the new airport trip "from CDG (Airport) to AA-SG-01 (Warehouse) is created. View Details" created success message

  @ForceSuccessOrder @DeleteDriver
  Scenario: Create To/from Airport Trip with Assign Four Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create 4 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D+0    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | CDG (Airport);    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D+0               |
      | endDate               | D+1               |
      | originOrDestination   | CDG (Airport)     |
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | CDG (Airport)           |
      | destinationFacility | AA-SG-01 (Warehouse)    |
      | departureTime       | 12:00                   |
      | durationhour        | 01                      |
      | durationminutes     | 55                      |
      | departureDate       | D+1                     |
      | drivers             | {KEY_LIST_OF_CREATED_DRIVERS[1].username};{KEY_LIST_OF_CREATED_DRIVERS[2].username};{KEY_LIST_OF_CREATED_DRIVERS[3].username};{KEY_LIST_OF_CREATED_DRIVERS[4].username}                       |
      | comments            | Created by Automation   |
    And Verify the new airport trip "from CDG (Airport) to AA-SG-01 (Warehouse) is created. View Details" created success message

  @ForceSuccessOrder @DeleteDriver
  Scenario: Create To/from Airport Trip with Assign >4 Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create 5 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D+0    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | CDG (Airport);    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D+0               |
      | endDate               | D+1               |
      | originOrDestination   | CDG (Airport)     |
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | CDG (Airport)           |
      | destinationFacility | AA-SG-01 (Warehouse)    |
      | departureTime       | 12:00                   |
      | durationhour        | 01                      |
      | durationminutes     | 55                      |
      | departureDate       | D+1                     |
      | drivers             | {KEY_LIST_OF_CREATED_DRIVERS[1].username};{KEY_LIST_OF_CREATED_DRIVERS[2].username};{KEY_LIST_OF_CREATED_DRIVERS[3].username};{KEY_LIST_OF_CREATED_DRIVERS[4].username};{KEY_LIST_OF_CREATED_DRIVERS[5].username} |
      | comments            | Created by Automation   |
    And Verify the new airport trip "from CDG (Airport) to AA-SG-01 (Warehouse) is created. View Details" created success message

  @ForceSuccessOrder
  Scenario: Create To/from Airport Trip with Assign Expired License Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D+0    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | CDG (Airport);    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D+0               |
      | endDate               | D+1               |
      | originOrDestination   | CDG (Airport)     |
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator verify "expired" license driver "{expired-driver-username}" is not displayed on Create Airport Trip page:
    And Operator create new airport trip using below data:
      | originFacility      | CDG (Airport)           |
      | destinationFacility | AA-SG-01 (Warehouse)    |
      | departureTime       | 12:00                   |
      | durationhour        | 01                      |
      | durationminutes     | 55                      |
      | departureDate       | D+1                     |
      | drivers             | -                       |
      | comments            | Created by Automation   |
    And Verify the new airport trip "from CDG (Airport) to AA-SG-01 (Warehouse) is created. View Details" created success message

  @ForceSuccessOrder
  Scenario: Create To/from Airport Trip with Assign Active and Inactive Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D+0    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | CDG (Airport);    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D+0               |
      | endDate               | D+1               |
      | originOrDestination   | CDG (Airport)     |
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator verify "inactive" license driver "{inactive-driver-username}" is not displayed on Create Airport Trip page:
    And Operator create new airport trip using below data:
      | originFacility      | CDG (Airport)           |
      | destinationFacility | AA-SG-01 (Warehouse)    |
      | departureTime       | 12:00                   |
      | durationhour        | 01                      |
      | durationminutes     | 55                      |
      | departureDate       | D+1                     |
      | drivers             | {KEY_LIST_OF_CREATED_DRIVERS[1].username} |
      | comments            | Created by Automation   |
    And Verify the new airport trip "from CDG (Airport) to AA-SG-01 (Warehouse) is created. View Details" created success message

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
