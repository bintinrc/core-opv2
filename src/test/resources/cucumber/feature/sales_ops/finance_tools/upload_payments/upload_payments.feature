@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @UploadPayments
Feature: Upload Payments

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  Scenario: Operator Download CSV Payment Template For Shipper ID
    Given Operator go to menu Finance Tools -> Upload Payments
    When Operator clicks on Download Template CSV dropdown
    Then Operator clicks on "Template Shipper ID" option
    And Operator verifies that downloaded csv file for "Template Shipper ID" is same as "{upload-payments-template-shipper-id-sample-csv}"

@test
 # - passed
Scenario: Operator Download CSV Payment Template For Netsuite ID
  Given Operator go to menu Finance Tools -> Upload Payments
  When  Operator clicks on Download Template CSV dropdown
  Then  Operator clicks on "Template Netsuite ID" option
  And Operator verifies that downloaded csv file for "Template Netsuite ID" is same as "{upload-payments-template-netsuite-id-sample-csv}"


  Scenario: Operator Upload CSV Payment Template With Both Shipper ID And Netsuite ID
    Given Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | netsuite_id                                      | shipper_id |
      | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 9999999    |
    Then Operator verifies that error toast is displayed on Upload Payments page:
      | top    | Error uploading file                                                         |
      | bottom | Please provide only shipper id or netsuite ID, not both (refer to template). |


  Scenario: Operator Upload CSV Payment Template With No Shipper ID and Netsuite ID
    Given Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | remittance_date                  | amount |
      | {gradle-current-date-yyyy-MM-dd} | 5.0    |
    Then Operator verifies that error toast is displayed on Upload Payments page:
      | top    | Error uploading file                                          |
      | bottom | Please provide shipper id or netsuite ID (refer to template). |

  Scenario: Operator Upload CSV Payment Template With Some Mandatory Fields Not Exist
    Given Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | netsuite_id                                      | remittance_date                  | amount |
      | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | {gradle-current-date-yyyy-MM-dd} | 5.0    |
    Then Operator verifies that error toast is displayed on Upload Payments page:
      | top    | Error uploading file                                              |
      | bottom | Not all compulsory headers are present. Please refer to template. |

  @DeleteNewlyCreatedShipper
  Scenario: Operator Upload CSV Payment With Invalid Account ID (Not Exist)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    Given Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | netsuite_id | remittance_date                  | amount | transaction_number                    | transaction_type | payment_method | payee_name       | payee_account_number                                       | payee_bank |
      | test        | {gradle-current-date-yyyy-MM-dd} | 10.0   | {gradle-current-date-yyyyMMddHHmmsss} | CREDIT           | Banking        | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then DB Billing - Operator verify new payment for "{KEY_SHIPPER_ID}" shipper is not added to billing_qa_gl.transaction table

  @test
  Scenario: Operator Upload CSV Payment With Invalid Shipper ID (Not Exist)
    Given Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id                | remittance_date                  | amount | transaction_number                    | transaction_type | payment_method | payee_name       | payee_account_number                                       | payee_bank |
      | {shipper-non-existent-id} | {gradle-current-date-yyyy-MM-dd} | 5.0    | {gradle-current-date-yyyyMMddHHmmsss} | CREDIT           | Banking        | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |
    Then Operator verifies that error toast is displayed on Upload Payments page:
      | top    | Network Request Error    |
      | bottom | Legacy Shipper Not Found |
    Then Operator - verifies csv file is not successfully uploaded on the Upload Payments page
    Then DB Billing - Operator verify new payment for "{shipper-non-existent-id}" shipper is not added to billing_qa_gl.transaction table

  @test
  Scenario: Operator Upload CSV Payment Wrong Combination Between Transaction Type and Transaction Event
    Given Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id                | remittance_date                  | amount | transaction_number                    | transaction_event | transaction_type | payment_method | payee_name       | payee_account_number                                       | payee_bank |
      | {shipper-non-existent-id} | {gradle-current-date-yyyy-MM-dd} | 5.0    | {gradle-current-date-yyyyMMddHHmmsss} | Remittance        | In               | Banking        | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |
    Then Operator - verifies csv file is not successfully uploaded on the Upload Payments page
    Then Operator - verify Error Upload Payment CSV file is downloaded successfully on Upload Payments Page with below data:
      | message | invalid transaction type |
    Then DB Billing - Operator verify new payment for "{shipper-non-existent-id}" shipper is not added to billing_qa_gl.transaction table

  @test
  Scenario: Operator Upload CSV Payment With Transaction Event = Account Correction
    Given Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id                | remittance_date                  | amount | transaction_number                    | transaction_event  | transaction_type | payment_method | payee_name       | payee_account_number                                       | payee_bank |
      | {shipper-non-existent-id} | {gradle-current-date-yyyy-MM-dd} | 5.0    | {gradle-current-date-yyyyMMddHHmmsss} | Account Correction | In               | Banking        | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |
    Then Operator - verifies csv file is not successfully uploaded on the Upload Payments page
    Then Operator - verify Error Upload Payment CSV file is downloaded successfully on Upload Payments Page with below data:
      | message | invalid transaction type |
    Then DB Billing - Operator verify new payment for "{shipper-non-existent-id}" shipper is not added to billing_qa_gl.transaction table

  @test
  Scenario: Operator Upload CSV Payment With Invalid Transaction Type
    Given Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id                | remittance_date                  | amount | transaction_number                    | transaction_type | payment_method | payee_name       | payee_account_number                                       | payee_bank |
      | {shipper-non-existent-id} | {gradle-current-date-yyyy-MM-dd} | 5.0    | {gradle-current-date-yyyyMMddHHmmsss} | OTHERS           | Banking        | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |
    Then Operator - verifies csv file is not successfully uploaded on the Upload Payments page
    Then Operator - verify Error Upload Payment CSV file is downloaded successfully on Upload Payments Page with below data:
      | message | invalid transaction type |
    Then DB Billing - Operator verify new payment for "{shipper-non-existent-id}" shipper is not added to billing_qa_gl.transaction table


  @DeleteNewlyCreatedShipper
  Scenario Outline: Operator Upload CSV Payment With Date Format = D/MM/YYYY
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID} |
      | source          | <source>         |
      | account_id      | <account_id>     |
      | overall_balance | 0.00             |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" with cod
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" with cod
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" is added to billing_qa_gl.priced_orders
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" is added to billing_qa_gl.priced_orders
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Open           |
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    And Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | netsuite_id  | remittance_date                  | amount   | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | <account_id> | {gradle-current-date-dd/MM/yyyy} | <amount> | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 5 seconds
    Then DB Operator gets payment details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_SHIPPER_ID}                                                                           |
      | parent_shipper_id | null                                                                                       |
      | amount            | <amount>                                                                                   |
      | type              | <type>                                                                                     |
      | subtype           | Full                                                                                       |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
      | event             | Remittance                                                                                 |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value       |
      | origin_balance | -<amount>            |
      | total_remitted | -<amount>            |
      | balance        | 0.00                 |
      | status         | Completed            |
      | status_logs    | Open,Ready,Completed |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>      |
      | overall_balance | 0.0           |
      | logs            | -<amount>,0.0 |
    Then Operator gets price order details from the billing_qa_gl.priced_orders table
    Then Operator verifies below details in billing_qa_gl.priced_orders table
      | column       | expected_value        |
      | payment_tags | COD_REMITTED,FEE_PAID |
    Then DB Billing - Operator gets order_payment_tags from the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies below details in billing_qa_gl.order_payment_tags table for tracking_id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
      | column            | expected_value         |
      | order_id          | {KEY_CREATED_ORDER_ID} |
      | shipper_id        | {KEY_SHIPPER_ID}       |
      | parent_shipper_id | null                   |
    Examples:
      | source   | account_id                                           | amount | type   | payment_method | transaction_no                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-TC1-{gradle-current-date-yyyyMMddHHmmsss} | 81.64  | CREDIT | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |

  @test
    @DeleteNewlyCreatedShipper
  Scenario Outline: Upload Payment with Shipper ID Template - Upload Invoiced Orders - Check Payments Tags
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID} |
      | source          | <source>         |
      | account_id      | <account_id>     |
      | overall_balance | 0.00             |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" with cod
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" with cod
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" is added to billing_qa_gl.priced_orders
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" is added to billing_qa_gl.priced_orders
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Open           |
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    And Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | netsuite_id  | remittance_date                  | amount   | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | <account_id> | {gradle-current-date-dd/MM/yyyy} | <amount> | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 5 seconds
    Then DB Operator gets payment details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column         | expected_value                                                                             |
      | subtype        | Full                                                                                       |
      | payment_method | <payment_method>                                                                           |
      | payee_info     | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value       |
      | origin_balance | -<amount>            |
      | total_remitted | -<amount>            |
      | balance        | 0.00                 |
      | status         | Completed            |
      | status_logs    | Open,Ready,Completed |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>      |
      | overall_balance | 0.0           |
      | logs            | -<amount>,0.0 |
      #upload invoiced orders
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    When Upload Invoiced Orders page is loaded
    And Operator upload a CSV file with below order ids and verify success message
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    Then DB Billing - Operator gets order_payment_tags from the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies below details in billing_qa_gl.order_payment_tags table for tracking_id "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
      | column            | expected_value                   |
      | order_id          | {KEY_CREATED_ORDER_ID}           |
      | shipper_id        | {KEY_SHIPPER_ID}                 |
      | parent_shipper_id | null                             |
      | invoiced_at       | {gradle-current-date-yyyy-MM-dd} |
    Then Operator gets price order details from the billing_qa_gl.priced_orders table
    Then Operator verifies below details in billing_qa_gl.priced_orders table
      | column       | expected_value                 |
      | payment_tags | COD_REMITTED,FEE_PAID,INVOICED |
    Then DB Billing - Operator gets order_payment_tags from the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies below details in billing_qa_gl.order_payment_tags table for tracking_id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
      | column            | expected_value                   |
      | order_id          | {KEY_CREATED_ORDER_ID}           |
      | shipper_id        | {KEY_SHIPPER_ID}                 |
      | parent_shipper_id | null                             |
      | invoiced_at       | {gradle-current-date-yyyy-MM-dd} |
    Examples:
      | source   | account_id                                           | amount | type   | payment_method | transaction_no                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-TC1-{gradle-current-date-yyyyMMddHHmmsss} | 81.64  | CREDIT | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |

  @DeleteNewlyCreatedShipper
  Scenario Outline: Upload Invoiced Orders - Upload CSV Payment with Shipper Template - Check Payment Tags
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID} |
      | source          | <source>         |
      | account_id      | <account_id>     |
      | overall_balance | 0.00             |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" with cod
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" with cod
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" is added to billing_qa_gl.priced_orders
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" is added to billing_qa_gl.priced_orders
        #upload invoiced orders
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    When Upload Invoiced Orders page is loaded
    And Operator upload a CSV file with below order ids and verify success message
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    Then DB Billing - Operator gets order_payment_tags from the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies below details in billing_qa_gl.order_payment_tags table for tracking_id "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
      | column            | expected_value                   |
      | order_id          | {KEY_CREATED_ORDER_ID}           |
      | shipper_id        | {KEY_SHIPPER_ID}                 |
      | parent_shipper_id | null                             |
      | invoiced_at       | {gradle-current-date-yyyy-MM-dd} |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Open           |
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    And Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | netsuite_id  | remittance_date                  | amount   | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | <account_id> | {gradle-current-date-dd/MM/yyyy} | <amount> | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 5 seconds
    Then DB Operator gets payment details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column         | expected_value                                                                             |
      | subtype        | Full                                                                                       |
      | payment_method | <payment_method>                                                                           |
      | payee_info     | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value       |
      | origin_balance | -<amount>            |
      | total_remitted | -<amount>            |
      | balance        | 0.00                 |
      | status         | Completed            |
      | status_logs    | Open,Ready,Completed |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>      |
      | overall_balance | 0.0           |
      | logs            | -<amount>,0.0 |
    Then Operator gets price order details from the billing_qa_gl.priced_orders table
    Then Operator verifies below details in billing_qa_gl.priced_orders table
      | column       | expected_value                 |
      | payment_tags | COD_REMITTED,FEE_PAID,INVOICED |
    Then DB Billing - Operator gets order_payment_tags from the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies below details in billing_qa_gl.order_payment_tags table for tracking_id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
      | column            | expected_value                   |
      | order_id          | {KEY_CREATED_ORDER_ID}           |
      | shipper_id        | {KEY_SHIPPER_ID}                 |
      | parent_shipper_id | null                             |
      | invoiced_at       | {gradle-current-date-yyyy-MM-dd} |
    Examples:
      | source   | account_id                                           | amount | type   | payment_method | transaction_no                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-TC1-{gradle-current-date-yyyyMMddHHmmsss} | 81.64  | CREDIT | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |
