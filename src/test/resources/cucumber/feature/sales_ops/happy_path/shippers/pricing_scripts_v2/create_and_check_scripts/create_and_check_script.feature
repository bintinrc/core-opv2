@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @LaunchBrowser @ShouldAlwaysRun @PricingScriptsV2 @SalesOps @HappyPath
Feature: Pricing Scripts V2

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePricingScript
  Scenario Outline: Create and Check Script - <dataset_name>(<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
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
      | Note                         | hiptest-uid                              | orderType | deliveryType | timeslotType | size | weight | insuredValue | codValue | fromZone | toZone | grandTotal | gst   | deliveryFee | insuranceFee | codFee | handlingFee | comments | dataset_name              |
      | NORMAL - STANDARD - NONE - S | uid:5ecc151d-01ab-47ad-8136-e15d698bd5b2 | NORMAL    | STANDARD     | NONE         | S    | 5.9    | 100          | 200      | EAST     | WEST   | 48.043     | 3.143 | 13.5        | 10           | 20     | 1.4         | OK       | NORMAL, STANDARD, NONE, S |

  @DeletePricingScript
  Scenario: Create Pricing Script, Verify and Release Script Successfully (uid:044fa817-b8e3-4de5-b4a2-affe45304486)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else if(orderType=="CASH"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator validate and release Draft Script using this data below:
      | startWeight | 1.0 |
      | endWeight   | 2.0 |
    And Operator refresh page
    Then Operator verify the script is saved successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
