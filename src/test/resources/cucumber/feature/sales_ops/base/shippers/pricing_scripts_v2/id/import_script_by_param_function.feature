@OperatorV2 @LaunchBrowser @PricingScriptsV2ID @SalesOpsID
Feature: Import Script ByParam Function

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Indonesia"

  @DeletePricingScript
  Scenario: Create Script with importScriptByParams (uid:0487bb08-5069-44f3-9c81-88728f3d6d26)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;var codValue = params.cod_value \|\| 0;var insuredValue = params.insured_value \|\| 0;var zones = {from: params.from_metadata.l1_tier,to: params.to_metadata.l2_tier};var deliveryType = params.delivery_type;var orderType = params.order_type;var weight = params.weight;if (codValue != 0) {result.cod_fee = util.takeGreatestOf(codValue, 3, 5000)}if (insuredValue != 0) {result.insurance_fee = util.takeGreatestOf(insuredValue, 0.25, 2500)}var record = undefined;if (orderType == "NORMAL" \|\| orderType == "C2C") {try {record = util.newZones.findRecord(deliveryType, zones)} catch (e) {deliveryType = "STANDARD";record = util.newZones.findRecord(deliveryType, zones)}} else if (orderType == "RETURN") {record = util.newZones.findRecord("STANDARD", zones)} else {throw "Unknown order type " + orderType}var roundedWeight = util.roundUp(weight);if (roundedWeight <= 2 && record.firstTwoKg != undefined) {result.delivery_fee += record.firstTwoKg} else {result.delivery_fee += roundedWeight * record.perKg}if (deliveryType == "STANDARD" \|\| deliveryType == "EXPRESS" \|\| deliveryType == "NEXT_DAY") {result.delivery_fee = result.delivery_fee}if (deliveryType == "SAME_DAY") {result.delivery_fee = record.flatRate}if (orderType == "RETURN") {result.delivery_fee += 5000}return result;}function importScriptByParams(params){return 70331;} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy   |
      | deliveryType | STANDARD |
      | orderType    | NORMAL   |
      | timeslotType | NONE     |
      | isRts        | No       |
      | size         | S        |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 9595 |
      | gst          | 95   |
      | deliveryFee  | 9500 |
      | insuranceFee | 0    |
      | codFee       | 0    |
      | handlingFee  | 0    |
      | comments     | OK   |
    And Operator close page
    And Operator validate and release Draft Script
    Then Operator verify the script is saved successfully

  @DeletePricingScript
  Scenario: Create Script with importScriptByParams include the input params logic (uid:032b15f5-8b26-41f2-b0af-fa78d9245d1b)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;var codValue = params.cod_value \|\| 0;var insuredValue = params.insured_value \|\| 0;var zones = {from: params.from_metadata.l1_tier,to: params.to_metadata.l2_tier};var deliveryType = params.delivery_type;var orderType = params.order_type;var weight = params.weight;if (codValue != 0) {result.cod_fee = util.takeGreatestOf(codValue, 3, 5000)}if (insuredValue != 0) {result.insurance_fee = util.takeGreatestOf(insuredValue, 0.25, 2500)}var record = undefined;if (orderType == "NORMAL" \|\| orderType == "C2C") {try {record = util.zones.findRecord(deliveryType, zones)} catch (e) {deliveryType = "STANDARD";record = util.zones.findRecord(deliveryType, zones)}}else if (orderType == "RETURN") {record = util.zones.findRecord("STANDARD", zones)} else {throw "Unknown order type " + orderType}var roundedWeight = util.roundUp(weight);if (roundedWeight <= 2 && record.firstTwoKg != undefined) {result.delivery_fee += record.firstTwoKg} else {result.delivery_fee += roundedWeight * record.perKg}if (deliveryType == "NEXT_DAY" \|\| deliveryType == "SAME_DAY") {if (roundedWeight <= 3) {result.delivery_fee = record.flatRate} else {result.delivery_fee = 2 * record.flatRate}}if (orderType == "RETURN") {result.delivery_fee += 5000}return result;}function importScriptByParams(params) {if (params.delivery_type == "EXPRESS") {return 70811;} else {return 70278;}} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify the script is saved successfully

  @DeletePricingScript
  Scenario: Create Script with importScriptByParams and importScript (uid:90c1b136-7d06-4f9c-8fcf-87854237895f)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;var codValue = params.cod_value \|\| 0;var insuredValue = params.insured_value \|\| 0;var zones = {from: params.from_metadata.l1_tier,to: params.to_metadata.l2_tier};var deliveryType = params.delivery_type;var orderType = params.order_type;var weight = params.weight;if (codValue != 0) {result.cod_fee = util.takeGreatestOf(codValue, 3, 5000)}if (insuredValue != 0) {result.insurance_fee = util.takeGreatestOf(insuredValue, 0.25, 2500)}var record = undefined;if (orderType == "NORMAL" \|\| orderType == "C2C") {try {record = util.zones.findRecord(deliveryType, zones)} catch (e) {deliveryType = "STANDARD";record = util.zones.findRecord(deliveryType, zones)}}else if (orderType == "RETURN") {record = util.zones.findRecord("STANDARD", zones)} else {throw "Unknown order type " + orderType}var roundedWeight = util.roundUp(weight);if (roundedWeight <= 2 && record.firstTwoKg != undefined) {result.delivery_fee += record.firstTwoKg}else {result.delivery_fee += roundedWeight * record.perKg}if (deliveryType == "NEXT_DAY" \|\| deliveryType == "SAME_DAY") {if (roundedWeight <= 3) {result.delivery_fee = record.flatRate} else {result.delivery_fee = 2 * record.flatRate}}if (orderType == "RETURN") {result.delivery_fee += 5000}return result;} importScript(70278); function importScriptByParams(params){if (params.delivery_type == "EXPRESS") {return 70811;}return 0;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify the script is saved successfully

  @DeletePricingScript
  Scenario: Create Script with importScript (uid:7d63a996-1129-4d82-910f-b112a186b8ad)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;var codValue = params.cod_value \|\| 0;var insuredValue = params.insured_value \|\| 0;var zones = {from: params.from_metadata.l1_tier,to: params.to_metadata.l2_tier};var orderType = params.order_type;var deliveryType = params.delivery_type;var weight = params.weight;if (insuredValue != 0) {result.insurance_fee = util.takeGreatestOf(insuredValue, 0.4, 3000)}var record = undefined;if (orderType == "NORMAL" \|\| orderType == "C2C") {try {record = util.newZones.findRecord(deliveryType, zones)} catch (e) {deliveryType = "STANDARD";record = util.newZones.findRecord(deliveryType, zones)}} else if (orderType == "RETURN") {record = util.newZones.findRecord("STANDARD", zones)} else {throw "Unknown order type " + orderType}var roundedWeight = util.roundUp(weight);if (roundedWeight <= 2 && record.firstTwoKg != undefined) {result.delivery_fee += record.firstTwoKg} else {weight_fee = record.perKg * 0.9;weight_fee = 500 * Math.round(weight_fee / 500);result.delivery_fee += weight_fee * roundedWeight;}return result;}importScript(70331) |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify the script is saved successfully