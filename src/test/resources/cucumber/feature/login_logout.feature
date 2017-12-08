@OperatorV2 @LoginLogout @ShouldAlwaysRun
Feature: op login and logout

  @LaunchBrowser
  Scenario: Launch Browser

  Scenario: op login into operator portal (uid:142de4e2-23e8-49da-8ad4-ec887b90f011)
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

  Scenario: op logout from operator portal (uid:b0997f2e-1db7-4088-a3b9-30c9e0fa1d0f)
    When logout button is clicked
    Then op back in the login page

  @KillBrowser
  Scenario: Kill Browser
