@FirstMile @FirstMileZone
Feature: First Mile Zone

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

@Debug
  Scenario: Success Assign Driver Zone
    When Operator loads First Mile Zone Page
    And  Operator waits for 30 seconds
    When Operator creates first mile zone using "JKB" hub
    And  Operator clicks on the "Edit Driver Zones" button on First Mile Zone Page
    And  Operator verifies the Table on Edit Driver Zone Modal
    And  Operator search for hub on Edit Driver Zone Modal

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op