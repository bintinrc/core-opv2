@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @LaunchBrowser @ShouldAlwaysRun @PricingScriptsV2 @SalesOps
Feature: Service Type and Service Level params

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePricingScript
  Scenario: Create Script - Include service_type and service_level - Added Successfully (uid:2cff4b8b-c704-4679-9335-8c0e44edaeee)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | New      |
      | serviceLevel | STANDARD |
      | serviceType  | Parcel   |
      | timeslotType | NONE     |
      | isRts        | No       |
      | size         | S        |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
      | fromZone     | WEST     |
      | toZone       | EAST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 17.12 |
      | gst          | 1.12  |
      | deliveryFee  | 16    |
      | insuranceFee | 0     |
      | codFee       | 0     |
      | handlingFee  | 0     |
      | comments     | OK    |
    And Operator close page
    And Operator validate and release Draft Script
    Then Operator verify Draft Script is released successfully

  @DeletePricingScript
  Scenario: Create Script - Include service_type and service_level - Incorrect service_type (uid:454f1a82-3194-4112-9f47-56cc087e6a64)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "parcel") {result.delivery_fee += 3;}if (params.service_type == "MARKETPLACE") {result.delivery_fee += 5;}if (params.service_type == "return") {result.delivery_fee += 7;}if (params.service_type == "document") {result.delivery_fee += 11;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | New      |
      | serviceLevel | STANDARD |
      | serviceType  | Parcel   |
      | timeslotType | NONE     |
      | isRts        | No       |
      | size         | S        |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
      | fromZone     | WEST     |
      | toZone       | EAST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 13.91 |
      | gst          | 0.91  |
      | deliveryFee  | 13    |
      | insuranceFee | 0     |
      | codFee       | 0     |
      | handlingFee  | 0     |
      | comments     | OK    |
    And Operator close page
    And Operator validate and release Draft Script
    Then Operator verify Draft Script is released successfully

  @DeletePricingScript
  Scenario: Create Script - Include service_type and service_level - Incorrect service_level (uid:aa172bd5-4655-4239-9e65-e48ffff429b8)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_level == "standard") {result.delivery_fee += 13;}if (params.service_level == "express") {result.delivery_fee += 17;}if (params.service_level == "Sameday") {result.delivery_fee += 19;}if (params.service_level == "NextDay") {result.delivery_fee += 23;}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | New      |
      | serviceLevel | STANDARD |
      | serviceType  | Parcel   |
      | timeslotType | NONE     |
      | isRts        | No       |
      | size         | S        |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
      | fromZone     | WEST     |
      | toZone       | EAST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 3.21 |
      | gst          | 0.21 |
      | deliveryFee  | 3    |
      | insuranceFee | 0    |
      | codFee       | 0    |
      | handlingFee  | 0    |
      | comments     | OK   |
    And Operator close page
    And Operator validate and release Draft Script
    Then Operator verify Draft Script is released successfully