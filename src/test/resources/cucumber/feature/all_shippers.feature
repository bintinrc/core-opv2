@OperatorV2 @AllShippers
Feature: All Shippers

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create new Shipper V4
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper V4

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
