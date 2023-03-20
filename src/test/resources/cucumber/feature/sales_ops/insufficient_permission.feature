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
    Then Operator clicks Create Draft button
    Then Operator verifies that error toast is displayed on Pricing Scripts V2 page:
      | top    | Network Request Error                                                                                                                                                       |
      | bottom | Access token verification failed: insufficient permissions (required scopes: INTERNAL_SERVICE, ADDRESSING_VIEW_PRICING_ZONES, ALL_ACCESS, OPERATOR_ADMIN, ADDRESSING_ADMIN) |

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
      | emailAddress | {qa-email-address} |
    Then Operator verifies that error toast is displayed on Financial Batch Reports page:
      | top    | Network Request Error                                                                                                                                           |
      | bottom | Error Message: access denied due to insufficient Permissions. Required any of the scopes: [OPERATOR_ADMIN CORE_GET_SHIPPER_BILLING ALL_ACCESS INTERNAL_SERVICE] |