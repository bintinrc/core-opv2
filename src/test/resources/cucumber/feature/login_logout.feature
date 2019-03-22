@OperatorV2Disabled @OperatorV2Part1Disabled @LoginLogout @ShouldAlwaysRun
Feature: Login and Logout

  @LaunchBrowser
  Scenario: Launch Browser
    Given no-op

  Scenario: Operator login into operator portal (uid:142de4e2-23e8-49da-8ad4-ec887b90f011)
    Given Operator is in Operator Portal V2 login page
    When Operator click login button
    When Operator login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then Operator verify he is in main page

  Scenario: Operator logout from operator portal (uid:b0997f2e-1db7-4088-a3b9-30c9e0fa1d0f)
    When Operator click logout button
    Then Operator back in the login page

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
