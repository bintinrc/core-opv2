@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @PricingScriptsV2
Feature: Time-Bounded Script

  @DeletePricingScript
  Scenario: Create Time-Bounded Script and Verify Time-Bounded Script is used by OC API - Active, No Syntax Error, Result not Null (uid:c91a4889-2cb7-4aa8-822a-5c64d4ea5502)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
    # This source exclude "insuranceFee" and "cod_value" and using simple result.
      | source           | function calculatePricing(params){var result={};result.delivery_fee=0.2;result.cod_fee=0.3;result.insurance_fee=0.5;result.handling_fee=0.7;return result} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator validate and release Draft Script using this data below:
      | startWeight | 1.0 |
      | endWeight   | 2.0 |
    Then Operator verify Draft Script is released successfully
    When Operator link Script to Shipper with name = "{shipper-v2-name}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> Pricing Scripts V2
    Then Operator verify the Script is linked successfully
    When Operator create and release new Time-Bounded Script using data below:
    # This source exclude "insuranceFee" and "cod_value" and using simple result. This result should be different than the parent script source.
      | source           | function calculatePricing(params){var result={};result.delivery_fee=0.4;result.cod_fee=0.6;result.insurance_fee=1.0;result.handling_fee=1.4;return result} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type |
      | startWeight      | 1.0 |
      | endWeight        | 2.0 |
    Then Operator verify the new Time-Bounded Script is created and released successfully
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator get order details
    Then Operator verify the price is correct using data below:
      | expectedCost | 3.64 |
    When Operator delete the Time-Bounded Script
    Then Operator verify the Time-Bounded Script is deleted successfully
    When Operator link Script with name = "DJPH PS V2" to Shipper with name = "{shipper-v2-name}"