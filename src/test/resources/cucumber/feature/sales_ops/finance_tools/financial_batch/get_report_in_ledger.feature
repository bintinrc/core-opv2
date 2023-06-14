@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @GetReportInLedger

Feature: Get Report in Ledger

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Gmail - Connect to "{financial-batch-report-email}" inbox using password "{financial-batch-report-email-password}"
    Given API Operator whitelist email "{financial-batch-report-email}"
    Given API Gmail - Operator marks all gmail messages as read

  @DeleteCreatedShipper
  Scenario: Get Report for All Orders in Batch - Batch Status is Ready - Ledger Only Has Completed Event (uid:0139cc98-05ee-464d-ae62-869d6910c159)
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
    Then Operator waits for 5 seconds
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | status | Open |
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | column | expected_value |
      | status | Ready          |
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {financial-batch-report-email} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch order report email
    And Operator gets the extended financial batch reports csv file data
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

  @DeleteCreatedShipper
  Scenario Outline: Get Report for All Orders in Batch - Batch Status is In-Progress (uid:7b92cf01-2f08-4eb4-9300-e664f2684386)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id} |
      | source          | <source>>                |
      | account_id      | <account_id>             |
      | overall_balance | 0.00                     |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then Operator waits for 5 seconds
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | status | Open |
    # Trigger scheduler to create 'Ready' ledger
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | column | expected_value |
      | status | Ready          |
    # Create Payment
    And API Billing - Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": "<amount>", "event": "Payment", "source": "<source>","shipper_id": "{KEY_SHIPPER_SHIPPER.id}","type": "<type>","payment_method": "<payment_method>","payee_info": <payee_info>,"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "<transaction_no>"} |
    Then Operator waits for 10 seconds
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | column | expected_value |
      | status | In Progress    |
    # generate report from OPV2
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {financial-batch-report-email} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch order report email
    And Operator gets the extended financial batch reports csv file data
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
      | codAmount        | -50.00                                        |
      | insuredAmount    | 0.00                                          |
      | codFee           | 0.50                                          |
      | codTax           | 0.04                                          |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 8.50                                          |
      | rtsFee           | 0.00                                          |
      | totalTax         | 0.72                                          |
      | totalWithTax     | 9.72                                          |
      | type             | Completed                                     |
    Examples:
      | source   | account_id                                       | amount | type   | payment_method | payee_info                                                                                                                               | transaction_no                                                     |
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 3.0    | CREDIT | Banking        | {"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"} | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |

  @DeleteCreatedShipper
  Scenario Outline: Get Report for All Orders in Batch - Batch Status is Completed (uid:7d8fa2e7-90cf-4fb7-9d48-21e055848bce)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id} |
      | source          | <source>>                |
      | account_id      | <account_id>             |
      | overall_balance | 0.00                     |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then Operator waits for 5 seconds
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | status | Open |
    # Trigger scheduler to create 'Ready' ledger
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | column | expected_value |
      | status | Ready          |
    # Create Payment
    And API Billing - Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": "<amount>", "event": "Payment", "source": "<source>","shipper_id": "{KEY_SHIPPER_SHIPPER.id}","type": "<type>","payment_method": "<payment_method>","payee_info": <payee_info>,"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "<transaction_no>"} |
    Then Operator waits for 10 seconds
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | column | expected_value |
      | status | In Progress    |
    # generate report from OPV2
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {financial-batch-report-email} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch order report email
    And Operator gets the extended financial batch reports csv file data
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
      | codAmount        | -50.00                                        |
      | insuredAmount    | 0.00                                          |
      | codFee           | 0.50                                          |
      | codTax           | 0.04                                          |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 8.50                                          |
      | rtsFee           | 0.00                                          |
      | totalTax         | 0.72                                          |
      | totalWithTax     | 9.72                                          |
      | type             | Completed                                     |
    Examples:
      | source   | account_id                                       | amount | type   | payment_method | payee_info                                                                                                                               | transaction_no                                                     |
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 10.0   | CREDIT | Banking        | {"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"} | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |

  @DeleteCreatedShipper
  Scenario: Get Report for All Orders in Batch - Batch Status is Ready - Ledger Has Completed and Returned to Sender Event (uid:fd4541f8-8579-43ab-a290-c33fca7a7480)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    # RTS order with no cod
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 1 seconds
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    Then Operator waits for 1 seconds
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "false"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then Operator waits for 5 seconds
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | status | Open |
    # Trigger scheduler to create 'Ready' ledger
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | column | expected_value |
      | status | Ready          |
    # generate report from OPV2
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {financial-batch-report-email} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch order report email
    And Operator gets the extended financial batch reports csv file data
    Then Operator verifies extended financial batch details report data in CSV is as below
      | batchId          | notNull                                    |
      | batchDate        | {gradle-current-date-yyyyMMdd}             |
      | shipperId        | {KEY_SHIPPER_SHIPPER.legacyId}             |
      | shipperName      | {KEY_SHIPPER_SHIPPER.name}                 |
      | trackingID       | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}      |
      | orderID          | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | nvMeasuredWeight | 1                                          |
      | fromCity         | null                                       |
      | toAddress        | 30 Jalan Kilang Barat NVQA V4 HQ SG 159364 |
      | toBillingZone    | WEST                                       |
      | codAmount        | 0.00                                       |
      | insuredAmount    | 0.00                                       |
      | codFee           | 0.00                                       |
      | codTax           | 0.00                                       |
      | insuredFee       | 0.00                                       |
      | deliveryFee      | 8.50                                       |
      | rtsFee           | 0.00                                       |
      | totalTax         | 0.68                                       |
      | totalWithTax     | 9.18                                       |
      | type             | Returned to Sender                         |

  @DeleteCreatedShipper
  Scenario Outline: Get Report for All Orders in Batch - Origin Balance Is In Thousands And Has 2 Decimal Places (uid:1f107c5c-32a4-46f2-8111-9530f2b7d39e)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    And DB Billing - Operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_SHIPPER.id} |
      | source          | <source>>                |
      | account_id      | <account_id>             |
      | overall_balance | 0.00                     |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 2.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then Operator waits for 5 seconds
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | status | Open |
    # Trigger scheduler to create 'Ready' ledger
    And API Billing - Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | column | expected_value |
      | status | Ready          |
    # Create Payment
    And API Billing - Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": "<amount>", "event": "Payment", "source": "<source>","shipper_id": "{KEY_SHIPPER_SHIPPER.id}","type": "<type>","payment_method": "<payment_method>","payee_info": <payee_info>,"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "<transaction_no>"} |
    Then Operator waits for 10 seconds
    Then DB Billing - Operator gets ledger details for shipper "{KEY_SHIPPER_SHIPPER.id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table as below
      | column | expected_value |
      | status | In Progress    |
    # generate report from OPV2
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_SHIPPER_SHIPPER.legacyId}   |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {financial-batch-report-email} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received financial batch order report email
    And Operator gets the extended financial batch reports csv file data
    Then Operator verifies extended financial batch details report data in CSV is as below
      | batchId          | notNull                                       |
      | batchDate        | {gradle-current-date-yyyyMMdd}                |
      | shipperId        | {KEY_SHIPPER_SHIPPER.legacyId}                |
      | shipperName      | {KEY_SHIPPER_SHIPPER.name}                    |
      | trackingID       | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}         |
      | orderID          | {KEY_LIST_OF_CREATED_ORDERS[1].id}            |
      | nvMeasuredWeight | 2                                             |
      | fromCity         | null                                          |
      | toAddress        | 998 Toa Payoh North V4 NVQA V4 home SG 159363 |
      | toBillingZone    | WEST                                          |
      | codAmount        | -5000.00                                      |
      | insuredAmount    | 0.00                                          |
      | codFee           | 100.00                                        |
      | codTax           | 8.00                                          |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 19.00                                         |
      | rtsFee           | 0.00                                          |
      | totalTax         | 9.52                                          |
      | totalWithTax     | 128.52                                        |
      | type             | Completed                                     |
    Examples:
      | source   | account_id                                       | amount | type   | payment_method | payee_info                                                                                                                               | transaction_no                                                     |
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 3.0    | CREDIT | Banking        | {"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"} | QA-SO-AUTO-{KEY_SHIPPER_SHIPPER.id}-{gradle-current-date-yyyyMMdd} |
