@FirstMile @FirstMileZone
Feature: First Mile Zone

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

@Debug
  Scenario: Success Assign Driver Zone
    When Operator loads First Mile Zone Page
    When Operator creates first mile zone using "JKB" hub
    And  Operator clicks on the "Edit Driver Zones" button on First Mile Zone Page
    And  Operator verifies the Table on Edit Driver Zone Modal
    And  Operator search for hub on Edit Driver Zone Modal
    When Operator search for zone on Edit Driver Zone Modal
    And  Operator verifies the Table of Zone on Edit Driver Zone Modal
    And  Operator search for driver on Edit Driver Zone Modal
    And  Operator clicks on the save changes button on First Mile Zone Page
    And  Operator verify success message toast is displayed


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op