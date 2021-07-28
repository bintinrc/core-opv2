@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling

Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SHIPPER" Success Billing Report - Selected Shipper
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator selects Order Billing data as below
      | startDate | {gradle-current-date-yyyy-MM-dd} |
      | endDate   | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies "1 - Legacy SSB Template" is not available in template selector drop down menu
