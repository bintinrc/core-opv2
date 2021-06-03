@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @LaunchBrowser @ShouldAlwaysRun @PricingScriptsV2 @SalesOps
Feature: Pricing Scripts V2

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Indonesia"

  @DeletePricingScript
  Scenario Outline: Create and Check Script with Send is_RTS - Use calculatePricing()- ID (<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | hasTemplate      | No                                                                                                                                                                                                                                      |
      | isCsvFile        | No                                                                                                                                                                                                                                      |
      | source           | function calculatePricing(params) {var result = {};result.delivery_fee = 1;if (params.is_rts === true) {if (params.from_metadata.l1_tier === "ID_A00007_01") {result.delivery_fee = 3;} else {result.delivery_fee = 5;}}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                    |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy          |
      | deliveryType | STANDARD        |
      | orderType    | NORMAL          |
      | timeslotType | NONE            |
      | isRts        | <is_RTS_toggle> |
      | size         | S               |
      | weight       | 1.0             |
      | insuredValue | 0.00            |
      | codValue     | 0.00            |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | <grandTotal>   |
      | gst          | <gst>          |
      | deliveryFee  | <deliveryFee>  |
      | insuranceFee | <insuranceFee> |
      | codFee       | <codFee>       |
      | handlingFee  | <handlingFee>  |
      | comments     | <comments>     |
    And Operator close page
    And Operator validate and release Draft Script
    Then Operator verify Draft Script is released successfully
    Examples:
      | Note        | is_RTS_toggle | grandTotal | gst  | deliveryFee | insuranceFee | codFee | handlingFee | comments | hiptest-uid                              |
      | RTS = True  | Yes           | 3.03       | 0.03 | 3           | 0            | 0      | 0           | OK       | uid:e5f7b563-c157-4152-a16a-83ea2f134d5f |
      | RTS = False | No            | 1.01       | 0.01 | 1           | 0            | 0      | 0           | OK       | uid:c8a30f4a-fd2a-46f7-9253-c0372e821ed7 |
