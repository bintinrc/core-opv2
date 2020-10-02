@OperatorV2 @Core @Shippers @Sales
Feature: Sales

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Download Sample CSV File for Sales Person Creation on Sales Page (uid:3af61552-4ca9-4246-ba7a-1be3dc528dbc)
    Given Operator go to menu Shipper -> Sales
    When Operator download sample CSV file for "Sales Person Creation" on Sales page
    Then Operator verify sample CSV file for "Sales Person Creation" on Sales page is downloaded successfully

  @DeleteSalesPerson
  Scenario: Operator Successfully Creates Multiple Sales Persons by Uploading CSV Contains Multiple Sales Person on Sales Page (uid:bcbfc882-3e1e-4423-b9d8-3c8ad973c204)
    Given Operator go to menu Shipper -> Sales
    When Operator upload CSV contains multiple Sales Persons on Sales page using data below:
      | numberOfSalesPerson | 2 |
    When Operator refresh page
    Then Operator verifies all Sales Persons created successfully

  @DeleteSalesPerson
  Scenario: Operator Verifies All filters on Sales Page Works Fine (uid:550e3406-2ed8-4c41-9ffb-f73e4307384c)
    Given Operator go to menu Shipper -> Sales
    When Operator upload CSV contains multiple Sales Persons on Sales page using data below:
      | numberOfSalesPerson | 1 |
    When Operator refresh page
    Then Operator verifies all Sales Persons created successfully
    Then Operator verifies all filters on Sales page works fine

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
