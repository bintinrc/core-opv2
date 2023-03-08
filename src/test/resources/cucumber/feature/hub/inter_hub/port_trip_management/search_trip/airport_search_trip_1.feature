@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AirportSearchTrip1
Feature: Airport Trip Management - Search Airport Trip 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip
  Scenario: Search by Destination Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | 12345                    |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {local-airport-2-code} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
      | originOrDestination | {local-airport-2-code} (Airport)      |
    And Operator search the "Destination Facility" column on Port Trip Management page
    And Verify only filtered results are displayed on Port Trip Management page

  @CancelTrip
  Scenario: Search by Trip Id
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | 12345                    |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {local-airport-2-code} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
      | originOrDestination | {local-airport-2-code} (Airport)      |
    And Operator search the "Trip ID" column on Port Trip Management page
    And Verify only filtered results are displayed on Port Trip Management page

  @CancelTrip
  Scenario: Search by Origin Facility
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | 12345                    |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {local-airport-2-code} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
      | originOrDestination | {local-airport-2-code} (Airport)      |
    And Operator search the "Origin Facility" column on Port Trip Management page
    And Verify only filtered results are displayed on Port Trip Management page

  @CancelTrip
  Scenario: Search by Departure Date Time
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | 12345                    |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {local-airport-2-code} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
      | originOrDestination | {local-airport-2-code} (Airport)      |
    And Operator search the "Departure Date Time" column on Port Trip Management page
    And Verify only filtered results are displayed on Port Trip Management page

  @CancelTrip
  Scenario: Search by Duration
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | 12345                    |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {local-airport-2-code} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
      | originOrDestination | {local-airport-2-code} (Airport)      |
    And Operator search the "Duration" column on Port Trip Management page
    And Verify only filtered results are displayed on Port Trip Management page

  @CancelTrip
  Scenario: Search by Flight Number
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | 12345                    |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {local-airport-2-code} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
      | originOrDestination | {local-airport-2-code} (Airport)      |
    And Operator search the "Trip ID" column on Port Trip Management page
    And Operator search the "Flight Number" column on Port Trip Management page
    And Verify only filtered results are displayed on Port Trip Management page

  @CancelTrip
  Scenario: Search by Driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | 12345                    |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {local-airport-2-code} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
      | originOrDestination | {local-airport-2-code} (Airport)      |
    And Operator search the "Driver" column on Port Trip Management page
    And Verify only filtered results are displayed on Port Trip Management page

  @CancelTrip
  Scenario: Search by Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | 12345                    |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {local-airport-2-code} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
      | originOrDestination | {local-airport-2-code} (Airport)      |
    And Operator search the "Status" column on Port Trip Management page
    And Verify only filtered results are displayed on Port Trip Management page

  @CancelTrip
  Scenario: Search by Comments
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API MM - Operator refreshes "Airport" cache
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | 12345                    |
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator fill the departure date for Port Management
      | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
    When Operator fill the Origin Or Destination for Port Management
      | originOrDestination | {local-airport-2-code} |
    And Operator click on 'Load Trips' on Port Management
    Then Verify the parameters of loaded trips in Port Management
      | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
      | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
      | originOrDestination | {local-airport-2-code} (Airport)      |
    And Operator search the "Comments" column on Port Trip Management page
    And Verify only filtered results are displayed on Port Trip Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
