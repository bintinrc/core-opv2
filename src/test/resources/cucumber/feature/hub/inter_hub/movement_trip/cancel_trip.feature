@MovementTrip @InterHub @Hub @MiddleMile
Feature: Cancel Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
