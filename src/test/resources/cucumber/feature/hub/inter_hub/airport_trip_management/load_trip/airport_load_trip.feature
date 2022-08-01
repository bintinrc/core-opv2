@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AirportLoadTrip
Feature: Airport Trip Management - Load Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder
  Scenario: Load Air Haul Trip by Departure Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | D-15   |
      | endDate    | D+1    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D-15   |
      | endDate               | D+1    |
      | originOrDestination   | -      |

  @ForceSuccessOrder
  Scenario: Load Air Haul Trip by Departure Date and Origin Facilities
    Given Operator go to menu Shipper Support -> Blocked Dates
      Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D-1    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | ABC (Airport);123 (Airport)    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D-1                               |
      | endDate               | D+1                               |
      | originOrDestination   | ABC (Airport), 123 (Airport)      |

  @ForceSuccessOrder
  Scenario: Load Air Haul Trip by Departure Date and Destination Facilities
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D-1    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | CDG (Airport);ERC (Airport)    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D-1                               |
      | endDate               | D+1                               |
      | originOrDestination   | CDG (Airport), ERC (Airport)      |

  @ForceSuccessOrder
  Scenario: Load Air Haul Trip by Departure Date and 4 Origin/Destination Facilities
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D-1    |
      | endDate                | D+1    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | ABC (Airport);123 (Airport);CDG (Airport);ERC (Airport)    |
    And Verify operator cannot fill more than 4 Origin Or Destination for Airport Management
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D-1                               |
      | endDate               | D+1                               |
      | originOrDestination   | ABC (Airport), 123 (Airport), CDG (Airport), ERC (Airport)      |

  @ForceSuccessOrder
  Scenario: Load Air Haul Trip by 1 month range Departure Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate              | D+0     |
      | endDate                | D+30    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | ABC (Airport);123 (Airport);CDG (Airport);ERC (Airport)    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D+0                                |
      | endDate               | D+30                               |
      | originOrDestination   | ABC (Airport), 123 (Airport), CDG (Airport), ERC (Airport)      |


  @KillBrowser
  Scenario: Kill Browser
    Given no-op
