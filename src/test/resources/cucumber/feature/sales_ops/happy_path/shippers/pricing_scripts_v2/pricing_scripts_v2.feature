@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @LaunchBrowser @ShouldAlwaysRun @PricingScriptsV2 @SalesOps @HappyPath

Feature: Pricing Scripts V2

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePricingScript
  Scenario: Link Script to Shipper (uid:7dbbe3ef-4742-4c9c-81f2-beee5d146b66)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) { var result = {}; var deliveryFee = 0.0; deliveryFee += getFeeOrderType(params.order_type); result.delivery_fee = deliveryFee; return result; } function getFeeOrderType(order_type) { switch (order_type) {case "NORMAL": return 2; case "RETURN": return 3; case "C2C": return 5; case "CASH": return 8; } } |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator validate and release Draft Script using this data below:
      | startWeight | 1.0 |
      | endWeight   | 2.0 |
    And Operator refresh page
    Then Operator verify the script is saved successfully
    When Operator link Script to Shipper with ID and Name = "{shipper-v4-dummy-script-legacy-id}-{shipper-v4-dummy-script-name}"
    And Operator refresh page
    Then Operator verify the Script is linked successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op