@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @LaunchBrowser @ShouldAlwaysRun @PricingScriptsV2ID @SalesOpsID
Feature: Edit Pricing Script

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Indonesia"

  @DeletePricingScript
  Scenario Outline: Edit and Check Script - Send is_RTS - Use calculatePricing() - ID - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 1;if (params.is_rts === true) {if (params.from_metadata.l1_tier === "ID_A00007_01") {result.delivery_fee = 3;} else if (params.from_metadata.l1_tier === "ID_A00002_01") {result.delivery_fee = 8.5;} else {result.delivery_fee = 5 * params.weight;}}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator edit the created Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 1;if (params.is_rts === true) {if (params.from_metadata.l1_tier === "ID_A00007_01") {result.delivery_fee = 3;} else if (params.from_metadata.l1_tier === "ID_A00002_01") {result.delivery_fee = 8.5;} else {result.delivery_fee = 10 * params.weight;}}return result; } |
    When Operator search according Active Script name
    When Operator do Run Check on specific Active Script using this data below:
      | orderFields  | Legacy   |
      | deliveryType | STANDARD |
      | orderType    | NORMAL   |
      | timeslotType | NONE     |
      | isRts        | <is_RTS> |
      | size         | S        |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | <grandTotal>  |
      | gst          | <gst>         |
      | deliveryFee  | <deliveryFee> |
      | insuranceFee | 0             |
      | codFee       | 0             |
      | handlingFee  | 0             |
      | comments     | OK            |
    And Operator close page
    Then Operator verify the script is saved successfully
    Examples:
      | dataset_name | Condition   | is_RTS | grandTotal | gst  | deliveryFee | hiptest-uid                              |
      | RTS = True   | RTS = True  | Yes    | 3.03       | 0.03 | 3           | uid:9a0afb0c-5805-44d0-bb48-332e592cb640 |
      | RTS = False  | RTS = False | No     | 1.01       | 0.01 | 1           | uid:5a604892-ac0d-4d2c-a5b8-27f55ee0e1e6 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op