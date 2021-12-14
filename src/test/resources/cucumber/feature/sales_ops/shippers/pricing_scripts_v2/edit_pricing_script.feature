@OperatorV2 @LaunchBrowser @PricingScriptsV2 @SalesOps @EditPricingScript
Feature: Edit Pricing Script

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePricingScript
  Scenario: Edit and Check Script - Legacy Order Fields - NORMAL, STANDARD (uid:f0be1f72-282c-4b41-9286-a4fd4100d449)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.order_type == "NORMAL") {result.delivery_fee += 1.1;}if (params.order_type == "RETURN") {result.delivery_fee += 2.2;}if (params.order_type == "C2C") {result.delivery_fee += 3.3;}if (params.order_type == "CASH") {result.delivery_fee += 9.9;}if (params.delivery_type == "STANDARD") {result.delivery_fee += 5.5;}if (params.delivery_type == "EXPRESS") {result.delivery_fee += 6.6;}if (params.delivery_type == "SAME_DAY") {result.delivery_fee += 7.7;}if (params.delivery_type == "NEXT_DAY") {result.delivery_fee += 8.8;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator edit the created Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.order_type == "NORMAL") {result.delivery_fee += 10.1;}if (params.order_type == "RETURN") {result.delivery_fee += 2.2;}if (params.order_type == "C2C") {result.delivery_fee += 3.3;}if (params.order_type == "CASH") {result.delivery_fee += 9.9;}if (params.delivery_type == "STANDARD") {result.delivery_fee += 5.5;}if (params.delivery_type == "EXPRESS") {result.delivery_fee += 6.6;}if (params.delivery_type == "SAME_DAY") {result.delivery_fee += 7.7;}if (params.delivery_type == "NEXT_DAY") {result.delivery_fee += 8.8;}return result;} |
    When Operator search according Active Script name
    When Operator do Run Check on specific Active Script using this data below:
      | orderFields  | Legacy   |
      | deliveryType | STANDARD |
      | orderType    | NORMAL   |
      | timeslotType | NONE     |
      | isRts        | No       |
      | size         | XS       |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
      | fromZone     | EAST     |
      | toZone       | WEST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 16.692 |
      | gst          | 1.092  |
      | deliveryFee  | 15.6   |
      | insuranceFee | 0      |
      | codFee       | 0      |
      | handlingFee  | 0      |
      | comments     | OK     |
    And Operator close page
    Then Operator verify the script is saved successfully

  @DeletePricingScript
  Scenario: Edit and Check Script - New Order Fields - Document, SAMEDAY (uid:961bb5af-09b9-4e55-a7a6-ad84f486ee7b)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator edit the created Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 21;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
    When Operator search according Active Script name
    When Operator do Run Check on specific Active Script using this data below:
      | orderFields  | New      |
      | serviceLevel | SAMEDAY  |
      | serviceType  | Document |
      | timeslotType | NONE     |
      | isRts        | No       |
      | size         | XS       |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
      | fromZone     | EAST     |
      | toZone       | WEST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 42.8 |
      | gst          | 2.8  |
      | deliveryFee  | 40   |
      | insuranceFee | 0    |
      | codFee       | 0    |
      | handlingFee  | 0    |
      | comments     | OK   |
    And Operator close page
    Then Operator verify the script is saved successfully

  @DeletePricingScript
  Scenario Outline: Edit and Check Script - Send is_RTS - Use calculate() - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 1;if (params.is_rts === true) {if (params.from_metadata.l1_tier === "ID_A00007_01") {result.delivery_fee = 3;} else if (params.from_metadata.l1_tier === "ID_A00002_01") {result.delivery_fee = 8.5;} else {result.delivery_fee = 5 * params.weight;}}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator edit the created Draft Script using data below:
      | source | function calculate(delivery_type,timeslot_type,order_type,size,weight,is_rts) {var result = {};result.delivery_fee = 2;if (is_rts === true) {result.delivery_fee += 4} else if (is_rts === false) {result.delivery_fee += 6;}return result;} |
    When Operator search according Active Script name
    When Operator do Run Check on specific Active Script using this data below:
      | orderFields  | Legacy   |
      | deliveryType | STANDARD |
      | orderType    | NORMAL   |
      | timeslotType | NONE     |
      | isRts        | <is_RTS> |
      | size         | XS       |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
      | fromZone     | EAST     |
      | toZone       | WEST     |
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
      | RTS = True   | RTS = True  | Yes    | 2.14       | 0.14 | 2           | uid:e3973b32-ee9c-4cc7-8f42-f3da2f406e65 |
      | RTS = False  | RTS = False | No     | 2.14       | 0.14 | 2           | uid:248ad447-09b5-4c52-9524-53b643c72b2e |

  @DeletePricingScript @HappyPath
  Scenario: Edit Active Script - No Syntax Error (uid:5256ee16-eda2-4963-a7c9-a129845f6b3d)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    When Operator search according Active Script name
    And Operator edit the created Active Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 1;if (params.is_rts === true) {result.delivery_fee = 5;} else {result.delivery_fee = 3;}if (params.size == "S") {result.delivery_fee += 2.1;} else if (params.size == "M") {result.delivery_fee += 2.2;} else if (params.size == "L") {result.delivery_fee += 3.3;} else if (params.size == "XL") {result.delivery_fee += 4.4;} else if (params.size == "XXL") {result.delivery_fee += 5.5;} else {throw "Unknown size.";}if (params.weight <= 3) {result.delivery_fee += 6.6} else if (params.weight > 3) {result.delivery_fee += 7.7}return result;} |
    Then Operator verify the script is saved successfully

  @DeletePricingScript
  Scenario: Edit Active Script - Syntax Error (uid:9bc0c4db-992e-4522-b160-520116366a04)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    When Operator search according Active Script name
    And Operator edit the created Active Script using data below:
      | source | function calculatePricing(params) {var price = 3.0;var result = {};result.delivery_fee = price;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;return result; |
    Then Operator verify error message in header with "SyntaxError"

  @DeletePricingScript @HappyPath
  Scenario: Edit Draft Script - No Syntax Error (uid:df962b1b-5b1c-453f-bbae-a7e3d1893f8f)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator edit the created Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 1;if (params.is_rts === true) {result.delivery_fee = 5;} else {result.delivery_fee = 3;}if (params.size == "S") {result.delivery_fee += 2.1;} else if (params.size == "M") {result.delivery_fee += 2.2;} else if (params.size == "L") {result.delivery_fee += 3.3;} else if (params.size == "XL") {result.delivery_fee += 4.4;} else if (params.size == "XXL") {result.delivery_fee += 5.5;} else {throw "Unknown size.";}if (params.weight <= 3) {result.delivery_fee += 6.6} else if (params.weight > 3) {result.delivery_fee += 7.7}return result;} |
    Then Operator verify the script is saved successfully

  @DeletePricingScript
  Scenario: Edit Draft Script - Syntax Error (uid:4daf468e-2dc4-46cf-9a5e-2b0bda48668e)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator edit the created Draft Script using data below:
      | source | function calculatePricing(params) {var price = 3.0;var result = {};result.delivery_fee = price;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;return result; |
    Then Operator verify error message in header with "SyntaxError"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op