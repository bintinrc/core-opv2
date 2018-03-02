@OperatorV2 @AllShippers
Feature: All Shippers

  @LaunchBrowser @EnableClearCache @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create new Shipper V4
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper V4 using data below:
      | pricingScriptName | {pricing-script-name} |
      | industryName      | {industry-name}       |
      | salesPerson       | {sales-person}        |
    Then Operator verify the new Shipper V4 is created successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
