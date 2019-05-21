@OperatorV2Disabled @OperatorV2Part2Disabled @PricingScriptsV2
Feature: Pricing Scripts V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  Scenario: Operator create new Draft Script (uid:0c1175e7-b5af-474c-b0a8-3b89ea786a59)
#    Given Operator go to menu Shipper -> Pricing Scripts V2
#    When Operator create new Draft Script using data below:
#      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
#      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type |
#    Then Operator verify the new Script is created successfully on Drafts
#    When Operator delete Draft Script
#    Then Operator verify the Draft Script is deleted successfully

#  @DeletePricingScript
#  Scenario Outline: Operator do Run Check on specific Draft Script (<hiptest-uid>)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> Pricing Scripts V2
#    When Operator create new Draft Script using data below:
#      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
#      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type |
#    Then Operator verify the new Script is created successfully on Drafts
#    When Operator do Run Check on specific Draft Script using this data below:
#      | deliveryType | <deliveryType> |
#      | orderType    | <orderType>    |
#      | timeslotType | <timeslotType> |
#      | size         | <size>         |
#      | weight       | <weight>       |
#      | insuredValue | <insuredValue> |
#      | codValue     | <codValue>     |
#      | fromZone     | <fromZone>     |
#      | toZone       | <toZone>       |
#    Then Operator verify the Run Check Result is correct using data below:
#      | grandTotal   | <grandTotal>   |
#      | gst          | <gst>          |
#      | deliveryFee  | <deliveryFee>  |
#      | insuranceFee | <insuranceFee> |
#      | codFee       | <codFee>       |
#      | handlingFee  | <handlingFee>  |
#      | comments     | <comments>     |
#    Examples:
#      | Note                               | hiptest-uid                              | orderType | deliveryType | timeslotType | size | weight | insuredValue | codValue | fromZone | toZone | grandTotal | gst   | deliveryFee | insuranceFee | codFee | handlingFee | comments |
#      | NORMAL - STANDARD - NONE - S       | uid:317ae297-3148-4c7a-8a5f-493bd0414fa5 | NORMAL    | STANDARD     | NONE         | S    | 5.9    | 100          | 200      | EAST     | WEST   | 48.043     | 3.143 | 13.5        | 10           | 20     | 1.4         | OK       |
#      | NORMAL - NEXT_DAY - DAY_NIGHT - XL | uid:7c32f2be-7af3-4aba-a569-58ba34e6b599 | NORMAL    | NEXT_DAY     | DAY_NIGHT    | XL   | 5.9    | 100          | 200      | EAST     | WEST   | 50.183     | 3.283 | 15.5        | 10           | 20     | 1.4         | OK       |
#      | C2C - EXPRESS - DAY_NIGHT - M      | uid:debec413-5470-41fc-bcf3-e8b5a8dd8148 | C2C       | EXPRESS      | DAY_NIGHT    | M    | 5.9    | 100          | 200      | EAST     | WEST   | 49.969     | 3.269 | 15.3        | 10           | 20     | 1.4         | OK       |
#      | C2C - SAME_DAY - NONE - XL         | uid:a6f888dd-33ff-46fe-b49e-d9f1e1e81eeb | C2C       | SAME_DAY     | NONE         | XL   | 5.9    | 100          | 200      | EAST     | WEST   | 50.611     | 3.311 | 15.9        | 10           | 20     | 1.4         | OK       |
#      | RETURN - NEXT_DAY - TIMESLOT - L   | uid:0aee7e86-0a1a-4065-b08a-9c466b65c8be | RETURN    | NEXT_DAY     | TIMESLOT     | L    | 5.9    | 100          | 200      | EAST     | WEST   | 50.397     | 3.297 | 15.7        | 10           | 20     | 1.4         | OK       |
#      | RETURN - STANDARD - TIMESLOT - M   | uid:23cd797e-1225-4a56-857f-3a54df98e804 | RETURN    | STANDARD     | TIMESLOT     | M    | 5.9    | 100          | 200      | EAST     | WEST   | 49.755     | 3.255 | 15.1        | 10           | 20     | 1.4         | OK       |
#
#  @DeletePricingScript
#  Scenario: Operator create Draft, verify and release Script (uid:f594121c-c7d3-4363-a180-d95b5c8db38e)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> Pricing Scripts V2
#    When Operator create new Draft Script using data below:
#    # This source exclude "insuranceFee" and "cod_value".
#      | source           | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else if(orderType=="CASH"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
#      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type |
#    Then Operator verify the new Script is created successfully on Drafts
#    When Operator validate and release Draft Script using this data below:
#      | startWeight | 1.0 |
#      | endWeight   | 2.0 |
#    Then Operator verify Draft Script is released successfully
#    When Operator link Script to Shipper with name = "{shipper-v2-name}"
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> Pricing Scripts V2
#    Then Operator verify the Script is linked successfully
#    When Operator link Script with name = "DJPH PS V2" to Shipper with name = "{shipper-v2-name}"

#  @DeletePricingScript
#  Scenario: Operator link Script to Shipper and verify order's price is correct (uid:0800ac82-a359-4d5f-a666-12b6d3877540)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> Pricing Scripts V2
#    When Operator create new Draft Script using data below:
#      | source           | function calculatePricing(params){var result={};result.delivery_fee=0.2;result.cod_fee=0.3;result.insurance_fee=0.5;result.handling_fee=0.7;return result} |
#      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type |
#    Then Operator verify the new Script is created successfully on Drafts
#    When Operator validate and release Draft Script using this data below:
#      | startWeight | 1.0 |
#      | endWeight   | 2.0 |
#    Then Operator verify Draft Script is released successfully
#    When Operator link Script to Shipper with name = "{shipper-v4-name}"
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> Pricing Scripts V2
#    Then Operator verify the Script is linked successfully
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    When API Operator get order details
#    Then Operator verify the price is correct using data below:
#      | expectedCost | 1.82 |
#    And Operator link Script with name = "DJPH PS V2" to Shipper with name = "{shipper-v4-name}"

  @DeletePricingScript
  Scenario: Operator create Time-Bounded Child Script and verify the Time-Bounded Script is used
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
