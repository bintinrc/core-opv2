@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AddNewAirport
Feature: Airport Trip Management - Load Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Add New Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | AAJ             |
      | airportName   | Test Airport    |
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"Test Airport\" has been created" created success message
    And Verify the newly created airport values in table






  @KillBrowser
  Scenario: Kill Browser
    Given no-op
