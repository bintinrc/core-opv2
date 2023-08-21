@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling @LegacyTemplate

Feature: Generate Success Billing Report - Legacy Template

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  Scenario: Generate "SHIPPER" Success Billing Report - Selected Shipper - Use Legacy Template - start date > 1 May (uid:432a59ca-7248-4194-b906-14175d3ca5a9)
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator selects Order Billing data as below
      | startDate | {gradle-current-date-yyyy-MM-dd} |
      | endDate   | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies "1 - Legacy SSB Template" is not available in template selector drop down menu

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
