@OperatorV2 @OperatorV2Part1 @LaunchBrowser @SalesOps
Feature: All test cases related to insufficient permission for Finance related pages in OperatorV2

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @KillBrowser @User1
  Scenario: Generate Success Billing - Insufficient Permissions (uid:9daad881-b61a-41a6-a49b-e972a1357e10)
    Given Operator go to menu Finance Tools -> Order Billing
    Then Operator waits for 3 seconds
    When Operator selects Order Billing data as below
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    Then Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                                           |
      | bottom | Error Message: access denied due to insufficient Permissions. Required any of the scopes: [OPERATOR_ADMIN CORE_GET_SHIPPER_BILLING ALL_ACCESS INTERNAL_SERVICE] |

  @KillBrowser @User1
  Scenario: Upload Invoiced Orders - Insufficient Permissions (uid:7868e75b-9772-4b82-a046-228327a80b0a)
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    When Upload Invoiced Orders page is loaded
    Then Operator waits for 2 seconds
    And Operator upload a CSV file with below order ids
      | TEST |
    Then Operator verifies that error toast is displayed on Upload Invoiced Orders page:
      | top    | Network Request Error                                                                                                                                           |
      | bottom | Error Message: access denied due to insufficient Permissions. Required any of the scopes: [OPERATOR_ADMIN CORE_GET_SHIPPER_BILLING ALL_ACCESS INTERNAL_SERVICE] |

  @KillBrowser @User1
  Scenario: Search by Uploading CSV file - Insufficient Permissions (uid:1bf9760d-8c0f-4579-bf47-914c2d97deda)
    Given Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    Then Operator waits for 2 seconds
    And Operator upload a CSV file with below order ids on Invoiced Orders Search Page
      | TEST |
    Then Operator verifies that error toast is displayed on Invoiced Orders Search page:
      | top    | Network Request Error                                                                                                                                           |
      | bottom | Error Message: access denied due to insufficient Permissions. Required any of the scopes: [OPERATOR_ADMIN CORE_GET_SHIPPER_BILLING ALL_ACCESS INTERNAL_SERVICE] |

  @KillBrowser @User1
  Scenario: Search by Uploading CSV file - Insufficient Permissions
    Given Operator go to menu Finance Tools -> Invoiced Orders Search
    Then Operator waits for 2 seconds
    When Search Invoiced Orders page is loaded
    And Operator clicks in Enter Tracking ID(s) tab
    And Operator enters "NVSGSLPSH0LFED90LE" tracking id on Invoiced Orders Search Page
    And Operator clicks Search Invoiced Order button
    Then Operator verifies that error toast is displayed on Invoiced Orders Search page:
      | top    | Network Request Error                                                                                                                                           |
      | bottom | Error Message: access denied due to insufficient Permissions. Required any of the scopes: [OPERATOR_ADMIN CORE_GET_SHIPPER_BILLING ALL_ACCESS INTERNAL_SERVICE] |


  @KillBrowser @User1
  Scenario: Create Pricing Script - Insufficient Permissions (uid:88fc357a-d47d-45c8-bac3-6d33f8dc7c12)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    Then Operator waits for 2 seconds
    When Operator send below data to create new Draft Script:
      | source | function calculatePricing(params){const price=0.0;var handlingFee=0.0;var insuranceFee=0.0;var codFee=0.0;var deliveryType=params.delivery_type;if(deliveryType=="STANDARD"){price+=0.3}else if(deliveryType=="EXPRESS"){price+=0.5}else if(deliveryType=="NEXT_DAY"){price+=0.7}else if(deliveryType=="SAME_DAY"){price+=1.1}else{throw"Unknown delivery type.";}var orderType=params.order_type;if(orderType=="NORMAL"){price+=1.3}else if(orderType=="RETURN"){price+=1.7}else if(orderType=="C2C"){price+=1.9}else if(orderType=="CASH"){price+=1.9}else{throw"Unknown order type.";}var timeslotType=params.timeslot_type;if(timeslotType=="NONE"){price+=2.3}else if(timeslotType=="DAY_NIGHT"){price+=2.9}else if(timeslotType=="TIMESLOT"){price+=3.1}else{throw"Unknown timeslot type.";}var size=params.size;if(size=="S"){price+=3.7}else if(size=="M"){price+=4.1}else if(size=="L"){price+=4.3}else if(size=="XL"){price+=4.7}else if(size=="XXL"){price+=5.3}else{throw"Unknown size.";}price+=params.weight;var fromBillingZone=params.from_zone;var toBillingZone=params.to_zone;if(fromBillingZone=="EAST"){handlingFee+=0.3}else if(fromBillingZone=="WEST"){handlingFee+=0.5}if(toBillingZone=="EAST"){handlingFee+=0.7}else if(toBillingZone=="WEST"){handlingFee+=1.1}var result={};result.delivery_fee=price;result.cod_fee=codFee;result.insurance_fee=insuranceFee;result.handling_fee=handlingFee;return result} |
    Then Operator clicks Check Syntax
    Then Operator verify error message
      | message  | Error Message: Access token verification failed: insufficient permissions (required scopes: INTERNAL_SERVICE, ALL_ACCESS, SCRIPT_CREATE, SCRIPT_ADMIN) |
      | response | Status: 403 Unknown                                                                                                                                    |

  @KillBrowser @User1
  Scenario: Create New Template - Insufficient Access (uid:bed23b59-043e-4284-a0a6-5de2bfdca2ab)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID                                                |
    Then Operator verifies that error toast is displayed on SSB Template page:
      | top    | Network Request Error                                                                                                                 |
      | bottom | Error Message: access denied due to insufficient Permissions. Required any of the scopes: [FINANCE_ADMIN ALL_ACCESS INTERNAL_SERVICE] |

  @KillBrowser @User1
  Scenario: Generate Financial Batch Report - Insufficient Permissions (uid:79e4fb77-e56b-434c-b8e6-0272451a3d37)
    Given Operator go to menu Finance Tools -> Financial Batch Report
    Then Operator waits for 3 seconds
    When Operator select financial batch report using data below:
      | For          | All Shippers          |
      | emailAddress | {order-billing-email} |
    Then Operator verifies that error toast is displayed on Financial Batch Reports page:
      | top    | Network Request Error                                                                                                                                           |
      | bottom | Error Message: access denied due to insufficient Permissions. Required any of the scopes: [OPERATOR_ADMIN CORE_GET_SHIPPER_BILLING ALL_ACCESS INTERNAL_SERVICE] |