@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AirportSearchTrip2
Feature: Airport Trip Management - Search Airport Trip 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: No Data Shown when Search by Destination Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {other-airport-name-1} (Airport);{other-airport-name-2} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    And Operator search the "Destination Facility" column with invalid data "INVALID" on Port Trip Management page
    And Operator verifies that no data appear on Port Trips page

  Scenario: No Data Shown when Search by Search by Trip ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {other-airport-name-1} (Airport);{other-airport-name-2} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    And Operator search the "Trip ID" column with invalid data "INVALID" on Port Trip Management page
    And Operator verifies that no data appear on Port Trips page

  Scenario: No Data Shown when Search by Origin Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {other-airport-name-1} (Airport);{other-airport-name-2} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    And Operator search the "Origin Facility" column with invalid data "INVALID" on Port Trip Management page
    And Operator verifies that no data appear on Port Trips page

  Scenario: No Data Shown when Search by Departure Date Time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {other-airport-name-1} (Airport);{other-airport-name-2} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    And Operator search the "Departure Date Time" column with invalid data "INVALID" on Port Trip Management page
    And Operator verifies that no data appear on Port Trips page

  Scenario: No Data Shown when Search by Duration
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {other-airport-name-1} (Airport);{other-airport-name-2} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    And Operator search the "Duration" column with invalid data "INVALID" on Port Trip Management page
    And Operator verifies that no data appear on Port Trips page

  Scenario: No Data Shown when Search by Flight Number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {other-airport-name-1} (Airport);{other-airport-name-2} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    And Operator search the "Flight Number" column with invalid data "INVALID" on Port Trip Management page
    And Operator verifies that no data appear on Port Trips page

  Scenario: No Data Shown when Search by Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {other-airport-name-1} (Airport);{other-airport-name-2} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    And Operator search the "Driver" column with invalid data "INVALID" on Port Trip Management page
    And Operator verifies that no data appear on Port Trips page

  Scenario: No Data Shown when Search by Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {other-airport-name-1} (Airport);{other-airport-name-2} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    And Operator search the "Status" column with invalid data "INVALID" on Port Trip Management page
    And Operator verifies that no data appear on Port Trips page

  Scenario: No Data Shown when Search by Comments
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {other-airport-name-1} (Airport);{other-airport-name-2} (Airport) |
    And Operator click on 'Load Trips' on Port Management
    And Operator search the "Comments" column with invalid data "INVALID" on Port Trip Management page
    And Operator verifies that no data appear on Port Trips page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
