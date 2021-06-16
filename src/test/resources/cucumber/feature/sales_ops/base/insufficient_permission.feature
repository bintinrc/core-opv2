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

  @nadeera
  @KillBrowser @User2
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
    Then Operator waits for 2 seconds
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids
      | TEST |
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                                           |
      | bottom | Error Message: access denied due to insufficient Permissions. Required any of the scopes: [OPERATOR_ADMIN CORE_GET_SHIPPER_BILLING ALL_ACCESS INTERNAL_SERVICE] |

  @KillBrowser @User1
  Scenario: Search by Uploading CSV file - Insufficient Permissions (uid:1bf9760d-8c0f-4579-bf47-914c2d97deda)
    Given Operator go to menu Finance Tools -> Invoiced Orders Search
    Then Operator waits for 2 seconds
    And Operator upload a CSV file with below order ids on Invoiced Orders Search Page
      | TEST |
    And Operator clicks Search Invoiced Order button
    Then Operator verifies that error toast is displayed on Invoiced Orders Search page:
      | access denied due to insufficient Permissions. Required any of the scopes: [OPERATOR_ADMIN CORE_GET_SHIPPER_BILLING ALL_ACCESS INTERNAL_SERVICE] |

  @KillBrowser @User1
  Scenario: Search by Uploading CSV file - Insufficient Permissions
    Given Operator go to menu Finance Tools -> Invoiced Orders Search
    Then Operator waits for 2 seconds
    And Operator clicks in Enter Tracking ID(s) tab
    And Operator enters "TEST" tracking id on Invoiced Orders Search Page
    And Operator clicks Search Invoiced Order button
    Then Operator verifies that error toast is displayed on Invoiced Orders Search page:
      | access denied due to insufficient Permissions. Required any of the scopes: [OPERATOR_ADMIN CORE_GET_SHIPPER_BILLING ALL_ACCESS INTERNAL_SERVICE] |
