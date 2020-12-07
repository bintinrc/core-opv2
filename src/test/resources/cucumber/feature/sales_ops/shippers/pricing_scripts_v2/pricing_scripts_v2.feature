@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @LaunchBrowser @ShouldAlwaysRun @PricingScriptsV2 @SalesOps

Feature: Pricing Scripts V2

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePricingScript
  Scenario: Link Script to Shipper (uid:8c623eef-fb54-4a8b-bcf1-a182eba43bf7)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params) { var result = {}; var deliveryFee = 0.0; deliveryFee += getFeeOrderType(params.order_type); result.delivery_fee = deliveryFee; return result; } function getFeeOrderType(order_type) { switch (order_type) {case "NORMAL": return 2; case "RETURN": return 3; case "C2C": return 5; case "CASH": return 8; } } |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type                                                                                                                                                                                                                                                                        |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator validate and release Draft Script using this data below:
      | startWeight | 1.0 |
      | endWeight   | 2.0 |
    And Operator refresh page
    Then Operator verify Draft Script is released successfully
    When Operator link Script to Shipper with ID = "{shipper-v4-dummy-script-legacy-id}"
    And Operator refresh page
    Then Operator verify the Script is linked successfully