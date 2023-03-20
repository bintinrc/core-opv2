@SG @NinjaChat @batool
Feature: Opv2 Notifications Management Scenarios

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: OPV2 - Login
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: opv2 - Search template id
    Given Operator go to menu Mass Communications -> Notifications Management
#    Then Operator searches and verifies the template id "10"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op