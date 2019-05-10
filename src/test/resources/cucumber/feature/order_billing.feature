@OperatorV2 @OperatorV2Part1 @OrderBilling
Feature: Order Billing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to generate Success Billing
    Given Operator go to menu Shipper Support -> Order Billing
    When Operator selects start date = "{gradle-current-date-yyyy-MM-dd}" and end date = "{gradle-current-date-yyyy-MM-dd}"
    And Operator ticks "Orders consolidated by shipper (1 file per shipper)" checkbox
    And Operator fills "Email Address" field with "qa@ninjavan.co"
    And Operator clicks "Generate Success Billing" button
    Then Operator verifies attached CSV file in received email