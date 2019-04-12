@OperatorV2 @OperatorV2Part1 @Sales
Feature: Sales

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator download sample CSV file for "Sales Person Creation" on Sales page (uid:b3757347-5768-4ac8-8bda-b55d9a849d2d)
    Given Operator go to menu Shipper -> Sales
    When Operator download sample CSV file for "Sales Person Creation" on Sales page
    Then Operator verify sample CSV file for "Sales Person Creation" on Sales page is downloaded successfully

  @DeleteSalesPerson
  Scenario: Operator successfully creates multiple Sales Persons by uploading CSV contains multiple Sales Person on Sales page (uid:cb2f9698-2a87-485d-bf37-5f9e62e30f76)
    Given Operator go to menu Shipper -> Sales
    When Operator upload CSV contains multiple Sales Persons on Sales page using data below:
      | numberOfSalesPerson | 2 |
    When Operator refresh page
    Then Operator verifies all Sales Persons created successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
