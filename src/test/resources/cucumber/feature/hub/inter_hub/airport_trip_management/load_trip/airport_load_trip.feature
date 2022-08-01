@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AirportLoadTrip
Feature: Airport Trip Management - Load Trip

  @1 @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @1 @DeleteShipment @ForceSuccessOrder
  Scenario: Load Air Haul Trip by Departure Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate  | D-1    |
      | endDate    | D+1    |
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate             | D-1    |
      | endDate               | D+1    |
      | origiOrDestination    | -      |


  @KillBrowser
  Scenario: Kill Browser
    Given no-op
