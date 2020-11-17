@OperatorV2 @MiddleMile @Hub @PathManagement @ViewPath
Feature: Path Management - View Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View Auto Generated Path Details (uid:d0bbb16d-916d-43f9-a762-3872976900b0)
    Given Operator go to menu Shipper Support -> Blocked Dates


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op