@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AirportSearchTrip1
Feature: Airport Trip Management - Search Airport Trip 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search by Destination Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {default-origin-destination-hub-airport-trip} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
      | originOrDestination | {default-origin-destination-hub-airport-trip-filter} |
    And Operator search the "Destination Facility" column
    And Verify only filtered results are displayed

  Scenario: Search by Trip Id
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-10-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {default-origin-destination-hub-airport-trip} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
      | originOrDestination | {default-origin-destination-hub-airport-trip-filter} |
    And Operator search the "Trip ID" column
    And Verify only filtered results are displayed

  Scenario: Search by Origin Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-10-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {default-origin-destination-hub-airport-trip} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
      | originOrDestination | {default-origin-destination-hub-airport-trip-filter} |
    And Operator search the "Origin Facility" column
    And Verify only filtered results are displayed

  Scenario: Search by Departure Date Time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-10-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {default-origin-destination-hub-airport-trip} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
      | originOrDestination | {default-origin-destination-hub-airport-trip-filter} |
    And Operator search the "Departure Date Time" column
    And Verify only filtered results are displayed

  Scenario: Search by Duration
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-10-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {default-origin-destination-hub-airport-trip} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
      | originOrDestination | {default-origin-destination-hub-airport-trip-filter} |
    And Operator search the "Duration" column
    And Verify only filtered results are displayed

  Scenario: Search by Flight Number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-10-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {default-origin-destination-hub-airport-trip} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
      | originOrDestination | {default-origin-destination-hub-airport-trip-filter} |
    And Operator search the "Flight Number" column
    And Verify only filtered results are displayed

  Scenario: Search by Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-10-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {default-origin-destination-hub-airport-trip} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
      | originOrDestination | {default-origin-destination-hub-airport-trip-filter} |
    And Operator search the "Driver" column
    And Verify only filtered results are displayed

  Scenario: Search by Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-10-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {default-origin-destination-hub-airport-trip} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
      | originOrDestination | {default-origin-destination-hub-airport-trip-filter} |
    And Operator search the "Status" column
    And Verify only filtered results are displayed

  Scenario: Search by Comments
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | {gradle-previous-10-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | {default-origin-destination-hub-airport-trip} |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate  | {gradle-previous-15-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}      |
      | originOrDestination | {default-origin-destination-hub-airport-trip-filter} |
    And Operator search the "Comments" column
    And Verify only filtered results are displayed

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
