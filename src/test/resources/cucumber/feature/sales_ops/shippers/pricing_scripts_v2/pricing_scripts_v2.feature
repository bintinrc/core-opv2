@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @PricingScriptsV2
Feature: Pricing Scripts V2

  @DeletePricingScript
  Scenario: Link Script to Shipper (uid:8c623eef-fb54-4a8b-bcf1-a182eba43bf7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params){var result={};result.delivery_fee=0.2;result.cod_fee=0.3;result.insurance_fee=0.5;result.handling_fee=0.7;return result} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type                                                                                 |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator validate and release Draft Script using this data below:
      | startWeight | 1.0 |
      | endWeight   | 2.0 |
    And Operator refresh page
    Then Operator verify Draft Script is released successfully
    When Operator link Script to Shipper with name = "{shipper-v4-name}"
    And Operator refresh page
    Then Operator verify the Script is linked successfully
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator get order details
    Then Operator verify the price is correct using data below:
      | expectedCost | 1.82 |
    And Operator link Script with name = "DJPH PS V2" to Shipper with name = "{shipper-v4-name}"
