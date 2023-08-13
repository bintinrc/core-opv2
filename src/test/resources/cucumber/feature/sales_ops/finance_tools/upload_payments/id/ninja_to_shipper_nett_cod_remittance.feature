@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsID @UploadPaymentsID

Feature: Upload CSV Payment From Ninja Van To Shipper (Credit) - Nett COD Remittance

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

    @DeleteNewlyCreatedShipper
  Scenario Outline: 1 Account ID linked 1 Shipper - Payment via CSV Upload for Nett COD Remittance with exact amount of "Ready" ledger balance - CSV Has Shipper Legacy ID And Payee Info - ID
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID} |
      | source          | <source>         |
      | account_id      | <account_id>     |
      | overall_balance | 0.00             |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Finance Tools -> Upload Payments
    Then Operator waits for 10 seconds
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id              | batch_id                            | transaction_event | remittance_date                  | amount   | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | <event>           | {gradle-current-date-yyyy-MM-dd} | <amount> | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 10 seconds
    Then DB Operator gets payment details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_SHIPPER_ID}                                                                           |
      | parent_shipper_id | null                                                                                       |
      | amount            | <amount>                                                                                 |
      | type              | Credit                                                                                    |
      | subtype           | Full                                                                                       |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
      | event             | <event>                                                                                    |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value         |
      | origin_balance | -80.79                 |
      | total_remitted | -<amount>              |
      | balance        | 0.00                   |
      | status         | Completed              |
      | status_logs    | Open,Ready,Completed   |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>    |
      | overall_balance | 0.00        |
      | logs            | -80.79,0.00 |
    Examples:
      | source   | account_id                                           | amount  | type | event                 | payment_method | transaction_no                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-TC1-{gradle-current-date-yyyyMMddHHmmsss} | 80.79   | Out  | Nett COD Remittance   | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |

  @DeleteNewlyCreatedShipper
  Scenario Outline: 1 Account ID linked 1 Shipper - Payment via CSV Upload for Nett COD Remittance with Transaction Amount =  Nett of COD Amount - CSV Has Shipper Legacy ID And Payee Info - ID
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID} |
      | source          | <source>         |
      | account_id      | <account_id>     |
      | overall_balance | 0.00             |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Finance Tools -> Upload Payments
    Then Operator waits for 10 seconds
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id              | batch_id                            | transaction_event | remittance_date                  | amount   | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | <event>           | {gradle-current-date-yyyy-MM-dd} | <amount> | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 10 seconds
    Then DB Operator gets payment details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_SHIPPER_ID}                                                                           |
      | parent_shipper_id | null                                                                                       |
      | amount            | <amount>                                                                                   |
      | type              | Credit                                                                                     |
      | subtype           | Full                                                                                       |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
      | event             | <event>                                                                                    |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value         |
      | origin_balance | -80.79                 |
      | total_remitted | -<amount>              |
      | balance        | 18.20                  |
      | status         | In Progress            |
      | status_logs    | Open,Ready,In Progress |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>     |
      | overall_balance | 18.20        |
      | logs            | -80.79,18.20 |
    Examples:
      | source   | account_id                                           | amount | type | event               | payment_method | transaction_no                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-TC1-{gradle-current-date-yyyyMMddHHmmsss} | 98.99  | Out  | Nett COD Remittance | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |

  @DeleteNewlyCreatedShipper
  Scenario Outline: 1 Account ID linked 1 Shipper - Payment via CSV Upload for Nett COD Remittance with smaller amount of Nett of COD Amount and "Ready" ledger balance - CSV Has Shipper Legacy ID And Payee Info - ID
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID} |
      | source          | <source>         |
      | account_id      | <account_id>     |
      | overall_balance | 0.00             |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Finance Tools -> Upload Payments
    Then Operator waits for 10 seconds
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id              | batch_id                            | transaction_event | remittance_date                  | amount   | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | <event>           | {gradle-current-date-yyyy-MM-dd} | <amount> | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 10 seconds
    Then DB Operator gets payment details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_SHIPPER_ID}                                                                           |
      | parent_shipper_id | null                                                                                       |
      | amount            | 50.5                                                                                       |
      | type              | Credit                                                                                     |
      | subtype           | Full                                                                                       |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
      | event             | <event>                                                                                    |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value         |
      | origin_balance | -80.79                 |
      | total_remitted | -<amount>              |
      | balance        | -30.29                 |
      | status         | In Progress            |
      | status_logs    | Open,Ready,In Progress |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>      |
      | overall_balance | -30.29        |
      | logs            | -80.79,-30.29 |
    Examples:
      | source   | account_id                                           | amount | type | event               | payment_method | transaction_no                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-TC1-{gradle-current-date-yyyyMMddHHmmsss} | 50.50  | Out  | Nett COD Remittance | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |

  @DeleteNewlyCreatedShipper
  Scenario Outline: 1 Account ID linked 1 Shipper - Payment via CSV Upload for Nett COD Remittance with bigger amount of Nett of COD Amount and "Ready" ledger balance - CSV Has Shipper Legacy ID And Payee Info - ID
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID} |
      | source          | <source>         |
      | account_id      | <account_id>     |
      | overall_balance | 0.00             |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Finance Tools -> Upload Payments
    Then Operator waits for 10 seconds
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id              | batch_id                            | transaction_event | remittance_date                  | amount   | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_FINANCIAL_BATCH_LEDGERS[1].id} | <event>           | {gradle-current-date-yyyy-MM-dd} | <amount> | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 10 seconds
    Then DB Operator gets payment details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_SHIPPER_ID}                                                                           |
      | parent_shipper_id | null                                                                                       |
      | amount            | <amount>.0                                                                                 |
      | type              | Credit                                                                                     |
      | subtype           | Full                                                                                       |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
      | event             | <event>                                                                                    |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value         |
      | origin_balance | -80.79                 |
      | total_remitted | -<amount>.00           |
      | balance        | 19.21                  |
      | status         | In Progress            |
      | status_logs    | Open,Ready,In Progress |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>     |
      | overall_balance | 19.21        |
      | logs            | -80.79,19.21 |
    Examples:
      | source   | account_id                                           | amount | type | event               | payment_method | transaction_no                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-TC1-{gradle-current-date-yyyyMMddHHmmsss} | 100    | Out  | Nett COD Remittance | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |