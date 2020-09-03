@05ChangeOperatingCountry
Feature: Change Operating Country
  A demo feature to change the operating country in the operator dashboard.

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Change Operating Country to Indonesia
    Given Operator changes the country to "Indonesia"
    Then Operator verify operating country is "Indonesia"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op