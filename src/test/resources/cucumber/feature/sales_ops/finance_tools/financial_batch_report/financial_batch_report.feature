@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @FinancialBatchReport

Feature: Financial Batch Report

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Gmail - Connect to "{financial-batch-report-email}" inbox using password "{financial-batch-report-email-password}"
    Given API Operator whitelist email "{financial-batch-report-email}"
    Given API Gmail - Operator marks all gmail messages as read

  Scenario: Generate Financial Batch Report -  Consolidated by "ALL" - All Shippers (uid:dea803b4-da56-461d-b2c9-b94cdddbf16f)
    Given Operator go to menu Finance Tools -> Financial Batch Report
    When Operator generates success financial batch report using data below:
      | startDate    | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate      | {gradle-previous-1-day-yyyy-MM-dd} |
      | For          | All Shippers                       |
      | generateFile | All orders batches in 1 file       |
      | emailAddress | {financial-batch-report-email}     |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    Then Operator verifies the financial batch report headers using data {default-financial-batch-headers}
    And Operator gets the financial batch csv report entries
    Then DB Billing - Operator verifies the count of entries for all ledgers by completed local date

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Generate Financial Batch Report - Consolidated by "ALL" - Selected Shipper - Ledger has Reversion and Adjustment Ledger Orders (uid:b99e203c-7139-482c-a0bd-32e9602fddd1)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id}                                           |
      | source          | Netsuite                                                           |
      | account_id      | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |
      | overall_balance | 0.00                                                               |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And DB Billing - Operator verifies the number of entries in billing_qa_gl.ledgers table is 1 for shipper id "{KEY_SHIPPER_SHIPPER.id}"
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Billing - Operator inserts payment entries to billing_qa_gl.journal table with below details
      | ledger_id                           | type   | subtype    | system_id     | amount |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Adjustment | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Adjustment | {KEY_COUNTRY} | 5.30   |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Reversion  | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Reversion  | {KEY_COUNTRY} | 5.30   |
    And API Billing - Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": "4.15", "event": "Payment", "source": "Netsuite","shipper_id": "{KEY_SHIPPER_SHIPPER.id}","type": "DEBIT","payment_method": "Banking","payee_info":{"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"},"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd}"} |
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["SHIPPER"], "global_shipper_ids": [ {KEY_SHIPPER_SHIPPER.id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    Then Operator verifies the financial batch report headers using data {default-financial-batch-headers}
    And Operator gets the financial batch csv report entries
    Then Operator verifies the count of csv entries is 1
    Then Operator verifies financial batch report data in CSV is as below
      | globalShipperId          | {KEY_SHIPPER_SHIPPER.id}         |
      | legacyShipperId          | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | shipperName              | {KEY_SHIPPER_SHIPPER.name}       |
      | date                     | {gradle-current-date-yyyy-MM-dd} |
      | totalCOD                 | -5.00                            |
      | CODAdjustment            | 34.32                            |
      | totalAdjustedCOD         | 29.32                            |
      | totalCODFees             | 0.05                             |
      | otherFees                | 9.18                             |
      | totalFees                | 9.23                             |
      | CODFeesAdjustment        | 0.00                             |
      | OtherFeesAdjustment      | -10.60                           |
      | TotalFeesAdjustment      | -10.60                           |
      | AmountDueToFromShipper   | 29.37                            |
      | AmountOwingToFromShipper | 4.23                             |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Generate Financial Batch Report - Consolidated by "ALL" - Selected Shipper - Batch with status OPEN is exists (uid:127b3e90-948c-47da-b152-d5f6f408a5d9)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id}                                           |
      | source          | Netsuite                                                           |
      | account_id      | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |
      | overall_balance | 0.00                                                               |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And DB Billing - Operator verifies the number of entries in billing_qa_gl.ledgers table is 1 for shipper id "{KEY_SHIPPER_SHIPPER.id}"
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["SHIPPER"], "global_shipper_ids": [ {KEY_SHIPPER_SHIPPER.id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and verifies the financial batch email body contains count as 0

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Generate Financial Batch Report - Consolidated by "ALL" - Selected By Parent Shipper (uid:2b0cce9d-cde9-409c-8a6e-6304ba5bf811)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Marketplace |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id}                                           |
      | source          | Netsuite                                                           |
      | account_id      | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |
      | overall_balance | 0.00                                                               |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And DB Billing - Operator verifies the number of entries in billing_qa_gl.ledgers table is 1 for shipper id "{KEY_SHIPPER_SHIPPER.id}"
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["ALL"], "parent_shipper_ids": [ {KEY_SHIPPER_SHIPPER.id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    Then Operator verifies the financial batch report headers using data {default-financial-batch-headers}
    And Operator gets the financial batch csv report entries
    Then Operator verifies the count of csv entries is 1
    Then Operator verifies financial batch report data in CSV is as below
      | globalShipperId          | {KEY_SHIPPER_SHIPPER.id}         |
      | legacyShipperId          | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | shipperName              | {KEY_SHIPPER_SHIPPER.name}       |
      | date                     | {gradle-current-date-yyyy-MM-dd} |
      | totalCOD                 | -5.00                            |
      | CODAdjustment            | 0.00                             |
      | totalAdjustedCOD         | -5.00                            |
      | totalCODFees             | 0.05                             |
      | otherFees                | 9.18                             |
      | totalFees                | 9.23                             |
      | CODFeesAdjustment        | 0.00                             |
      | OtherFeesAdjustment      | 0.00                             |
      | TotalFeesAdjustment      | 0.00                             |
      | AmountDueToFromShipper   | -4.95                            |
      | AmountOwingToFromShipper | 4.23                             |

  Scenario: Generate Financial Batch Report - Consolidated by "SHIPPER" - All Shippers (uid:39f855b2-3ac3-4bb3-9647-c00030c27eba)
    Given Operator go to menu Finance Tools -> Financial Batch Report
    When Operator generates success financial batch report using data below:
      | startDate    | {gradle-previous-1-day-yyyy-MM-dd}                 |
      | endDate      | {gradle-previous-1-day-yyyy-MM-dd}                 |
      | For          | All Shippers                                       |
      | generateFile | Batches consolidated by shipper (1 shipper 1 file) |
      | emailAddress | {financial-batch-report-email}                     |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    When DB Billing - Operator gets the count shippers from ledgers by completed local date
    Then Operator verifies the count of files in financial batch reports zip file

  Scenario: Generate Financial Batch Report - Consolidated by "SHIPPER" - Selected Shippers - Shipper Has Name with Emoji and TH/VN Characters (uid:3c626801-e1e2-4d52-b557-9a0ba4bc7e04)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-emoji-th-vn-chars-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-sop-emoji-th-vn-chars-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["SHIPPER"], "global_shipper_ids": [ {shipper-sop-emoji-th-vn-chars-global-id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    Then Operator verifies the financial batch report headers using data {default-financial-batch-headers}
    And Operator gets the financial batch csv report entries
    Then Operator verifies financial batch report data in CSV is as below
      | globalShipperId | {shipper-sop-emoji-th-vn-chars-global-id}                                 |
      | legacyShipperId | {shipper-sop-emoji-th-vn-chars-legacy-id}                                 |
      | shipperName     | QA-SO-Normal-Emoji/VN/TH-🙂 👀-ทดสอบ-đây là một người gửi hàng thử nghiệm |

  Scenario: Generate Financial Batch Report - Consolidated by "SHIPPER" - Selected Shippers - Shipper Has Long Name (uid:0b4554ca-6e5e-4936-8d60-703d237b417d)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-100-chars-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-sop-100-chars-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["SHIPPER"], "global_shipper_ids": [ {shipper-sop-100-chars-global-id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    And Operator gets the financial batch csv report entries
    Then Operator verifies financial batch report data in CSV is as below
      | globalShipperId | {shipper-sop-100-chars-global-id} |
      | legacyShipperId | {shipper-sop-100-chars-legacy-id} |
      | shipperName     | {shipper-sop-100-chars-name}      |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Generate Financial Batch Report - Consolidated by "SHIPPER" - Selected By Parent Shipper (uid:961925c6-25f7-4d04-9a89-44f5a8b4f6c0)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Marketplace |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id}                                           |
      | source          | Netsuite                                                           |
      | account_id      | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |
      | overall_balance | 0.00                                                               |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And DB Billing - Operator verifies the number of entries in billing_qa_gl.ledgers table is 1 for shipper id "{KEY_SHIPPER_SHIPPER.id}"
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["SHIPPER"], "parent_shipper_ids": [ {KEY_SHIPPER_SHIPPER.id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    Then Operator verifies the financial batch report headers using data {default-financial-batch-headers}
    And Operator gets the financial batch csv report entries
    Then Operator verifies the count of csv entries is 1
    Then Operator verifies financial batch report data in CSV is as below
      | globalShipperId          | {KEY_SHIPPER_SHIPPER.id}         |
      | legacyShipperId          | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | shipperName              | {KEY_SHIPPER_SHIPPER.name}       |
      | date                     | {gradle-current-date-yyyy-MM-dd} |
      | totalCOD                 | -5.00                            |
      | CODAdjustment            | 0.00                             |
      | totalAdjustedCOD         | -5.00                            |
      | totalCODFees             | 0.05                             |
      | otherFees                | 9.18                             |
      | totalFees                | 9.23                             |
      | CODFeesAdjustment        | 0.00                             |
      | OtherFeesAdjustment      | 0.00                             |
      | TotalFeesAdjustment      | 0.00                             |
      | AmountDueToFromShipper   | -4.95                            |
      | AmountOwingToFromShipper | 4.23                             |

  Scenario: Generate Financial Batch Report - Consolidated by "SHIPPER" - Selected By Parent Shipper - No Ledgers Found (uid:6a97e9f9-804b-4bc2-ad1d-0e8292d5ef76)
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-next-1-day-yyyy-MM-dd}","end_date": "{gradle-next-1-day-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["ALL"], "parent_shipper_ids": [ {shipper-sop-mktpl-v4-global-id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and verifies the financial batch email body contains count as 0

  Scenario: Generate Financial Batch Report -  Not Choose any Parent Shipper (uid:65e61c9b-5306-4b3b-a5d7-2fbfa6baeaf7)
    Given Operator go to menu Finance Tools -> Financial Batch Report
    When Operator select financial batch report using data below:
      | For          | Select By Parent Shipper       |
      | emailAddress | {financial-batch-report-email} |
    Then Operator verifies error message "Please select at least one marketplace." is displayed on Financial Batch Reports Page

  Scenario: Generate Financial Batch Report -  Not Choose any Shipper (uid:02ba4b0c-1fc0-4b20-81ba-9a6839712754)
    Given Operator go to menu Finance Tools -> Financial Batch Report
    When Operator select financial batch report using data below:
      | For          | Selected Shippers              |
      | emailAddress | {financial-batch-report-email} |
    Then Operator verifies error message "Please select at least one shipper." is displayed on Financial Batch Reports Page

  Scenario: Generate Financial Batch Report -  Input Invalid Recipient Emails (uid:963e9bac-58bd-4045-aab0-b311b1cdf496)
    Given Operator go to menu Finance Tools -> Financial Batch Report
    When Operator select financial batch report using data below:
      | For          | All Shippers  |
      | emailAddress | test@test.com |
    Then Operator verifies error message "Please only enter @ninjavan.co email(s)." is displayed on Financial Batch Reports Page

  Scenario: Generate Financial Batch Report -  Input Maximum Date Range (uid:d0974270-3ea3-4b57-8b38-dcefdeff6b23)
    Given Operator go to menu Finance Tools -> Financial Batch Report
    When Operator select financial batch report using data below:
      | startDate    | {gradle-previous-100-day-yyyy-MM-dd} |
      | endDate      | {gradle-previous-1-day-yyyy-MM-dd}   |
      | For          | All Shippers                         |
      | generateFile | All orders batches in 1 file         |
      | emailAddress | {financial-batch-report-email}       |
    Then Operator verifies error message "Maximum range allowed is 92 days. Current selection is 100 days." is displayed on Financial Batch Reports Page

  Scenario: Generate Financial Batch Report -  Input Maximum Date Range - Include Order-Level Details (uid:f6b7cc1c-f3ab-47aa-b269-f7e80fed27fd)
    Given Operator go to menu Finance Tools -> Financial Batch Report
    When Operator select financial batch report using data below:
      | reportDetails | yes                                  |
      | startDate     | {gradle-previous-100-day-yyyy-MM-dd} |
      | endDate       | {gradle-previous-1-day-yyyy-MM-dd}   |
      | For           | All Shippers                         |
      | generateFile  | All orders batches in 1 file         |
      | emailAddress  | {financial-batch-report-email}       |
    Then Operator verifies error message "Maximum range allowed is 14 days. Current selection is 100 days." is displayed on Financial Batch Reports Page

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Generate Financial Batch Report -  Consolidated by "ALL" - All Shippers - Include Order-Level Details (uid:8be8a6b0-8b9a-4b77-813e-48350d681dfe)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id}                                           |
      | source          | Netsuite                                                           |
      | account_id      | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |
      | overall_balance | 0.00                                                               |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"insured_value": 5, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And DB Billing - Operator verifies the number of entries in billing_qa_gl.ledgers table is 1 for shipper id "{KEY_SHIPPER_SHIPPER.id}"
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["ALL","EXTENDED_DETAILS"]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    And Operator gets financial batch reports with order level details
    Then Operator verifies financial batch report data in CSV is as below
      | globalShipperId          | {KEY_SHIPPER_SHIPPER.id}         |
      | legacyShipperId          | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | shipperName              | {KEY_SHIPPER_SHIPPER.name}       |
      | date                     | {gradle-current-date-yyyy-MM-dd} |
      | totalCOD                 | -5.00                            |
      | CODAdjustment            | 0.00                             |
      | totalAdjustedCOD         | -5.00                            |
      | totalCODFees             | 0.05                             |
      | otherFees                | 9.35                             |
      | totalFees                | 9.40                             |
      | CODFeesAdjustment        | 0.00                             |
      | OtherFeesAdjustment      | 0.00                             |
      | TotalFeesAdjustment      | 0.00                             |
      | AmountDueToFromShipper   | -4.95                            |
      | AmountOwingToFromShipper | 4.40                             |
    Then Operator verifies extended financial batch details report data in CSV is as below
      | batchId          | notNull                                       |
      | batchDate        | {gradle-current-date-yyyyMMdd}                |
      | shipperId        | {KEY_SHIPPER_SHIPPER.legacyId}                |
      | shipperName      | {KEY_SHIPPER_SHIPPER.name}                    |
      | trackingID       | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}         |
      | orderID          | {KEY_LIST_OF_CREATED_ORDERS[1].id}            |
      | nvMeasuredWeight | 1                                             |
      | fromCity         | null                                          |
      | toAddress        | 998 Toa Payoh North V4 NVQA V4 home SG 159363 |
      | toBillingZone    | WEST                                          |
      | codAmount        | -5.00                                         |
      | insuredAmount    | 5.00                                          |
      | codFee           | 0.05                                          |
      | codTax           | 0.00                                          |
      | insuredFee       | 0.10                                          |
      | deliveryFee      | 8.50                                          |
      | rtsFee           | 0.00                                          |
      | totalTax         | 0.69                                          |
      | totalWithTax     | 9.39                                          |
      | type             | Completed                                     |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Generate Financial Batch Report - Consolidated by "ALL" - Selected Shipper - Ledger has Reversion and Adjustment Ledger Orders - Include Order-Level Details (uid:d1fb59ef-3345-4402-8118-1759428ad95c)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id}                                           |
      | source          | Netsuite                                                           |
      | account_id      | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |
      | overall_balance | 0.00                                                               |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And DB Billing - Operator verifies the number of entries in billing_qa_gl.ledgers table is 1 for shipper id "{KEY_SHIPPER_SHIPPER.id}"
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Billing - Operator inserts payment entries to billing_qa_gl.journal table with below details
      | ledger_id                           | type   | subtype    | system_id     | amount |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Adjustment | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Adjustment | {KEY_COUNTRY} | 5.30   |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Reversion  | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Reversion  | {KEY_COUNTRY} | 5.30   |
    And API Billing - Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": "4.15", "event": "Payment", "source": "Netsuite","shipper_id": "{KEY_SHIPPER_SHIPPER.id}","type": "DEBIT","payment_method": "Banking","payee_info":{"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"},"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd}"} |
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["SHIPPER","EXTENDED_DETAILS"], "global_shipper_ids": [ {KEY_SHIPPER_SHIPPER.id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    And Operator gets financial batch reports with order level details
    Then Operator verifies financial batch report data in CSV is as below
      | globalShipperId          | {KEY_SHIPPER_SHIPPER.id}         |
      | legacyShipperId          | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | shipperName              | {KEY_SHIPPER_SHIPPER.name}       |
      | date                     | {gradle-current-date-yyyy-MM-dd} |
      | totalCOD                 | -5.00                            |
      | CODAdjustment            | 34.32                            |
      | totalAdjustedCOD         | 29.32                            |
      | totalCODFees             | 0.05                             |
      | otherFees                | 9.18                             |
      | totalFees                | 9.23                             |
      | CODFeesAdjustment        | 0.00                             |
      | OtherFeesAdjustment      | -10.60                           |
      | TotalFeesAdjustment      | -10.60                           |
      | AmountDueToFromShipper   | 29.37                            |
      | AmountOwingToFromShipper | 4.23                             |
    Then Operator verifies extended financial batch details report data in CSV is as below
      | batchId          | notNull                                       |
      | batchDate        | {gradle-current-date-yyyyMMdd}                |
      | shipperId        | {KEY_SHIPPER_SHIPPER.legacyId}                |
      | shipperName      | {KEY_SHIPPER_SHIPPER.name}                    |
      | trackingID       | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}         |
      | orderID          | {KEY_LIST_OF_CREATED_ORDERS[1].id}            |
      | nvMeasuredWeight | 1                                             |
      | fromCity         | null                                          |
      | toAddress        | 998 Toa Payoh North V4 NVQA V4 home SG 159363 |
      | toBillingZone    | WEST                                          |
      | codAmount        | -5.00                                         |
      | insuredAmount    | 0.00                                          |
      | codFee           | 0.05                                          |
      | codTax           | 0.00                                          |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 8.50                                          |
      | rtsFee           | 0.00                                          |
      | totalTax         | 0.68                                          |
      | totalWithTax     | 9.23                                          |
      | type             | Completed                                     |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Generate Financial Batch Report - Consolidated by "ALL" - Selected By Parent Shipper - Include Order-Level Details - Pricing Output Has 2 Decimal Places (uid:edba184e-559f-4c49-bd47-cc60a6bc7c75)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Marketplace |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id}                                           |
      | source          | Netsuite                                                           |
      | account_id      | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |
      | overall_balance | 0.00                                                               |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And DB Billing - Operator verifies the number of entries in billing_qa_gl.ledgers table is 1 for shipper id "{KEY_SHIPPER_SHIPPER.id}"
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["ALL","EXTENDED_DETAILS"], "parent_shipper_ids": [ {KEY_SHIPPER_SHIPPER.id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    And Operator gets financial batch reports with order level details
    Then Operator verifies financial batch report data in CSV is as below
      | globalShipperId          | {KEY_SHIPPER_SHIPPER.id}         |
      | legacyShipperId          | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | shipperName              | {KEY_SHIPPER_SHIPPER.name}       |
      | date                     | {gradle-current-date-yyyy-MM-dd} |
      | totalCOD                 | -5.00                            |
      | CODAdjustment            | 0.00                             |
      | totalAdjustedCOD         | -5.00                            |
      | totalCODFees             | 0.05                             |
      | otherFees                | 9.18                             |
      | totalFees                | 9.23                             |
      | CODFeesAdjustment        | 0.00                             |
      | OtherFeesAdjustment      | 0.00                             |
      | TotalFeesAdjustment      | 0.00                             |
      | AmountDueToFromShipper   | -4.95                            |
      | AmountOwingToFromShipper | 4.23                             |
    Then Operator verifies extended financial batch details report data in CSV is as below
      | batchId          | notNull                                       |
      | batchDate        | {gradle-current-date-yyyyMMdd}                |
      | shipperId        | {KEY_SHIPPER_SHIPPER.legacyId}                |
      | shipperName      | {KEY_SHIPPER_SHIPPER.name}                    |
      | trackingID       | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}         |
      | orderID          | {KEY_LIST_OF_CREATED_ORDERS[1].id}            |
      | nvMeasuredWeight | 1                                             |
      | fromCity         | null                                          |
      | toAddress        | 998 Toa Payoh North V4 NVQA V4 home SG 159363 |
      | toBillingZone    | WEST                                          |
      | codAmount        | -5.00                                         |
      | insuredAmount    | 0.00                                          |
      | codFee           | 0.05                                          |
      | codTax           | 0.00                                          |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 8.50                                          |
      | rtsFee           | 0.00                                          |
      | totalTax         | 0.68                                          |
      | totalWithTax     | 9.23                                          |
      | type             | Completed                                     |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Generate Financial Batch Report - Consolidated by "SHIPPER" - Selected Shipper - Include Order-Level Details
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id}                                           |
      | source          | Netsuite                                                           |
      | account_id      | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |
      | overall_balance | 0.00                                                               |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And DB Billing - Operator verifies the number of entries in billing_qa_gl.ledgers table is 1 for shipper id "{KEY_SHIPPER_SHIPPER.id}"
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    And API Billing - Operator generates financial batch report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}", "email_addresses": [ "{financial-batch-report-email}" ], "consolidated_options": ["SHIPPER","EXTENDED_DETAILS"], "global_shipper_ids": [ {KEY_SHIPPER_SHIPPER.id} ]} |
    And Finance Operator waits for "{financial-batch-report-email-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch report email
    And Operator gets financial batch reports with order level details
    Then Operator verifies extended financial batch details report data in CSV is as below
      | batchId          | notNull                                       |
      | batchDate        | {gradle-current-date-yyyyMMdd}                |
      | shipperId        | {KEY_SHIPPER_SHIPPER.legacyId}                |
      | shipperName      | {KEY_SHIPPER_SHIPPER.name}                    |
      | trackingID       | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}         |
      | orderID          | {KEY_LIST_OF_CREATED_ORDERS[1].id}            |
      | nvMeasuredWeight | 1                                             |
      | fromCity         | null                                          |
      | toAddress        | 998 Toa Payoh North V4 NVQA V4 home SG 159363 |
      | toBillingZone    | WEST                                          |
      | codAmount        | 0.00                                          |
      | insuredAmount    | 0.00                                          |
      | codFee           | 0.00                                          |
      | codTax           | 0.00                                          |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 8.50                                          |
      | rtsFee           | 0.00                                          |
      | totalTax         | 0.68                                          |
      | totalWithTax     | 9.18                                          |
      | type             | Completed                                     |
