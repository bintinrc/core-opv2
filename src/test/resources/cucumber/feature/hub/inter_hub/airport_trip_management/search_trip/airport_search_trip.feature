@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AirportSearchTrip
Feature: Airport Trip Management - Load Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder
  Scenario: Search by Destination Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-20 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | D-20                         |
      | endDate             | D+1                          |
      | originOrDestination | CDG (Airport), ERC (Airport) |
    And Operator search the "Destination Facility" column
    And Verify only filtered results are displayed

  @ForceSuccessOrder
  Scenario: Search by Trip Id
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-10 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | D-10                         |
      | endDate             | D+1                          |
      | originOrDestination | CDG (Airport), ERC (Airport) |
    And Operator search the "Trip ID" column
    And Verify only filtered results are displayed

  @ForceSuccessOrder
  Scenario: Search by Origin Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-10 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | ABC (Airport);123 (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | D-10                         |
      | endDate             | D+1                          |
      | originOrDestination | ABC (Airport), 123 (Airport) |
    And Operator search the "Origin Facility" column
    And Verify only filtered results are displayed

  @ForceSuccessOrder
  Scenario: Search by Departure Date Time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-10 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | ABC (Airport);123 (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | D-10                         |
      | endDate             | D+1                          |
      | originOrDestination | ABC (Airport), 123 (Airport) |
    And Operator search the "Departure Date Time" column
    And Verify only filtered results are displayed

  @ForceSuccessOrder
  Scenario: Search by Duration
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-10 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | ABC (Airport);123 (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | D-10                         |
      | endDate             | D+1                          |
      | originOrDestination | ABC (Airport), 123 (Airport) |
    And Operator search the "Duration" column
    And Verify only filtered results are displayed

  @ForceSuccessOrder
  Scenario: Search by MAWB
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-10 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | ABC (Airport);123 (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | D-10                         |
      | endDate             | D+1                          |
      | originOrDestination | ABC (Airport), 123 (Airport) |
    And Operator search the "MAWB" column
    And Verify only filtered results are displayed

  @ForceSuccessOrder
  Scenario: Search by Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-10 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | ABC (Airport);123 (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | D-10                         |
      | endDate             | D+1                          |
      | originOrDestination | ABC (Airport), 123 (Airport) |
    And Operator search the "Driver" column
    And Verify only filtered results are displayed

  @ForceSuccessOrder
  Scenario: Search by Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-10 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | ABC (Airport);123 (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | D-10                         |
      | endDate             | D+1                          |
      | originOrDestination | ABC (Airport), 123 (Airport) |
    And Operator search the "Status" column
    And Verify only filtered results are displayed

  @ForceSuccessOrder
  Scenario: Search by Comments
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-10 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | ABC (Airport);123 (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | D-10                         |
      | endDate             | D+1                          |
      | originOrDestination | ABC (Airport), 123 (Airport) |
    And Operator search the "Comments" column
    And Verify only filtered results are displayed

  @ForceSuccessOrder
  Scenario: No Data Shown when Search by Destination Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-25 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Destination Facility" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @ForceSuccessOrder
  Scenario: No Data Shown when Search by Search by Trip ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-25 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Trip ID" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @ForceSuccessOrder
  Scenario: No Data Shown when Search by Origin Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-25 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Origin Facility" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @ForceSuccessOrder
  Scenario: No Data Shown when Search by Departure Date Time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-25 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Departure Date Time" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @ForceSuccessOrder
  Scenario: No Data Shown when Search by Duration
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-25 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Duration" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @ForceSuccessOrder
  Scenario: No Data Shown when Search by MAWB
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-25 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "MAWB" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @ForceSuccessOrder
  Scenario: No Data Shown when Search by Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-25 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Driver" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @ForceSuccessOrder
  Scenario: No Data Shown when Search by Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-25 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Status" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @ForceSuccessOrder
  Scenario: No Data Shown when Search by Comments
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | D-25 |
      | endDate   | D+1  |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination | CDG (Airport);ERC (Airport) |
    And Operator click on 'Load Trips' on Airport Management
    And Operator search the "Comments" column with invalid data "INVALID"
    And Operator verifies that no data appear on Airport Trips page

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
