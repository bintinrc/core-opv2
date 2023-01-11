@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AirportSearchTrip2
Feature: Airport Trip Management - Search Airport Trip 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: No Data Shown when Search by Destination Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Destination Facility" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  Scenario: No Data Shown when Search by Search by Trip ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Trip ID" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  Scenario: No Data Shown when Search by Origin Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Origin Facility" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  Scenario: No Data Shown when Search by Departure Date Time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Departure Date Time" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  Scenario: No Data Shown when Search by Duration
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Duration" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  Scenario: No Data Shown when Search by Flight Number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-10-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Flight Number" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  Scenario: No Data Shown when Search by Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Driver" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  Scenario: No Data Shown when Search by Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Status" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  Scenario: No Data Shown when Search by Comments
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Comments" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
