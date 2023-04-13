@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @GetReportInLedger

Feature: Get Report in Ledger

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator whitelist email "{qa-email-address}"
    Given operator marks gmail messages as read

  @DeleteNewlyCreatedShipper
  Scenario: Get Report for All Orders in Batch - Batch Status is Ready - Ledger Only Has Completed Event (uid:0139cc98-05ee-464d-ae62-869d6910c159)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID}                                           |
      | source          | Netsuite                                                   |
      | account_id      | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} |
      | overall_balance | 0.00                                                       |
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
    Then Operator waits for 5 seconds
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | status | Open |
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 8 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Ready          |
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {qa-email-address} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received financial batch orders report email
    And Operator gets the extended financial batch reports csv file
    Then Operator verifies extended financial batch report data in CSV is as below
      | batchId          | notNull                                       |
      | batchDate        | {gradle-current-date-yyyyMMdd}                |
      | shipperId        | {KEY_LEGACY_SHIPPER_ID}                       |
      | shipperName      | {KEY_CREATED_SHIPPER.name}                    |
      | trackingID       | {KEY_CREATED_ORDER_TRACKING_ID}               |
      | orderID          | {KEY_CREATED_ORDER_ID}                        |
      | nvMeasuredWeight | 1                                             |
      | fromCity         | null                                          |
      | toAddress        | 998 Toa Payoh North V4 NVQA V4 home SG 159363 |
      | toBillingZone    | WEST                                          |
      | codAmount        | -5.00                                         |
      | insuredAmount    | 0.00                                          |
      | codFee           | 0.05                                          |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 8.50                                          |
      | rtsFee           | 0.00                                          |
      | totalTax         | 0.68                                          |
      | totalWithTax     | 9.23                                          |
      | type             | Completed                                     |

  @DeleteNewlyCreatedShipper
  Scenario Outline: Get Report for All Orders in Batch - Batch Status is In-Progress (uid:7b92cf01-2f08-4eb4-9300-e664f2684386)
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
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
    Then Operator waits for 5 seconds
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Open           |
    # Trigger scheduler to create 'Ready' ledger
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Ready          |
    # Create Payment
    And API Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": "<amount>", "event": "Payment", "source": "<source>","external_id": "<account_id>","type": "<type>","payment_method": "<payment_method>","payee_info": <payee_info>,"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "<transaction_no>"} |
    Then Operator waits for 10 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | In Progress    |
    # generate report from OPV2
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {qa-email-address} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received financial batch orders report email
    And Operator gets the extended financial batch reports csv file
    Then Operator verifies extended financial batch report data in CSV is as below
      | batchId          | notNull                                       |
      | batchDate        | {gradle-current-date-yyyyMMdd}                |
      | shipperId        | {KEY_LEGACY_SHIPPER_ID}                       |
      | shipperName      | {KEY_CREATED_SHIPPER.name}                    |
      | trackingID       | {KEY_CREATED_ORDER_TRACKING_ID}               |
      | orderID          | {KEY_CREATED_ORDER_ID}                        |
      | nvMeasuredWeight | 1                                             |
      | fromCity         | null                                          |
      | toAddress        | 998 Toa Payoh North V4 NVQA V4 home SG 159363 |
      | toBillingZone    | WEST                                          |
      | codAmount        | -50.00                                        |
      | insuredAmount    | 0.00                                          |
      | codFee           | 0.50                                          |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 8.50                                          |
      | rtsFee           | 0.00                                          |
      | totalTax         | 0.72                                          |
      | totalWithTax     | 9.72                                          |
      | type             | Completed                                     |
    Examples:
      | source   | account_id                                       | amount | type   | payment_method | payee_info                                                                                                                       | transaction_no                                             |
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 3.0    | CREDIT | Banking        | {"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"} | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} |

  @DeleteNewlyCreatedShipper @mad
  Scenario Outline: Get Report for All Orders in Batch - Batch Status is Completed (uid:7d8fa2e7-90cf-4fb7-9d48-21e055848bce)
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
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
    Then Operator waits for 5 seconds
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Open           |
    # Trigger scheduler to create 'Ready' ledger
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Ready          |
    # Create Payment
    And API Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": "<amount>", "event": "Payment", "source": "<source>","external_id": "<account_id>","type": "<type>","payment_method": "<payment_method>","payee_info": <payee_info>,"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "<transaction_no>"} |
    Then Operator waits for 10 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | In Progress    |
    # generate report from OPV2
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {qa-email-address} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received financial batch orders report email
    And Operator gets the extended financial batch reports csv file
    Then Operator verifies extended financial batch report data in CSV is as below
      | batchId          | notNull                                       |
      | batchDate        | {gradle-current-date-yyyyMMdd}                |
      | shipperId        | {KEY_LEGACY_SHIPPER_ID}                       |
      | shipperName      | {KEY_CREATED_SHIPPER.name}                    |
      | trackingID       | {KEY_CREATED_ORDER_TRACKING_ID}               |
      | orderID          | {KEY_CREATED_ORDER_ID}                        |
      | nvMeasuredWeight | 1                                             |
      | fromCity         | null                                          |
      | toAddress        | 998 Toa Payoh North V4 NVQA V4 home SG 159363 |
      | toBillingZone    | WEST                                          |
      | codAmount        | -50.00                                        |
      | insuredAmount    | 0.00                                          |
      | codFee           | 0.50                                          |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 8.50                                          |
      | rtsFee           | 0.00                                          |
      | totalTax         | 0.72                                          |
      | totalWithTax     | 9.72                                          |
      | type             | Completed                                     |
    Examples:
      | source   | account_id                                       | amount | type   | payment_method | payee_info                                                                                                                       | transaction_no                                             |
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 10.0   | CREDIT | Banking        | {"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"} | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} |

  @DeleteNewlyCreatedShipper
  Scenario: Get Report for All Orders in Batch - Batch Status is Ready - Ledger Has Completed and Returned to Sender Event (uid:fd4541f8-8579-43ab-a290-c33fca7a7480)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    # RTS order with no cod
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 1 seconds
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then Operator waits for 1 seconds
    And API Operator RTS order:
      | orderId    | {KEY_CREATED_ORDER_ID}                                                                                     |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" without cod
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And Operator verifies the number of entries in billing_qa_gl.ledgers table is 1
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Open           |
    # Trigger scheduler to create 'Ready' ledger
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Ready          |
    # generate report from OPV2
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {qa-email-address} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received financial batch orders report email
    And Operator gets the extended financial batch reports csv file
    Then Operator verifies extended financial batch report data in CSV is as below
      | batchId          | notNull                                    |
      | batchDate        | {gradle-current-date-yyyyMMdd}             |
      | shipperId        | {KEY_LEGACY_SHIPPER_ID}                    |
      | shipperName      | {KEY_CREATED_SHIPPER.name}                 |
      | trackingID       | {KEY_CREATED_ORDER_TRACKING_ID}            |
      | orderID          | {KEY_CREATED_ORDER_ID}                     |
      | nvMeasuredWeight | 1                                          |
      | fromCity         | null                                       |
      | toAddress        | 30 Jalan Kilang Barat NVQA V4 HQ SG 159364 |
      | toBillingZone    | WEST                                       |
      | codAmount        | 0.00                                       |
      | insuredAmount    | 0.00                                       |
      | codFee           | 0.00                                       |
      | insuredFee       | 0.00                                       |
      | deliveryFee      | 8.50                                       |
      | rtsFee           | 0.00                                       |
      | totalTax         | 0.68                                       |
      | totalWithTax     | 9.18                                       |
      | type             | Returned to Sender                         |


  @DeleteNewlyCreatedShipper
  Scenario Outline: Get Report for All Orders in Batch - Origin Balance Is In Thousands And Has 2 Decimal Places (uid:1f107c5c-32a4-46f2-8111-9530f2b7d39e)
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
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 2.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
    Then Operator waits for 5 seconds
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Open           |
    # Trigger scheduler to create 'Ready' ledger
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | Ready          |
    # Create Payment
    And API Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": "<amount>", "event": "Payment", "source": "<source>","external_id": "<account_id>","type": "<type>","payment_method": "<payment_method>","payee_info": <payee_info>,"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "<transaction_no>"} |
    Then Operator waits for 10 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column | expected_value |
      | status | In Progress    |
    # generate report from OPV2
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    And Operator generated financial batch report using data below:
      | emailAddress | {qa-email-address} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received financial batch orders report email
    And Operator gets the extended financial batch reports csv file
    Then Operator verifies extended financial batch report data in CSV is as below
      | batchId          | notNull                                       |
      | batchDate        | {gradle-current-date-yyyyMMdd}                |
      | shipperId        | {KEY_LEGACY_SHIPPER_ID}                       |
      | shipperName      | {KEY_CREATED_SHIPPER.name}                    |
      | trackingID       | {KEY_CREATED_ORDER_TRACKING_ID}               |
      | orderID          | {KEY_CREATED_ORDER_ID}                        |
      | nvMeasuredWeight | 2                                             |
      | fromCity         | null                                          |
      | toAddress        | 998 Toa Payoh North V4 NVQA V4 home SG 159363 |
      | toBillingZone    | WEST                                          |
      | codAmount        | -5000.00                                      |
      | insuredAmount    | 0.00                                          |
      | codFee           | 100.00                                        |
      | insuredFee       | 0.00                                          |
      | deliveryFee      | 19.00                                         |
      | rtsFee           | 0.00                                          |
      | totalTax         | 9.52                                          |
      | totalWithTax     | 128.52                                        |
      | type             | Completed                                     |
    Examples:
      | source   | account_id                                       | amount | type   | payment_method | payee_info                                                                                                                       | transaction_no                                             |
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 3.0    | CREDIT | Banking        | {"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"} | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} |
