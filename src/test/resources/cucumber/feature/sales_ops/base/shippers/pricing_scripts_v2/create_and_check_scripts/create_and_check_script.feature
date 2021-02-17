@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @LaunchBrowser @ShouldAlwaysRun @PricingScriptsV2 @SalesOps
Feature: Pricing Scripts V2

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Draft Script (uid:233f896b-0e1c-4e21-87c1-8c927b4d91d0)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator delete Draft Script
    And Operator refresh page
    Then Operator verify the Draft Script is deleted successfully

  @DeletePricingScript
  Scenario Outline: Create and Check Script (<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="XS"){price+=3.2}else if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | deliveryType | <deliveryType> |
      | orderType    | <orderType>    |
      | timeslotType | <timeslotType> |
      | size         | <size>         |
      | weight       | <weight>       |
      | insuredValue | <insuredValue> |
      | codValue     | <codValue>     |
      | fromZone     | <fromZone>     |
      | toZone       | <toZone>       |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | <grandTotal>   |
      | gst          | <gst>          |
      | deliveryFee  | <deliveryFee>  |
      | insuranceFee | <insuranceFee> |
      | codFee       | <codFee>       |
      | handlingFee  | <handlingFee>  |
      | comments     | <comments>     |
    Examples:
      | Note                               | hiptest-uid                              | orderType | deliveryType | timeslotType | size | weight | insuredValue | codValue | fromZone | toZone | grandTotal | gst   | deliveryFee | insuranceFee | codFee | handlingFee | comments |
      | NORMAL - STANDARD - NONE - S       | uid:34d9484e-5a4a-4a35-90de-e519450ac0f1 | NORMAL    | STANDARD     | NONE         | S    | 5.9    | 100          | 200      | EAST     | WEST   | 48.043     | 3.143 | 13.5        | 10           | 20     | 1.4         | OK       |
      | NORMAL - NEXT_DAY - DAY_NIGHT - XL | uid:5c89fb60-e033-41e5-a370-c15eb21bd223 | NORMAL    | NEXT_DAY     | DAY_NIGHT    | XL   | 5.9    | 100          | 200      | EAST     | WEST   | 50.183     | 3.283 | 15.5        | 10           | 20     | 1.4         | OK       |
      | C2C - EXPRESS - DAY_NIGHT - M      | uid:895ce6ad-980f-4453-b9a5-b47f37b0a0ca | C2C       | EXPRESS      | DAY_NIGHT    | M    | 5.9    | 100          | 200      | EAST     | WEST   | 49.969     | 3.269 | 15.3        | 10           | 20     | 1.4         | OK       |
      | C2C - SAME_DAY - NONE - XL         | uid:696a6d32-e15b-4f10-9628-5c3c5e953391 | C2C       | SAME_DAY     | NONE         | XL   | 5.9    | 100          | 200      | EAST     | WEST   | 50.611     | 3.311 | 15.9        | 10           | 20     | 1.4         | OK       |
      | RETURN - NEXT_DAY - TIMESLOT - L   | uid:297bb781-77e3-486e-b88a-e596aacfc5e1 | RETURN    | NEXT_DAY     | TIMESLOT     | L    | 5.9    | 100          | 200      | EAST     | WEST   | 50.397     | 3.297 | 15.7        | 10           | 20     | 1.4         | OK       |
      | RETURN - STANDARD - TIMESLOT - M   | uid:10efe3c4-ec2b-4567-90b8-9bc19d344787 | RETURN    | STANDARD     | TIMESLOT     | M    | 5.9    | 100          | 200      | EAST     | WEST   | 49.755     | 3.255 | 15.1        | 10           | 20     | 1.4         | OK       |

  @DeletePricingScript
  Scenario: Create Pricing Script, Verify and Release Script Successfully (uid:987f2b36-b724-4858-bf15-1d06473a72d9)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else if(orderType=="CASH"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator validate and release Draft Script using this data below:
      | startWeight | 1.0 |
      | endWeight   | 2.0 |
    And Operator refresh page
    Then Operator verify Draft Script is released successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
