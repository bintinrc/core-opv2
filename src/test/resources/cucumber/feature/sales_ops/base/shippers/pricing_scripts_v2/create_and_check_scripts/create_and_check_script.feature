@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @LaunchBrowser @ShouldAlwaysRun @PricingScriptsV2 @SalesOps
Feature: Pricing Scripts V2

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePricingScript
  Scenario: Create Pricing Script, Verify and Release Script Successfully (uid:987f2b36-b724-4858-bf15-1d06473a72d9)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else if(orderType=="CASH"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify Draft Script is released successfully
    And Operator verify Draft Script data is correct

  Scenario: Create Script and Check Syntax
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify Draft Script is released successfully

  Scenario: Create Draft Script (uid:233f896b-0e1c-4e21-87c1-8c927b4d91d0)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params) {var price = 0.0;var handlingFee = 0.0;var insuranceFee = 0.0;var codFee = 0.0;var deliveryType = params.delivery_type;if (deliveryType == "STANDARD") {price += 0.3} else if (deliveryType == "EXPRESS") {price += 0.5} else if (deliveryType == "NEXT_DAY") {price += 0.7} else if (deliveryType == "SAME_DAY") {price += 1.1} else {throw "Unknown delivery type.";}var orderType = params.order_type;if (orderType == "NORMAL") {price += 1.3} else if (orderType == "RETURN") {price += 1.7} else if (orderType == "C2C") {price += 1.9} else {throw "Unknown order type.";}var timeslotType = params.timeslot_type;if (timeslotType == "NONE") {price += 2.3} else if (timeslotType == "DAY_NIGHT") {price += 2.9} else if (timeslotType == "TIMESLOT") {price += 3.1} else {throw "Unknown timeslot type.";}var size = params.size;if (size == "S") {price += 3.7} else if (size == "M") {price += 4.1} else if (size == "L") {price += 4.3} else if (size == "XL") {price += 4.7} else if (size == "XXL") {price += 5.3} else {throw "Unknown size.";}price += params.weight;var fromBillingZone = params.from_zone;var toBillingZone = params.to_zone;if (fromBillingZone == "EAST") {handlingFee += 0.3} else if (fromBillingZone == "WEST") {handlingFee += 0.5}if (toBillingZone == "EAST") {handlingFee += 0.7} else if (toBillingZone == "WEST") {handlingFee += 1.1}insuranceFee = params.insured_value * 0.1;codFee = params.cod_value * 0.1;var result = {};result.delivery_fee = price;result.cod_fee = codFee;result.insurance_fee = insuranceFee;result.handling_fee = handlingFee;return result} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    Then Operator verify the new Script is created successfully on Drafts

  @DeletePricingScript
  Scenario Outline: Create and Check Script with from_l1, from_l2, from_l3, to_l1, to_l2, to_l3
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params){var price=0;if (params.from_l1 === "Holland Rd" & params.to_l1 === "University Rd") {return price += 2} else if (params.from_l2 === "Dover Ave" & params.to_l2 === "Jln Bahasa") {return price += 3} else if (params.from_l3 === "North Buona" & params.to_l3 === "Camborne Rd") {return price += 4} else {return price}var result = {};result.delivery_fee = price;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                            |
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
      | fromZone     | EAST     |
      | toZone       | EAST     |
      | fromL1       | <fromL1> |
      | toL1         | <toL1>   |
      | fromL2       | <fromL2> |
      | toL2         | <toL2>   |
      | fromL3       | <fromL3> |
      | toL3         | <toL3>   |
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
      | Note                     | fromL1     | toL1          | fromL2    | toL2       | fromL3      | toL3        | grandTotal | gst  | deliveryFee | insuranceFee | codFee | handlingFee | comments |
      | Inputs from L1 and to L1 | Holland Rd | University Rd |           |            |             |             | 2.14       | 0.14 | 2.0         | 0            | 0      | 0           | OK       |
      | Inputs From L2 and To L2 |            |               | Dover Ave | Jln Bahasa |             |             | 3.21       | 0.21 | 3.0         | 0            | 0      | 0           | OK       |
      | Inputs From L3 and To L3 |            |               |           |            | North Buona | Camborne Rd | 4.28       | 0.28 | 4.0         | 0            | 0      | 0           | OK       |

  @DeletePricingScript
  Scenario Outline: Create and Check Script - Legacy Order Fields
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params){var result = {};var order=params.order_type;var delivery_type=params.delivery_type; result.delivery_fee=0.0;if (order === "NORMAL") {result.delivery_fee += 1.1;}if (order === "RETURN") {result.delivery_fee += 2.2;}if (order === "C2C") {result.delivery_fee += 3.3;}if (order === "CASH") {result.delivery_fee += 9.9;}if (delivery_type === "STANDARD") {result.delivery_fee += 5.5;}if (delivery_type === "EXPRESS") {result.delivery_fee += 6.6;}if (delivery_type === "SAME_DAY") {result.delivery_fee += 7.7;}if (delivery_type === "NEXT_DAY") {result.delivery_fee += 8.8;}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy         |
      | deliveryType | <deliveryType> |
      | orderType    | <orderType>    |
      | timeslotType | NONE           |
      | isRts        | No             |
      | size         | XS             |
      | weight       | 1.0            |
      | insuredValue | 0.00           |
      | codValue     | 0.00           |
      | fromZone     | EAST           |
      | toZone       | WEST           |
      | fromL1       |                |
      | toL1         |                |
      | fromL2       |                |
      | toL2         |                |
      | fromL3       |                |
      | toL3         |                |
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
      | Note             | deliveryType | orderType | grandTotal | gst   | deliveryFee | insuranceFee | codFee | handlingFee | comments |
      | RETURN, EXPRESS  | EXPRESS      | RETURN    | 9.416      | 0.616 | 8.8         | 0            | 0      | 0           | OK       |
      | NORMAL, STANDARD | STANDARD     | NORMAL    | 7.062      | 0.462 | 6.6         | 0            | 0      | 0           | OK       |
      | C2C, NEXT_DAY    | NEXT_DAY     | C2C       | 12.947     | 0.847 | 12.1        | 0            | 0      | 0           | OK       |
      | NORMAL, SAME_DAY | SAME_DAY     | NORMAL    | 9.416      | 0.616 | 8.8         | 0            | 0      | 0           | OK       |

  @DeletePricingScript
  Scenario Outline: Create and Check Script - New Order Fields
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | New             |
      | serviceLevel | <service_level> |
      | serviceType  | <service_type>  |
      | timeslotType | NONE            |
      | isRts        | No              |
      | size         | XS              |
      | weight       | 1.0             |
      | insuredValue | 0.00            |
      | codValue     | 0.00            |
      | fromZone     | EAST            |
      | toZone       | WEST            |
      | fromL1       |                 |
      | toL1         |                 |
      | fromL2       |                 |
      | toL2         |                 |
      | fromL3       |                 |
      | toL3         |                 |
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
      | Note                               | service_level | service_type              | grandTotal | gst   | deliveryFee | insuranceFee | codFee | handlingFee | comments |
      | Parcel, STANDARD                   | STANDARD      | Parcel                    | 17.12      | 1.12  | 16          | 0            | 0      | 0           | OK       |
      | Marketplace, EXPRESS               | EXPRESS       | Marketplace               | 23.54      | 1.54  | 22          | 0            | 0      | 0           | OK       |
      | Return, NEXTDAY                    | NEXTDAY       | Return                    | 32.1       | 2.1   | 30          | 0            | 0      | 0           | OK       |
      | Document, SAMEDAY                  | SAMEDAY       | Document                  | 32.1       | 2.1   | 30          | 0            | 0      | 0           | OK       |
      | Bulky, STANDARD                    | STANDARD      | Bulky                     | 15.087     | 0.987 | 14.1        | 0            | 0      | 0           | OK       |
      | International, EXPRESS             | EXPRESS       | International             | 20.544     | 1.344 | 19.2        | 0            | 0      | 0           | OK       |
      | Ninja Pack, NEXTDAY                | NEXTDAY       | Ninja Pack                | 28.141     | 1.841 | 26.3        | 0            | 0      | 0           | OK       |
      | Marketplace International, SAMEDAY | SAMEDAY       | Marketplace International | 25.038     | 1.638 | 23.4        | 0            | 0      | 0           | OK       |
      | Corporate, STANDARD                | STANDARD      | Corporate                 | 19.795     | 1.295 | 18.5        | 0            | 0      | 0           | OK       |
      | Corporate Return, EXPRESS          | EXPRESS       | Corporate Return          | 25.252     | 1.652 | 23.6        | 0            | 0      | 0           | OK       |

  @DeletePricingScript
  Scenario Outline: Create and Check Script with Send is_RTS - Use calculatePricing()
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params) {var result = {};result.delivery_fee = 1;if (params.is_rts === true) {if (params.from_metadata.l1_tier === "ID_A00007_01") {result.delivery_fee = 3;} else {result.delivery_fee = 5;}}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                    |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy          |
      | deliveryType | STANDARD        |
      | orderType    | NORMAL          |
      | timeslotType | NONE            |
      | isRts        | <is_RTS_toggle> |
      | size         | XS              |
      | weight       | 1.0             |
      | insuredValue | 0.00            |
      | codValue     | 0.00            |
      | fromZone     | EAST            |
      | toZone       | WEST            |
      | fromL1       |                 |
      | toL1         |                 |
      | fromL2       |                 |
      | toL2         |                 |
      | fromL3       |                 |
      | toL3         |                 |
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
      | Note        | is_RTS_toggle | grandTotal | gst  | deliveryFee | insuranceFee | codFee | handlingFee | comments |
#      | RTS = True  | Yes           | 0          | 0    | 3           | 0            | 0      | 0           | OK       |
      | RTS = False | No            | 1.07       | 0.07 | 1           | 0            | 0      | 0           | OK       |

  @DeletePricingScript
  Scenario Outline: Create and Check Script - Send is_RTS - Use calculate()
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculate(delivery_type,timeslot_type,order_type,size,weight,is_rts) {var result = {};result.delivery_fee = 1;if (is_rts === true) {result.delivery_fee += 3} else if (is_rts === false) {result.delivery_fee += 5;}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                         |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy          |
      | deliveryType | STANDARD        |
      | orderType    | NORMAL          |
      | timeslotType | NONE            |
      | isRts        | <is_RTS_toggle> |
      | size         | XS              |
      | weight       | 1.0             |
      | insuredValue | 0.00            |
      | codValue     | 0.00            |
      | fromZone     | EAST            |
      | toZone       | WEST            |
      | fromL1       |                 |
      | toL1         |                 |
      | fromL2       |                 |
      | toL2         |                 |
      | fromL3       |                 |
      | toL3         |                 |
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
      | Note        | is_RTS_toggle | grandTotal | gst  | deliveryFee | insuranceFee | codFee | handlingFee | comments |
      | RTS = True  | Yes           | 1.07       | 0.07 | 1           | 0            | 0      | 0           | OK       |
      | RTS = False | No            | 1.07       | 0.07 | 1           | 0            | 0      | 0           | OK       |

  @DeletePricingScript
  Scenario: Create Pricing Script - Select Template Script
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using template
    Then Operator verify Draft Script is released successfully

  @DeletePricingScript
  Scenario: Create Pricing Script - Import from CSV File Successfully
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script with import a csv file using data below:
      | source           | function calculatePricing(params) {var price = 0.0;if (params.order_type == "NORMAL") {price += 1;} else if (params.order_type == "RETURN") {price += 2;} else if (params.order_type == "C2C") {price += 3;}else if (params.order_type == "CASH") {price += 4;} else {throw "Unknown order type.";}if (params.timeslot_type == "NONE") {price += 1;} else if (params.timeslot_type == "DAY_NIGHT") {price += 2;} else if (params.timeslot_type == "TIMESLOT") {price += 3;} else {throw "Unknown timeslot type.";}for(var i=0; i<zonalRates.length; i++) {if ((params.delivery_type == zonalRates[i].deliveryType) && (params.size == zonalRates[i].parcelSize) && (params.from_zone == zonalRates[i].fromZone) && (params.to_zone == zonalRates[i].toZone)) {price += (params.weight*zonalRates[i].perKg);}}var result = {};result.delivery_fee = price;if (params.cod_value > 100){result.cod_fee = params.cod_value*0.01;}else{result.cod_fee = 0;}result.insurance_fee = 0.4;result.handling_fee = 0.3;return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | filePath         | C:\Users\hp\sample_upload_rates.csv                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify Draft Script is released successfully
    And Operator verify Draft Script data is correct

  @DeletePricingScript
  Scenario: Create Pricing Script - Import from CSV File Fails
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script with import a csv file using data below:
      | source           | function calculatePricing(params) {var price = 0.0;if (params.order_type == "NORMAL") {price += 1;} else if (params.order_type == "RETURN") {price += 2;} else if (params.order_type == "C2C") {price += 3;}else if (params.order_type == "CASH") {price += 4;} else {throw "Unknown order type.";}if (params.timeslot_type == "NONE") {price += 1;} else if (params.timeslot_type == "DAY_NIGHT") {price += 2;} else if (params.timeslot_type == "TIMESLOT") {price += 3;} else {throw "Unknown timeslot type.";}for(var i=0; i<zonalRates.length; i++) {if ((params.delivery_type == zonalRates[i].deliveryType) && (params.size == zonalRates[i].parcelSize) && (params.from_zone == zonalRates[i].fromZone) && (params.to_zone == zonalRates[i].toZone)) {price += (params.weight*zonalRates[i].perKg);}}var result = {};result.delivery_fee = price;if (params.cod_value > 100){result.cod_fee = params.cod_value*0.01;}else{result.cod_fee = 0;}result.insurance_fee = 0.4;result.handling_fee = 0.3;return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | filePath         | C:\Users\hp\script_csv_-_Sheet1.csv                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    Then Operator verify error message after adding invalid csv file

  @DeletePricingScript
  Scenario Outline: Create and Check Script
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="XS"){price+=3.2}else if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
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
      | Note                               | orderType | deliveryType | timeslotType | size | weight | insuredValue | codValue | fromZone | toZone | grandTotal | gst   | deliveryFee | insuranceFee | codFee | handlingFee | comments |
      | NORMAL - STANDARD - NONE - S       | NORMAL    | STANDARD     | NONE         | S    | 5.9    | 100          | 200      | EAST     | WEST   | 48.043     | 3.143 | 13.5        | 10           | 20     | 1.4         | OK       |
      | NORMAL - NEXT_DAY - DAY_NIGHT - XL | NORMAL    | NEXT_DAY     | DAY_NIGHT    | XL   | 5.9    | 100          | 200      | EAST     | WEST   | 50.183     | 3.283 | 15.5        | 10           | 20     | 1.4         | OK       |
      | C2C - EXPRESS - DAY_NIGHT - M      | C2C       | EXPRESS      | DAY_NIGHT    | M    | 5.9    | 100          | 200      | EAST     | WEST   | 49.969     | 3.269 | 15.3        | 10           | 20     | 1.4         | OK       |
      | C2C - SAME_DAY - NONE - XL         | C2C       | SAME_DAY     | NONE         | XL   | 5.9    | 100          | 200      | EAST     | WEST   | 50.611     | 3.311 | 15.9        | 10           | 20     | 1.4         | OK       |
      | RETURN - NEXT_DAY - TIMESLOT - L   | RETURN    | NEXT_DAY     | TIMESLOT     | L    | 5.9    | 100          | 200      | EAST     | WEST   | 50.397     | 3.297 | 15.7        | 10           | 20     | 1.4         | OK       |
      | RETURN - STANDARD - TIMESLOT - M   | RETURN    | STANDARD     | TIMESLOT     | M    | 5.9    | 100          | 200      | EAST     | WEST   | 49.755     | 3.255 | 15.1        | 10           | 20     | 1.4         | OK       |


  @DeletePricingScript
  Scenario Outline: Create and Check Script - Legacy Order Fields
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source           | function calculatePricing(params){var result = {};var order=params.order_type;var delivery_type=params.delivery_type; result.delivery_fee=0.0;if (order === "NORMAL") {result.delivery_fee += 1.1;}if (order === "RETURN") {result.delivery_fee += 2.2;}if (order === "C2C") {result.delivery_fee += 3.3;}if (order === "CASH") {result.delivery_fee += 9.9;}if (delivery_type === "STANDARD") {result.delivery_fee += 5.5;}if (delivery_type === "EXPRESS") {result.delivery_fee += 6.6;}if (delivery_type === "SAME_DAY") {result.delivery_fee += 7.7;}if (delivery_type === "NEXT_DAY") {result.delivery_fee += 8.8;}return result;} |
      | activeParameters | delivery_type, timeslot_type, size, weight, from_zone, to_zone, cod_value, insured_value, order_type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | deliveryType | <deliveryType> |
      | orderType    | <orderType>    |
      | timeslotType | NONE           |
      | size         | XS             |
      | weight       | 1.0            |
      | insuredValue | 0.00           |
      | codValue     | 0.00           |
      | fromZone     | EAST           |
      | toZone       | WEST           |
      | fromL1       |                |
      | toL1         |                |
      | fromL2       |                |
      | toL2         |                |
      | fromL3       |                |
      | toL3         |                |
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
      | Note             | deliveryType | orderType | grandTotal | gst   | deliveryFee | insuranceFee | codFee | handlingFee | comments |
      | RETURN, EXPRESS  | EXPRESS      | RETURN    | 9.416      | 0.616 | 8.8         | 0            | 0      | 0           | OK       |
      | NORMAL, STANDARD | STANDARD     | NORMAL    | 7.062      | 0.462 | 6.6         | 0            | 0      | 0           | OK       |
      | C2C, NEXT_DAY    | NEXT_DAY     | C2C       | 12.947     | 0.847 | 12.1        | 0            | 0      | 0           | OK       |
      | NORMAL, SAME_DAY | SAME_DAY     | NORMAL    | 9.416      | 0.616 | 8.8         | 0            | 0      | 0           | OK       |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
