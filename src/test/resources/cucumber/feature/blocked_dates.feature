@OperatorV2 @OperatorV2Part1 @BlockedDates @Saas @ShouldAlwaysRun
Feature: Blocked Dates

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator add blocked date (uid:0877c2fd-f75e-4f90-96a8-8ce8da082009)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator adds Blocked Date
    Then Operator verifies new Blocked Date is added successfully

  Scenario: Operator remove blocked date (uid:e3fe4f5f-204f-40fc-be9e-770784af328b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator removes Blocked Date
    Then Operator verifies Blocked Date is removed successfully

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
