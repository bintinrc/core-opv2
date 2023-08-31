@OperatorV2 @LaunchBrowser @PricingScriptsV2 @SalesOps @CreatePricingScript
Feature: Pricing Scripts V2

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePricingScript @HappyPath
  Scenario: Create Pricing Script, Verify and Release Script Successfully (uid:987f2b36-b724-4858-bf15-1d06473a72d9)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else if(orderType=="CASH"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify the script is saved successfully
    Then DB Operator gets the pricing script details
    And Operator verify Active Script data is correct

  @DeletePricingScript
  Scenario: Create Script and Check Syntax (uid:183521ce-da01-417b-95a3-efeae76f5059)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify the script is saved successfully

  @DeletePricingScript
  Scenario: Create Draft Script (uid:3dde52f0-f02b-4bc5-9a49-323b01180fa1)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var price = 0.0;var handlingFee = 0.0;var insuranceFee = 0.0;var codFee = 0.0;var deliveryType = params.delivery_type;if (deliveryType == "STANDARD") {price += 0.3} else if (deliveryType == "EXPRESS") {price += 0.5} else if (deliveryType == "NEXT_DAY") {price += 0.7} else if (deliveryType == "SAME_DAY") {price += 1.1} else {throw "Unknown delivery type.";}var orderType = params.order_type;if (orderType == "NORMAL") {price += 1.3} else if (orderType == "RETURN") {price += 1.7} else if (orderType == "C2C") {price += 1.9} else {throw "Unknown order type.";}var timeslotType = params.timeslot_type;if (timeslotType == "NONE") {price += 2.3} else if (timeslotType == "DAY_NIGHT") {price += 2.9} else if (timeslotType == "TIMESLOT") {price += 3.1} else {throw "Unknown timeslot type.";}var size = params.size;if (size == "S") {price += 3.7} else if (size == "M") {price += 4.1} else if (size == "L") {price += 4.3} else if (size == "XL") {price += 4.7} else if (size == "XXL") {price += 5.3} else {throw "Unknown size.";}price += params.weight;var fromBillingZone = params.from_zone;var toBillingZone = params.to_zone;if (fromBillingZone == "EAST") {handlingFee += 0.3} else if (fromBillingZone == "WEST") {handlingFee += 0.5}if (toBillingZone == "EAST") {handlingFee += 0.7} else if (toBillingZone == "WEST") {handlingFee += 1.1}insuranceFee = params.insured_value * 0.1;codFee = params.cod_value * 0.1;var result = {};result.delivery_fee = price;result.cod_fee = codFee;result.insurance_fee = insuranceFee;result.handling_fee = handlingFee;return result} |
    Then Operator verify the new Script is created successfully on Drafts
    Then DB Operator gets the pricing script details
    And Operator verify Draft Script data is correct

  @DeletePricingScript
  Scenario: Create Draft Script with Legacy Params
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var price = 1;var result = {};result.delivery_fee = price * params.width * params.length * params.height * params.shipper_provided_length * params.shipper_provided_width * params.shipper_provided_height * params.shipper_provided_weight;return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator clicks validate and verify warning message "The script contains legacy params.You can continue to release the script, but pricing will be affected for shippers who are attached to this script, and is using new billing weight logics.Legacy params include the followings:- shipper_provided_length- shipper_provided_width- shipper_provided_height- shipper_provided_weight- length- width- height"

  @DeletePricingScript
  Scenario: Create Draft Script with Legacy Params
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var price = 1;var result = {};result.delivery_fee = price * params.width * params.length * params.height * params.shipper_provided_length * params.shipper_provided_width * params.shipper_provided_height * params.shipper_provided_weight;return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator clicks validate and verify warning message "The script contains legacy params.You can continue to release the script, but pricing will be affected for shippers who are attached to this script, and is using new billing weight logics.Legacy params include the followings:- shipper_provided_length- shipper_provided_width- shipper_provided_height- shipper_provided_weight- length- width- height"
    Then Operator release Draft Script
    And Operator verify the script is saved successfully
    Then DB Operator gets the pricing script details
    And Operator verify Active Script data is correct

  @DeletePricingScript
  Scenario Outline: Create and Check Script with from_l1, from_l2, from_l3, to_l1, to_l2, to_l3 - <dataset_name>(<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0;if (params.from_l1 === "Holland Rd" & params.to_l1 === "University Rd") {return price += 2} else if (params.from_l2 === "Dover Ave" & params.to_l2 === "Jln Bahasa") {return price += 3} else if (params.from_l3 === "North Buona" & params.to_l3 === "Camborne Rd") {return price += 4} else {return price}var result = {};result.delivery_fee = price;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy   |
      | deliveryType | Standard |
      | orderType    | Normal   |
      | timeslotType | None     |
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
      | rtsFee       | 0              |
      | comments     | <comments>     |
    And Operator close page
    And Operator validate and release Draft Script
    Then Operator verify the script is saved successfully
    Examples:
      | Note                     | fromL1     | toL1          | fromL2    | toL2       | fromL3      | toL3        | grandTotal | gst  | deliveryFee | insuranceFee | codFee | handlingFee | comments | hiptest-uid                              | dataset_name             |
      | Inputs from L1 and to L1 | Holland Rd | University Rd |           |            |             |             | 2.16       | 0.16 | 2           | 0            | 0      | 0           | OK       | uid:74636785-935a-4027-9bc9-596722b3a06f | Inputs from L1 and to L1 |
      | Inputs From L2 and To L2 |            |               | Dover Ave | Jln Bahasa |             |             | 3.24       | 0.24 | 3           | 0            | 0      | 0           | OK       | uid:340d16f4-dae8-45e3-98d2-ccc74ea4f540 | Inputs From L2 and To L2 |
      | Inputs From L3 and To L3 |            |               |           |            | North Buona | Camborne Rd | 4.32       | 0.32 | 4           | 0            | 0      | 0           | OK       | uid:82c4e670-586c-449d-889a-3e7b205ee314 | Inputs From L3 and To L3 |

  @DeletePricingScript
  Scenario Outline: Create and Check Script - New Order Fields - <dataset_name>(<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;if (params.service_type == "Parcel") {result.delivery_fee += 3;}if (params.service_type == "Marketplace") {result.delivery_fee += 5;}if (params.service_type == "Return") {result.delivery_fee += 7;}if (params.service_type == "Document") {result.delivery_fee += 11;}if (params.service_type == "Bulky") {result.delivery_fee += 1.1;}if (params.service_type == "International") {result.delivery_fee += 2.2;}if (params.service_type == "Ninja Pack") {result.delivery_fee += 3.3;}if (params.service_type == "Marketplace International") {result.delivery_fee += 4.4;}if (params.service_type == "Corporate") {result.delivery_fee += 5.5;}if (params.service_type == "Corporate Return") {result.delivery_fee += 6.6;}if (params.service_level == "STANDARD") {result.delivery_fee += 13;}if (params.service_level == "EXPRESS") {result.delivery_fee += 17;}if (params.service_level == "SAMEDAY") {result.delivery_fee += 19;}if (params.service_level == "NEXTDAY") {result.delivery_fee += 23;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | New             |
      | serviceLevel | <service_level> |
      | serviceType  | <service_type>  |
      | timeslotType | None            |
      | isRts        | No              |
      | size         | XS              |
      | weight       | 1.0             |
      | insuredValue | 0.00            |
      | codValue     | 0.00            |
      | fromZone     | EAST            |
      | toZone       | WEST            |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | <grandTotal>   |
      | gst          | <gst>          |
      | deliveryFee  | <deliveryFee>  |
      | insuranceFee | <insuranceFee> |
      | codFee       | <codFee>       |
      | handlingFee  | <handlingFee>  |
      | rtsFee       | 0              |
      | comments     | <comments>     |
    And Operator close page
    And Operator validate and release Draft Script
    Then Operator verify the script is saved successfully

    Examples:
      | dataset_name                       | Note                               | service_level | service_type              | grandTotal | gst   | deliveryFee | insuranceFee | codFee | handlingFee | comments | hiptest-uid                              |
      | Parcel, STANDARD                   | Parcel, STANDARD                   | Standard      | Parcel                    | 17.28      | 1.28  | 16          | 0            | 0      | 0           | OK       | uid:4a8e8d1f-a3f1-4684-a2b5-62b2f81776e5 |
      | Marketplace, EXPRESS               | Marketplace, EXPRESS               | Express       | Marketplace               | 23.76      | 1.76  | 22          | 0            | 0      | 0           | OK       | uid:d0e0d022-6ee5-4964-9e97-ca7c5be6090d |
      | Return, NEXTDAY                    | Return, NEXTDAY                    | Next Day      | Return                    | 32.4       | 2.4   | 30          | 0            | 0      | 0           | OK       | uid:8718aa6b-c660-49a3-8736-491e5b6c3d69 |
      | Document, SAMEDAY                  | Document, SAMEDAY                  | Same Day      | Document                  | 32.4       | 2.4   | 30          | 0            | 0      | 0           | OK       | uid:b6b2ba5a-a6b3-4da1-b912-46f446eccd4c |
      | Bulky, STANDARD                    | Bulky, STANDARD                    | Standard      | Bulky                     | 15.228     | 1.128 | 14.1        | 0            | 0      | 0           | OK       | uid:96a6e6b0-f0a0-436d-a201-d6c27b645400 |
      | International, EXPRESS             | International, EXPRESS             | Express       | International             | 20.736     | 1.536 | 19.2        | 0            | 0      | 0           | OK       | uid:ea0f7b2d-5e3b-4af5-8c6e-c9e94fe5637d |
      | Ninja Pack, NEXTDAY                | Ninja Pack, NEXTDAY                | Next Day      | Ninja Pack                | 28.404     | 2.104 | 26.3        | 0            | 0      | 0           | OK       | uid:0a2605a8-b707-43b7-9650-0407b0197f9d |
      | Marketplace International, SAMEDAY | Marketplace International, SAMEDAY | Same Day      | Marketplace International | 25.272     | 1.872 | 23.4        | 0            | 0      | 0           | OK       | uid:26d8083c-2829-432b-8f2d-99a4ff754ce2 |
      | Corporate, STANDARD                | Corporate, STANDARD                | Standard      | Corporate                 | 19.98      | 1.48  | 18.5        | 0            | 0      | 0           | OK       | uid:64d99231-93cf-4aa1-a13e-ab7e4b118c5f |
      | Corporate Return, EXPRESS          | Corporate Return, EXPRESS          | Express       | Corporate Return          | 25.488     | 1.888 | 23.6        | 0            | 0      | 0           | OK       | uid:c2651843-f068-4c89-91ff-117782f05e1d |

  @DeletePricingScript
  Scenario: Check Script without is_RTS, is_RTS = TRUE (uid:408e1b2d-d99c-4e66-ad89-ab9b59ae4750)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculate(delivery_type,timeslot_type,order_type,size,weight) {var result = {};result.delivery_fee = 1;return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator edit the created Draft Script using data below:
      | source | function calculate(delivery_type,timeslot_type,order_type,size,weight,is_rts) {var result = {};result.delivery_fee = 1;return result;} |
    When Operator search according Active Script name
    When Operator do Run Check on specific Active Script using this data below:
      | orderFields  | New      |
      | serviceLevel | Same Day |
      | serviceType  | Document |
      | timeslotType | None     |
      | isRts        | Yes      |
      | size         | XS       |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
      | fromZone     | EAST     |
      | toZone       | WEST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 1.08 |
      | gst          | 0.08 |
      | deliveryFee  | 1    |
      | insuranceFee | 0    |
      | codFee       | 0    |
      | handlingFee  | 0    |
      | rtsFee       | 0    |
      | comments     | OK   |

  @DeletePricingScript
  Scenario Outline: Create and Check Script - Send is_RTS - Use calculate() - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculate(delivery_type,timeslot_type,order_type,size,weight,is_rts) {var result = {};result.delivery_fee = 1;if (is_rts === true) {result.delivery_fee += 3} else if (is_rts === false) {result.delivery_fee += 5;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy          |
      | deliveryType | Standard        |
      | orderType    | Normal          |
      | timeslotType | None            |
      | isRts        | <is_RTS_toggle> |
      | size         | XS              |
      | weight       | 1.0             |
      | insuredValue | 0.00            |
      | codValue     | 0.00            |
      | fromZone     | EAST            |
      | toZone       | WEST            |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | <grandTotal>   |
      | gst          | <gst>          |
      | deliveryFee  | <deliveryFee>  |
      | insuranceFee | <insuranceFee> |
      | codFee       | <codFee>       |
      | handlingFee  | <handlingFee>  |
      | rtsFee       | 0              |
      | comments     | <comments>     |
    And Operator close page
    And Operator validate and release Draft Script
    Then Operator verify the script is saved successfully
    Examples:
      | dataset_name | Note        | is_RTS_toggle | grandTotal | gst  | deliveryFee | insuranceFee | codFee | handlingFee | comments | hiptest-uid                              |
      | RTS = True   | RTS = True  | Yes           | 1.08       | 0.08 | 1           | 0            | 0      | 0           | OK       | uid:2bf32cea-5fde-4844-9dde-f245abab7325 |
      | RTS = False  | RTS = False | No            | 1.08       | 0.08 | 1           | 0            | 0      | 0           | OK       | uid:514849a5-2457-443e-88e8-8eee1fea3970 |

  @DeletePricingScript
  Scenario: Create Pricing Script - Select Template Script (uid:4ba695cc-de36-482b-bfc9-dc6323b9f59e)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | hasTemplate  | Yes                   |
      | templateName | {pricing-script-name} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify the script is saved successfully

  @DeletePricingScript
  Scenario: Create Pricing Script - Import from CSV File Successfully (uid:bbc7d927-da48-41a6-a5c6-77a7803e219f)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | isCsvFile   | Yes                                                                                    |
      | fileContent | 'deliveryType':'Express','parcelSize':'S','fromZone':'EAST','toZone':'WEST','perKg':20 |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    And Operator verify the script is saved successfully
    Then DB Operator gets the pricing script details
    And Operator verify Active Script data is correct

  @DeletePricingScript
  Scenario: Create Pricing Script - Import from CSV File Fails (uid:4b0b4ba7-1a1f-46e1-af20-adf2307f3950)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator send below data to create new Draft Script:
      | isCsvFile   | Yes                                         |
      | fileContent | deliveryType':'Express' \n 'parcelSize':'S' |
    Then Operator verify error message in header with "CSV Header contain invalid character, accept A-Z, a-z, and space. Invalid header: deliveryType':'Express' (Column 1)"

  @DeletePricingScript @HappyPath
  Scenario: Create and Check Script - NORMAL, STANDARD, NONE, S (uid:34d9484e-5a4a-4a35-90de-e519450ac0f1)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="XS"){price+=3.2}else if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy   |
      | deliveryType | Standard |
      | orderType    | Normal   |
      | timeslotType | None     |
      | isRts        | No       |
      | size         | S        |
      | weight       | 5.9      |
      | insuredValue | 100      |
      | codValue     | 200      |
      | fromZone     | EAST     |
      | toZone       | WEST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 48.492 |
      | gst          | 3.592  |
      | deliveryFee  | 13.5   |
      | insuranceFee | 10     |
      | codFee       | 20     |
      | handlingFee  | 1.4    |
      | rtsFee       | 0      |
      | comments     | OK     |

  @DeletePricingScript
  Scenario: Create and Check Script - NORMAL, NEXT_DAY, DAY_NIGHT, XL (uid:5c89fb60-e033-41e5-a370-c15eb21bd223)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="XS"){price+=3.2}else if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy    |
      | deliveryType | Next Day  |
      | orderType    | Normal    |
      | timeslotType | Day Night |
      | isRts        | No        |
      | size         | XL        |
      | weight       | 5.9       |
      | insuredValue | 100       |
      | codValue     | 200       |
      | fromZone     | EAST      |
      | toZone       | WEST      |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 50.652 |
      | gst          | 3.752  |
      | deliveryFee  | 15.5   |
      | insuranceFee | 10     |
      | codFee       | 20     |
      | handlingFee  | 1.4    |
      | rtsFee       | 0      |
      | comments     | OK     |

  @DeletePricingScript
  Scenario: Create and Check Script - C2C, EXPRESS, DAY_NIGHT, M (uid:895ce6ad-980f-4453-b9a5-b47f37b0a0ca)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="XS"){price+=3.2}else if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy    |
      | deliveryType | Express   |
      | orderType    | C2C       |
      | timeslotType | Day Night |
      | isRts        | No        |
      | size         | M         |
      | weight       | 5.9       |
      | insuredValue | 100       |
      | codValue     | 200       |
      | fromZone     | EAST      |
      | toZone       | WEST      |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 50.436 |
      | gst          | 3.736  |
      | deliveryFee  | 15.3   |
      | insuranceFee | 10     |
      | codFee       | 20     |
      | handlingFee  | 1.4    |
      | rtsFee       | 0      |
      | comments     | OK     |

  @DeletePricingScript
  Scenario: Create and Check Script - C2C, SAME_DAY, NONE, XL (uid:696a6d32-e15b-4f10-9628-5c3c5e953391)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="XS"){price+=3.2}else if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy   |
      | deliveryType | Same Day |
      | orderType    | C2C      |
      | timeslotType | None     |
      | isRts        | No       |
      | size         | XL       |
      | weight       | 5.9      |
      | insuredValue | 100      |
      | codValue     | 200      |
      | fromZone     | EAST     |
      | toZone       | WEST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 51.084 |
      | gst          | 3.784  |
      | deliveryFee  | 15.9   |
      | insuranceFee | 10     |
      | codFee       | 20     |
      | handlingFee  | 1.4    |
      | rtsFee       | 0      |
      | comments     | OK     |

  @DeletePricingScript
  Scenario: Create and Check Script - RETURN, NEXT_DAY, TIMESLOT, L (uid:297bb781-77e3-486e-b88a-e596aacfc5e1)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="XS"){price+=3.2}else if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy    |
      | deliveryType | Next Day  |
      | orderType    | Return    |
      | timeslotType | Time Slot |
      | isRts        | No        |
      | size         | L         |
      | weight       | 5.9       |
      | insuredValue | 100       |
      | codValue     | 200       |
      | fromZone     | EAST      |
      | toZone       | WEST      |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 50.868 |
      | gst          | 3.768  |
      | deliveryFee  | 15.7   |
      | insuranceFee | 10     |
      | codFee       | 20     |
      | handlingFee  | 1.4    |
      | rtsFee       | 0      |
      | comments     | OK     |

  @DeletePricingScript
  Scenario: Create and Check Script - RETURN, STANDARD, TIMESLOT, M (uid:10efe3c4-ec2b-4567-90b8-9bc19d344787)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="XS"){price+=3.2}else if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}insuranceFee=params.insured_value*0.1;codFee=params.cod_value*0.1;var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy    |
      | deliveryType | Standard  |
      | orderType    | Return    |
      | timeslotType | Time Slot |
      | isRts        | No        |
      | size         | M         |
      | weight       | 5.9       |
      | insuredValue | 100       |
      | codValue     | 200       |
      | fromZone     | EAST      |
      | toZone       | WEST      |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 50.22 |
      | gst          | 3.72  |
      | deliveryFee  | 15.1  |
      | insuranceFee | 10    |
      | codFee       | 20    |
      | handlingFee  | 1.4   |
      | rtsFee       | 0     |
      | comments     | OK    |

  @DeletePricingScript
  Scenario Outline: Create and Check Script - Legacy Order Fields - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params){var result = {};var order=params.order_type;var delivery_type=params.delivery_type; result.delivery_fee=0.0;if (order === "NORMAL") {result.delivery_fee += 1.1;}if (order === "RETURN") {result.delivery_fee += 2.2;}if (order === "C2C") {result.delivery_fee += 3.3;}if (order === "CASH") {result.delivery_fee += 9.9;}if (delivery_type === "STANDARD") {result.delivery_fee += 5.5;}if (delivery_type === "EXPRESS") {result.delivery_fee += 6.6;}if (delivery_type === "SAME_DAY") {result.delivery_fee += 7.7;}if (delivery_type === "NEXT_DAY") {result.delivery_fee += 8.8;}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | Legacy         |
      | deliveryType | <deliveryType> |
      | orderType    | <orderType>    |
      | timeslotType | None           |
      | isRts        | No             |
      | size         | XS             |
      | weight       | 1.0            |
      | insuredValue | 0.00           |
      | codValue     | 0.00           |
      | fromZone     | EAST           |
      | toZone       | WEST           |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | <grandTotal>   |
      | gst          | <gst>          |
      | deliveryFee  | <deliveryFee>  |
      | insuranceFee | <insuranceFee> |
      | codFee       | <codFee>       |
      | handlingFee  | <handlingFee>  |
      | rtsFee       | 0              |
      | comments     | <comments>     |
    And Operator close page
    And Operator validate and release Draft Script
    Then Operator verify the script is saved successfully

    Examples:
      | dataset_name     | Note             | deliveryType | orderType | grandTotal | gst   | deliveryFee | insuranceFee | codFee | handlingFee | comments | hiptest-uid                              |
      | RETURN, EXPRESS  | RETURN, EXPRESS  | Express      | Return    | 9.504      | 0.704 | 8.8         | 0            | 0      | 0           | OK       | uid:05331f6c-c126-4874-bdf2-7c7bf4e3c858 |
      | NORMAL, STANDARD | NORMAL, STANDARD | Standard     | Normal    | 7.128      | 0.528 | 6.6         | 0            | 0      | 0           | OK       | uid:dd39a8d8-8437-4ba1-8dd1-c5dc0ccefda9 |
      | C2C, NEXT_DAY    | C2C, NEXT_DAY    | Next Day     | C2C       | 13.068     | 0.968 | 12.1        | 0            | 0      | 0           | OK       | uid:237fffd0-27df-43c2-a12c-2e7b0adc9367 |
      | NORMAL, SAME_DAY | NORMAL, SAME_DAY | Same Day     | Normal    | 9.504      | 0.704 | 8.8         | 0            | 0      | 0           | OK       | uid:b829add7-6a3e-4ae8-b1df-4b6d3e65751b |

  @DeletePricingScript
  Scenario: Create Script  - with "const" Syntax Error (uid:9dc9ef39-4d5b-4334-b13a-ff8867df1435)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator send below data to create new Draft Script:
      | source | function calculatePricing(params){const price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else if(orderType=="CASH"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator clicks Check Syntax
    Then Operator verify error message
      | message  | Error Message: `const` is not support in the script. |
      | response | Status: 400 Unknown                                  |

  @DeletePricingScript
  Scenario Outline: Create and Check Script with rts_fee - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | function calculatePricing(params) {var price = 15.0;var result = {};result.delivery_fee = price;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;if (params.is_rts==true) {result.rts_fee = 1.0;} else if (params.is_rts==false) {result.rts_fee = 3.0;} else {result.rts_fee = 0.0}return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    And Operator validate and release Draft Script
    When Operator search according Active Script name
    When Operator do Run Check on specific Active Script using this data below:
      | orderFields  | New      |
      | serviceLevel | Same Day |
      | serviceType  | Document |
      | timeslotType | None     |
      | isRts        | <isRTS>  |
      | size         | XS       |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
      | fromZone     | EAST     |
      | toZone       | WEST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | <grandTotal> |
      | gst          | <gst>        |
      | deliveryFee  | 15           |
      | insuranceFee | 0            |
      | codFee       | 0            |
      | handlingFee  | 0            |
      | rtsFee       | <rtsFee>     |
      | comments     | OK           |
    Examples:
      | isRTS | dataset_name | grandTotal | gst  | hiptest-uid                              | rtsFee |
      | Yes   | is RTS = yes | 17.28      | 1.28 | uid:313b70a4-3803-40cd-8872-b08da89e3281 | 1      |
      | No    | is RTS = no  | 16.2       | 1.2  | uid:60033848-ac46-4be5-bb8a-2f79c06c85c4 | 0      |

  Scenario: Create Draft Pricing Script Failed - Not Fill Script Name and Script Description (uid:d5a25b08-13b9-442a-bd2c-ff5077e15371)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator send below data to create new Draft Script:
      | name        | empty                                                                                                                                                                                                                                                                                                                        |
      | description | empty                                                                                                                                                                                                                                                                                                                        |
      | source      | function calculatePricing(params) {var price = 15.0;var result = {};result.delivery_fee = price;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;if (params.is_rts==true) {result.rts_fee = 1.0;} else if (params.is_rts==false) {result.rts_fee = 3.0;} else {result.rts_fee = 0.0}return result;} |
    When Operator verifies Save Draft button is inactive in Pricing Script Page
    Then Operator clicks Check Syntax
    Then Operator clicks Verify Draft
    Then Operator verify error message
      | message | Please input a Script Name under the Script Info tab |

  Scenario: Create Draft Pricing Script Failed - Only Fill Script Description (uid:1e62adfe-08a5-4e7d-bcc2-d8cea3844a35)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator send below data to create new Draft Script:
      | name        | empty                                                                                                                                                                                                                                                                                                                        |
      | description | Test Script                                                                                                                                                                                                                                                                                                                  |
      | source      | function calculatePricing(params) {var price = 15.0;var result = {};result.delivery_fee = price;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;if (params.is_rts==true) {result.rts_fee = 1.0;} else if (params.is_rts==false) {result.rts_fee = 3.0;} else {result.rts_fee = 0.0}return result;} |
    When Operator verifies Save Draft button is inactive in Pricing Script Page
    Then Operator clicks Check Syntax
    Then Operator clicks Verify Draft
    Then Operator verify error message
      | message | Please input a Script Name under the Script Info tab |

  @DeletePricingScript
  Scenario Outline: Create and Check Script - Script has Legacy Params and Dimension Calculation - <dataset_name>
    Given Operator go to menu Shipper -> Pricing Scripts V2
    When Operator create new Draft Script using data below:
      | source | global = {weight_max: 20,weight_east: [25.0,25.0,25.0,25.0,68.0,84.0,99.0,115.0,146.0,161.0,176.0,207.0,223.0,238.0,253.0,269.0,284.0,300.0,315.0,330.0,346.0],weight_east_extra_perkg: 30,weight_west: [25.0,25.0,25.0,25.0,68.0,84.0,99.0,115.0,146.0,161.0,176.0,207.0,223.0,238.0,253.0,269.0,284.0,300.0,315.0,330.0,346.0],weight_west_extra_perkg: 30,lwh_max: 140,lwh_east: {"80":25.0,"90":84.0,"100":115.0,"110": 161.0,"120":223.0,"130":269.0,"140":330.0,"max": 346.0},lwh_east_extra_perkg: 30,lwh_west: {"80":25.0,"90":84.0,"100":115.0,"110": 161.0,"120":223.0,"130":269.0,"140":330.0,"max": 346.0},lwh_west_extra_perkg: 30,weight_rate: [],weight_extra: 0,lwh_rate: [],lwh_extra: 0,extra_weight_index: 0,weight_index: 0,};global.setRateCard = function (params) {if (params.to_zone == "EAST") {global.weight_rate = global.weight_east;global.weight_extra = global.weight_east_extra_perkg;global.lwh_rate = global.lwh_east;global.lwh_extra = global.lwh_east_extra_perkg} else {global.weight_rate = global.weight_west;global.weight_extra = global.weight_west_extra_perkg;global.lwh_rate = global.lwh_west;global.lwh_extra = global.lwh_west_extra_perkg}};global.setWeightIndex = function(params) {is_extra_weight_calc = false;if (params.weight > 0.5 && params.weight <= global.weight_max) {if (params.weight % 0.5 == 0 && params.weight % 1 == 0) {global.weight_index = Math.floor(params.weight / 0.5 / 2)} else {global.weight_index = Math.floor(params.weight / 0.5 / 2) + 1}} else if (params.weight > global.weight_max) {global.weight_index = global.weight_max;is_extra_weight_calc = true}extra_weight_index = 0;if (is_extra_weight_calc) {global.extra_weight_index = Math.ceil(params.weight - 20)}};function calculatePricing(params) {var result = {};result.delivery_fee = 0.0;result.cod_fee = 0.0;result.insurance_fee = 0.0;result.handling_fee = 0.0;if (params.service_level != "NEXTDAY") {throw "Not supported service_level: " + params.service_level}if (params.service_type != "Parcel") {throw "Not supported service_type: " + params.service_type}global.setWeightIndex(params);global.setRateCard(params);price_by_weight = global.weight_rate[global.weight_index] + (global.extra_weight_index * global.weight_extra);lwh = params.length + params.width + params.height;if (lwh > global.lwh_max) {price_by_lwh = global.lwh_rate["max"] + global.lwh_extra} else if (lwh) {for (key of Object.keys(global.lwh_rate)) {if (lwh <= parseInt(key)) {price_by_lwh = global.lwh_rate[key];break;}}} else {price_by_lwh = 0};result.delivery_fee = Math.max(price_by_weight, price_by_lwh); return result;} |
    Then Operator verify the new Script is created successfully on Drafts
    When Operator do Run Check on specific Draft Script using this data below:
      | orderFields  | New      |
      | serviceLevel | Next Day |
      | serviceType  | Parcel   |
      | length       | <length> |
      | width        | <width>  |
      | height       | <height> |
      | weight       | 8.0      |
      | fromZone     | EAST     |
      | toZone       | WEST     |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | <grandTotal>  |
      | gst          | <gst>         |
      | deliveryFee  | <deliveryFee> |
      | insuranceFee | 0             |
      | codFee       | 0             |
      | handlingFee  | 0             |
      | rtsFee       | 0             |
      | comments     | OK            |
    And Operator close page

    Examples:
      | length | width | height | grandTotal | gst   | deliveryFee | dataset_name |
      | 50     | 50    | 50     | 406.08     | 30.08 | 376         | Send LWH     |
      | 0      | 0     | 0      | 157.68     | 11.68 | 146         | No Send LWH  |

  Scenario: Check List Of Script Parameters on Write Script Page
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator go to Write Script Page
    Then Operator verifies presence of following parameters under "delivery_type" in Write Script page
      | SAME_DAY |
      | NEXT_DAY |
      | EXPRESS  |
      | STANDARD |
    Then Operator verifies presence of following parameters under "timeslot_type" in Write Script page
      | NONE      |
      | DAY_NIGHT |
      | TIMESLOT  |
    Then Operator verifies presence of following parameters under "size" in Write Script page
      | XS  |
      | S   |
      | M   |
      | L   |
      | XL  |
      | XXL |
    Then Operator verifies presence of following parameters under "order_type" in Write Script page
      | NORMAL |
      | RETURN |
      | C2C    |
    Then Operator verifies presence of following parameters under "service_type" in Write Script page
      | Parcel                    |
      | Document                  |
      | Return                    |
      | Marketplace               |
      | Bulky                     |
      | International             |
      | Ninja Pack                |
      | Marketplace International |
      | Corporate                 |
      | Corporate Return          |
      | Corporate AWB             |
      | Corporate Document        |
    Then Operator verifies presence of following parameters under "service_level" in Write Script page
      | SAMEDAY  |
      | NEXTDAY  |
      | EXPRESS  |
      | STANDARD |
    Then Operator verifies presence of following parameters under "first_mile_type" in Write Script page
      | PICKUP       |
      | PUDO_DROPOFF |
      | NONE         |
    Then Operator verifies presence of following parameters in Write Script page
      | weight                  |
      | from_zone               |
      | to_zone                 |
      | cod_value               |
      | insured_value           |
      | bulky_category_name     |
      | installation_required   |
      | flight_of_stairs        |
      | shipper_provided_length |
      | shipper_provided_width  |
      | shipper_provided_height |
      | shipper_provided_weight |
      | length                  |
      | width                   |
      | height                  |
      | from_l1                 |
      | from_l2                 |
      | from_l3                 |
      | to_l1                   |
      | to_l2                   |
      | to_l3                   |
      | from_metadata.l2_tier   |
      | to_metadata.l2_tier     |
      | is_rts                  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op