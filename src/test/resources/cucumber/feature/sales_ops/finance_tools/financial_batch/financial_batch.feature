@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @FinancialBatch

Feature: Financial Batch

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who has Ledger Status is Open (uid:74164c51-0c87-496d-8088-3b9768394fd9)
    Given API Operator create new normal shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID}                                 |
      | source          | Netsuite                                         |
      | account_id      | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
      | overall_balance | 0.00                                             |
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}"
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And Operator verifies the number of entries in billing_qa_gl.ledgers table is 1
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies error message is displayed in Financial Batch page
      | No batch found for the specified shipper on the specified date. |
    Then Operator verifies financial batch data as below
      | overallBalance | S$ 0.00 (Debit) |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who doesn't have Ledger and Shipper Account (uid:a9f8aa2b-114a-42fb-ab48-57ff67797090)
    Given API Operator create new normal shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies error message is displayed in Financial Batch page
      | Error when fetching shipper account balance.                    |
      | No batch found for the specified shipper on the specified date. |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who doesn't have Ledger but has Shipper Account (uid:8f388ed1-4113-48b4-b5a8-39d1c3bc7e3e)
    Given API Operator create new normal shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID}                                 |
      | source          | Netsuite                                         |
      | account_id      | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
      | overall_balance | 0.00                                             |
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies error message is displayed in Financial Batch page
      | No batch found for the specified shipper on the specified date. |
    Then Operator verifies financial batch data as below
      | overallBalance | S$ 0.00 (Debit) |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who has Ledger And Shipper Account -  Ledger Status is Ready - Ledger has Origin Balance less than 0 - Overall Balance is < -1000 (uid:c679ca84-cb91-4b5a-9969-e38684380fcf)
    Given API Operator create new normal shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID}                                 |
      | source          | Netsuite                                         |
      | account_id      | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
      | overall_balance | 0.00                                             |
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}"
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies financial batch data as below
      | overallBalance        | S$ 41.97 (Credit)                |
      | date                  | {gradle-current-date-dd/MM/yyyy} |
      | shipperName           | {KEY_CREATED_SHIPPER.name}       |
      | debitTotalCOD         | 0.00                             |
      | debitTotalFee         | 8.03                             |
      | debitTotalAdjustment  | 0.00                             |
      | debitNettBalance      | 0.00                             |
      | creditTotalCOD        | 50.00                            |
      | creditTotalFee        | 0.00                             |
      | creditTotalAdjustment | 0.00                             |
      | creditNettBalance     | 41.97                            |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who has Ledger and Shipper Account -  Ledger Status is Ready - Ledger has Origin Balance more than 0 - Overall Balance is > 1000 (uid:03a4c18c-c26b-4a4b-ab40-2d2742149cdf)
    Given API Operator create new normal shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID}                                 |
      | source          | Netsuite                                         |
      | account_id      | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
      | overall_balance | 0.00                                             |
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 499.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}"
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And Operator verifies the number of entries in billing_qa_gl.ledgers table is 1
    And API Operator trigger reconcile scheduler endpoint
    And Operator waits for 5 seconds
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies financial batch data as below
      | overallBalance        | S$ 4,798.28 (Debit)              |
      | date                  | {gradle-current-date-dd/MM/yyyy} |
      | shipperName           | {KEY_CREATED_SHIPPER.name}       |
      | debitTotalCOD         | 0.00                             |
      | debitTotalFee         | 4,803.28                         |
      | debitTotalAdjustment  | 0.00                             |
      | debitNettBalance      | 4,798.28                         |
      | creditTotalCOD        | 5.00                             |
      | creditTotalFee        | 0.00                             |
      | creditTotalAdjustment | 0.00                             |
      | creditNettBalance     | 0.00                             |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who has Ledger and Shipper Account -  Ledger Status is In Progress - Ledger has Origin Balance less than 0 - Overall Balance is < -1000 (uid:73529832-c3e3-4b45-8034-035803842480)
    Given API Operator create new normal shipper
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
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    And API Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": 5,"source": "Netsuite","shipper_id": "{KEY_SHIPPER_ID}","type": "CREDIT","payment_method": "Banking","payee_info":{"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"},"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}"} |
    Then Operator waits for 5 seconds
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies financial batch data as below
      | overallBalance        | S$ 4,880.51 (Credit)             |
      | date                  | {gradle-current-date-dd/MM/yyyy} |
      | shipperName           | {KEY_CREATED_SHIPPER.name}       |
      | debitTotalCOD         | 0.00                             |
      | debitTotalFee         | 114.49                           |
      | debitTotalAdjustment  | 0.00                             |
      | debitNettBalance      | 0.00                             |
      | creditTotalCOD        | 5,000.00                         |
      | creditTotalFee        | 0.00                             |
      | creditTotalAdjustment | 0.00                             |
      | creditNettBalance     | 4,885.51                         |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who has Ledger and Shipper Account -  Ledger Status is Completed - Ledger has Origin Balance more than 0 - Overall Balance is 0 (uid:a9f626db-c000-4b1b-83a6-f2c283cbf6ef)
    Given API Operator create new normal shipper
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
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    And API Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": 2.54,"source": "Netsuite","shipper_id": "{KEY_SHIPPER_ID}","type": "DEBIT","payment_method": "Banking","payee_info":{"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"},"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}"} |
    Then Operator waits for 5 seconds
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies financial batch data as below
      | overallBalance        | S$ 0.00 (Debit)                  |
      | date                  | {gradle-current-date-dd/MM/yyyy} |
      | shipperName           | {KEY_CREATED_SHIPPER.name}       |
      | debitTotalCOD         | 0.00                             |
      | debitTotalFee         | 7.54                             |
      | debitTotalAdjustment  | 0.00                             |
      | debitNettBalance      | 2.54                             |
      | creditTotalCOD        | 5.00                             |
      | creditTotalFee        | 0.00                             |
      | creditTotalAdjustment | 0.00                             |
      | creditNettBalance     | 0.00                             |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who has Ledger -  Ledger Status is Ready - Ledger has Multiple 'Adjustment' Journals (uid:6ac3d80a-1bf0-4236-a87f-0404291655df)
    Given API Operator create new normal shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID}                                 |
      | source          | Netsuite                                         |
      | account_id      | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
      | overall_balance | 0.00                                             |
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}"
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And Operator verifies the number of entries in billing_qa_gl.ledgers table is 1
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Given DB Operator inserts payment entries to billing_qa_gl.journal table with below details
      | ledger_id                           | type   | subtype    | system_id     | amount |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Adjustment | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Adjustment | {KEY_COUNTRY} | 5.30   |
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies financial batch data as below
      | overallBalance        | S$ 41.97 (Credit)                |
      | date                  | {gradle-current-date-dd/MM/yyyy} |
      | shipperName           | {KEY_CREATED_SHIPPER.name}       |
      | debitTotalCOD         | 0.00                             |
      | debitTotalFee         | 8.03                             |
      | debitTotalAdjustment  | 17.16                            |
      | debitNettBalance      | 0.00                             |
      | creditTotalCOD        | 50.00                            |
      | creditTotalFee        | 0.00                             |
      | creditTotalAdjustment | 5.30                             |
      | creditNettBalance     | 41.97                            |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who has Ledger -  Ledger Status is Ready - Ledger has Multiple 'Reversion' Journals (uid:02e9a900-bb55-4e6f-be88-c6437cf755a4)
    Given API Operator create new normal shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID}                                 |
      | source          | Netsuite                                         |
      | account_id      | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
      | overall_balance | 0.00                                             |
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}"
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And Operator verifies the number of entries in billing_qa_gl.ledgers table is 1
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Given DB Operator inserts payment entries to billing_qa_gl.journal table with below details
      | ledger_id                           | type   | subtype   | system_id     | amount |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Reversion | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Reversion | {KEY_COUNTRY} | 5.30   |
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies financial batch data as below
      | overallBalance        | S$ 41.97 (Credit)                |
      | date                  | {gradle-current-date-dd/MM/yyyy} |
      | shipperName           | {KEY_CREATED_SHIPPER.name}       |
      | debitTotalCOD         | 0.00                             |
      | debitTotalFee         | 8.03                             |
      | debitTotalAdjustment  | 17.16                            |
      | debitNettBalance      | 0.00                             |
      | creditTotalCOD        | 50.00                            |
      | creditTotalFee        | 0.00                             |
      | creditTotalAdjustment | 5.30                             |
      | creditNettBalance     | 41.97                            |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who has Ledger -  Ledger Status is In Progress - Ledger has Multiple 'Adjustment' and 'Reversion' Journals (uid:fa343c88-a788-4767-ab9a-04e59dbfc6d9)
    Given API Operator create new normal shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID}                                 |
      | source          | Netsuite                                         |
      | account_id      | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} |
      | overall_balance | 0.00                                             |
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}"
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And Operator verifies the number of entries in billing_qa_gl.ledgers table is 1
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Given DB Operator inserts payment entries to billing_qa_gl.journal table with below details
      | ledger_id                           | type   | subtype    | system_id     | amount |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Adjustment | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Adjustment | {KEY_COUNTRY} | 5.30   |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Reversion  | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Reversion  | {KEY_COUNTRY} | 5.30   |
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies financial batch data as below
      | overallBalance        | S$ 41.97 (Credit)                |
      | date                  | {gradle-current-date-dd/MM/yyyy} |
      | shipperName           | {KEY_CREATED_SHIPPER.name}       |
      | debitTotalCOD         | 0.00                             |
      | debitTotalFee         | 8.03                             |
      | debitTotalAdjustment  | 34.32                            |
      | debitNettBalance      | 0.00                             |
      | creditTotalCOD        | 50.00                            |
      | creditTotalFee        | 0.00                             |
      | creditTotalAdjustment | 10.60                            |
      | creditNettBalance     | 41.97                            |

  @DeleteNewlyCreatedShipper
  Scenario: Search by Shipper who has Ledger -  Ledger Status is Completed - Ledger has Multiple 'Adjustment' and 'Reversion' Journals (uid:ba602b4b-8a1c-4e4b-9d8c-97c65df2ad97)
    Given API Operator create new normal shipper
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
    Then DB Operator verifies order id "{KEY_CREATED_ORDER_ID}" is added to billing_qa_gl.priced_orders
    And Operator verifies the number of entries in billing_qa_gl.ledgers table is 1
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 5 seconds
    Then DB Operator inserts payment entries to billing_qa_gl.journal table with below details
      | ledger_id                           | type   | subtype    | system_id     | amount |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Adjustment | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Adjustment | {KEY_COUNTRY} | 5.30   |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Debit  | Reversion  | {KEY_COUNTRY} | 17.16  |
      | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | Credit | Reversion  | {KEY_COUNTRY} | 5.30   |
    And API Operator run CreatePaymentMessages endpoint with below data
      | createPaymentRequest | { "amount": 2.54,"source": "Netsuite","shipper_id": "{KEY_SHIPPER_ID}","type": "DEBIT","payment_method": "Banking","payee_info":{"name": "QA-SO-AUTO-Payee","account_number": "QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}","bank": "QA-SO-Bank"},"payment_local_date": {gradle-current-date-yyyyMMdd},"transaction_no": "QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}"} |
    Then Operator waits for 5 seconds
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID}          |
      | date    | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies financial batch data as below
      | overallBalance        | S$ 0.00 (Debit)                  |
      | date                  | {gradle-current-date-dd/MM/yyyy} |
      | shipperName           | {KEY_CREATED_SHIPPER.name}       |
      | debitTotalCOD         | 0.00                             |
      | debitTotalFee         | 7.54                             |
      | debitTotalAdjustment  | 34.32                            |
      | debitNettBalance      | 2.54                             |
      | creditTotalCOD        | 5.00                             |
      | creditTotalFee        | 0.00                             |
      | creditTotalAdjustment | 10.60                            |
      | creditNettBalance     | 0.00                             |

  Scenario: Search Financial Batch - Empty Shipper (uid:60d7660c-a3d6-4a89-a4f1-84792c1f8564)
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | date | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies error message "Please select one shipper." is displayed on Financial Batch Page

  @DeleteNewlyCreatedShipper
  Scenario: Search Financial Batch - Empty Date (uid:0956ec7e-8ed3-434f-a06d-642d41d30fdb)
    Given API Operator create new normal shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    Given Operator go to menu Finance Tools -> Financial Batch
    When Operator generates financial batch data as below
      | shipper | {KEY_LEGACY_SHIPPER_ID} |
      | date    | clear                   |
    Then Operator verifies error message "Please select a date." is displayed on Financial Batch Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op