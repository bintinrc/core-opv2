@OperatorV2 @OperatorV2Part1 @OrderBilling
Feature: Order Billing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to generate Success Billing
    Given Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings for data:
    | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
    | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
    | generateFile | Orders consolidated by shipper (1 file per shipper) |
    | emailAddress | qa@ninjavan.co                                      |
    Then Operator verifies attached CSV file in received email