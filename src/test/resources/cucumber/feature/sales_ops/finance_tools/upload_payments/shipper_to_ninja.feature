@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @UploadPayments

Feature: Upload CSV Payment From Shipper To Ninja Van (Debit)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipper
  Scenario Outline: 1 Account ID linked to 1 Shipper - Payment via CSV Upload from Shipper with exact amount of "Ready" ledger balance - CSV Has Shipper Legacy ID And Payer Info - Check Payment Tags
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
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" with cod
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" with cod
    Then Operator waits for 5 seconds
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" is added to billing_qa_gl.priced_orders
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" is added to billing_qa_gl.priced_orders
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value |
      | origin_balance | <amount>       |
      | total_remitted | 0.00           |
      | balance        | <amount>       |
      | status         | Ready          |
      | status_logs    | Open,Ready     |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source> |
      | overall_balance | <amount> |
      | logs            | <amount> |
    And Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id              | remittance_date                  | amount   | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | {KEY_LEGACY_SHIPPER_ID} | {gradle-current-date-yyyy-MM-dd} | <amount> | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
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
      | event             | Payment                                                                                    |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value       |
      | origin_balance | <amount>             |
      | total_remitted | <amount>             |
      | balance        | 0.00                 |
      | status         | Completed            |
      | status_logs    | Open,Ready,Completed |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>     |
      | overall_balance | 0.0          |
      | logs            | <amount>,0.0 |
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
      | source   | account_id                                       | amount | type  | payment_method | payee_name       | payee_account_number                                       | payee_bank | transaction_no
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 7.39   | DEBIT | Banking        | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}

  @DeleteNewlyCreatedShipper
  Scenario Outline: 1 Account ID linked to 1 Shipper - Payment via CSV Upload from Shipper with smaller amount of "Ready" ledger balance - CSV Has Netsuite ID And Payee Info (uid:85cdeeea-65fb-4558-a999-a74e3eedf638)
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
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" with cod
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" with cod
    Then Operator waits for 5 seconds
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" is added to billing_qa_gl.priced_orders
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" is added to billing_qa_gl.priced_orders
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value |
      | origin_balance | <amount>       |
      | total_remitted | 0.00           |
      | balance        | <amount>       |
      | status         | Ready          |
      | status_logs    | Open,Ready     |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source> |
      | overall_balance | <amount> |
      | logs            | <amount> |
    And Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | netsuite_id  | remittance_date                  | amount | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | <account_id> | {gradle-current-date-yyyy-MM-dd} | 5.0    | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 5 seconds
    Then DB Operator gets payment details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_SHIPPER_ID}                                                                           |
      | parent_shipper_id | null                                                                                       |
      | amount            | 5.0                                                                                        |
      | type              | <type>                                                                                     |
      | subtype           | Full                                                                                       |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
      | event             | Payment                                                                                    |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value         |
      | origin_balance | <amount>               |
      | total_remitted | 5.00                   |
      | balance        | 2.38                   |
      | status         | In Progress            |
      | status_logs    | Open,Ready,In Progress |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>      |
      | overall_balance | 2.38          |
      | logs            | <amount>,2.38 |
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" is not in billing_qa_gl.invoiced_orders table
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" is not in billing_qa_gl.invoiced_orders table
    Then Operator gets price order details from the billing_qa_gl.priced_orders table
    Then Operator verifies below details in billing_qa_gl.priced_orders table
      | column       | expected_value |
      | payment_tags | null           |
    Then DB Billing - Operator verifies there is no entry in the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Examples:
      | source   | account_id                                       | amount | type  | payment_method | payee_name       | payee_account_number                                       | payee_bank | transaction_no
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 7.38   | DEBIT | Banking        | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd}


  @DeleteNewlyCreatedShipper
  Scenario Outline: 1 Account ID linked to 1 Shipper - Payment via CSV Upload from Shipper Remit with bigger amount of "Ready" ledger balance - CSV Has Netsuite ID, Payer And Payee Info - Check Payment Tags (uid:04036c7b-d541-4223-92aa-d222da2d5932)
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
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" with cod
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" with cod
    Then Operator waits for 5 seconds
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" is added to billing_qa_gl.priced_orders
    Then DB Operator verifies order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" is added to billing_qa_gl.priced_orders
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value |
      | origin_balance | <amount>       |
      | total_remitted | 0.00           |
      | balance        | <amount>       |
      | status         | Ready          |
      | status_logs    | Open,Ready     |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source> |
      | overall_balance | <amount> |
      | logs            | <amount> |
    And Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | netsuite_id  | remittance_date                  | amount | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | <account_id> | {gradle-current-date-yyyy-MM-dd} | 10.0   | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 5 seconds
    Then DB Operator gets payment details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_SHIPPER_ID}                                                                           |
      | parent_shipper_id | null                                                                                       |
      | amount            | 10.0                                                                                       |
      | type              | <type>                                                                                     |
      | subtype           | Full                                                                                       |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
      | event             | Payment                                                                                    |
    Then DB Operator gets ledger details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value       |
      | origin_balance | <amount>             |
      | total_remitted | 7.39                 |
      | balance        | 0.00                 |
      | status         | Completed            |
      | status_logs    | Open,Ready,Completed |
    And DB Operator gets shipper account details for shipper "{KEY_SHIPPER_ID}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>       |
      | overall_balance | -2.62          |
      | logs            | <amount>,-2.62 |
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
      | source   | account_id                                       | amount | type  | payment_method | transaction_no                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-1-{gradle-current-date-yyyyMMddHH} | 7.39   | DEBIT | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |

  @DeleteNewlyCreatedShipper
  Scenario Outline: 1 Account ID linked to 3 Shippers - "Ready" ledger is exists for each shipper - Payment via CSV Upload from Shipper is enough to offset balance of all shippers (uid:8298abe9-6199-42cf-9d1d-86c7203b2faf)
    #Shipper 1
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
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
     #Shipper 2
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
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
    #Shipper 3
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
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
    Then Operator waits for 1 seconds
    # Trigger scheduler to create 'Ready' ledger
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    # Create Payment
    And Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | netsuite_id  | remittance_date                  | amount   | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | <account_id> | {gradle-current-date-yyyy-MM-dd} | <amount> | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 7 seconds
    # Verify shipper 1
    Then DB Operator gets payment details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_LIST_OF_CREATED_SHIPPERS[1].id}                                                       |
      | parent_shipper_id | null                                                                                       |
      | amount            | 4.23                                                                                       |
      | type              | <type>                                                                                     |
      | subtype           | Split                                                                                      |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
    Then DB Operator gets ledger details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value       |
      | origin_balance | 4.23                 |
      | total_remitted | 4.23                 |
      | balance        | 0.00                 |
      | status         | Completed            |
      | status_logs    | Open,Ready,Completed |
    And DB Operator gets shipper account details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source> |
      | overall_balance | 0.0      |
      | logs            | 4.23,0.0 |
    # Verify shipper 2
    Then DB Operator gets payment details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[2].id}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_LIST_OF_CREATED_SHIPPERS[2].id}                                                       |
      | parent_shipper_id | null                                                                                       |
      | amount            | 4.23                                                                                       |
      | type              | <type>                                                                                     |
      | subtype           | Split                                                                                      |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
    Then DB Operator gets ledger details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[2].id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value       |
      | origin_balance | 4.23                 |
      | total_remitted | 4.23                 |
      | balance        | 0.00                 |
      | status         | Completed            |
      | status_logs    | Open,Ready,Completed |
    And DB Operator gets shipper account details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[2].id}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source> |
      | overall_balance | 0.0      |
      | logs            | 4.23,0.0 |
   # Verify shipper 3
    Then DB Operator gets payment details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[3].id}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_LIST_OF_CREATED_SHIPPERS[3].id}                                                       |
      | parent_shipper_id | null                                                                                       |
      | amount            | 4.23                                                                                       |
      | type              | <type>                                                                                     |
      | subtype           | Split                                                                                      |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
    Then DB Operator gets ledger details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[3].id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value       |
      | origin_balance | 4.23                 |
      | total_remitted | 4.23                 |
      | balance        | 0.00                 |
      | status         | Completed            |
      | status_logs    | Open,Ready,Completed |
    And DB Operator gets shipper account details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[3].id}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source> |
      | overall_balance | 0.0      |
      | logs            | 4.23,0.0 |
    Examples:
      | source   | account_id                                       | amount | type  | payment_method | transaction_no                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | 12.69  | DEBIT | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |


  @DeleteNewlyCreatedShipper
  Scenario Outline: Operator Upload CSV Payment With Both Debit And Credit Type
    #1 Account ID linked to 2 Shippers
    #Shipper 1
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
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
     #Shipper 2
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
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order id "{KEY_CREATED_ORDER_ID}" with cod
    Then Operator waits for 2 seconds
    # Trigger scheduler to create 'Ready' ledger
    And API Operator trigger reconcile scheduler endpoint
    Then Operator waits for 10 seconds
    #Shipper 3
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_ID}"
      | {"shipper_id": "{KEY_SHIPPER_ID}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_ID}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    And DB operator inserts below data to billing_qa_gl.shipper_accounts table
      | shipper_id      | {KEY_SHIPPER_ID} |
      | source          | <source>         |
      | account_id      | <account_id_2>   |
      | overall_balance | 0.00             |
    # Create Payment
    And Operator go to menu Finance Tools -> Upload Payments
    When Operator upload CSV on Upload Payments page using data below:
      | shipper_id                                 | remittance_date                  | amount     | transaction_number | transaction_type | payment_method   | payee_name   | payee_account_number   | payee_bank   |
      | {KEY_LIST_OF_CREATED_SHIPPERS[1].legacyId} | {gradle-current-date-yyyy-MM-dd} | <amount>   | <transaction_no>   | <type>           | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
      | {KEY_LIST_OF_CREATED_SHIPPERS[3].legacyId} | {gradle-current-date-yyyy-MM-dd} | <amount_2> | <transaction_no_2> | <type_2>         | <payment_method> | <payee_name> | <payee_account_number> | <payee_bank> |
    Then Operator verifies csv file is successfully uploaded on the Upload Payments page
    Then Operator waits for 6 seconds
    # Verify shipper 1
    Then DB Operator gets payment details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_LIST_OF_CREATED_SHIPPERS[1].id}                                                       |
      | parent_shipper_id | null                                                                                       |
      | amount            | <amount>                                                                                   |
      | type              | <type>                                                                                     |
      | subtype           | Full                                                                                       |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
      | event             | Payment                                                                                    |
    Then DB Operator gets ledger details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}" from billing_qa_gl.ledgers table
    Then Operator verifies below details in billing_qa_gl.ledgers table
      | column         | expected_value       |
      | origin_balance | <amount>             |
      | total_remitted | <amount>             |
      | balance        | 0.00                 |
      | status         | Completed            |
      | status_logs    | Open,Ready,Completed |
    And DB Operator gets shipper account details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>     |
      | overall_balance | 0.0          |
      | logs            | <amount>,0.0 |
   # Verify shipper 3
    Then DB Operator gets payment details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[3].id}" from billing_qa_gl.transactions table
    Then Operator verifies below details in billing_qa_gl.transactions table
      | column            | expected_value                                                                             |
      | system_id         | {KEY_COUNTRY}                                                                              |
      | shipper_id        | {KEY_LIST_OF_CREATED_SHIPPERS[3].id}                                                       |
      | parent_shipper_id | null                                                                                       |
      | amount            | <amount_2>                                                                                 |
      | type              | <type_2>                                                                                   |
      | subtype           | Full                                                                                       |
      | payment_method    | <payment_method>                                                                           |
      | payee_info        | {"name": "<payee_name>","account_number": "<payee_account_number>","bank": "<payee_bank>"} |
      | created_at        | notNull                                                                                    |
      | updated_at        | notNull                                                                                    |
      | deleted_at        | null                                                                                       |
      | event             | Remittance                                                                                 |
    And DB Operator gets shipper account details for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[3].id}" from billing_qa_gl.shipper_accounts table
    And Operator verifies below details in billing_qa_gl.shipper_accounts table
      | source          | <source>   |
      | overall_balance | <amount_2> |
      | logs            | <amount_2> |
    Examples:
      | source   | account_id                                       | account_id_2                                       | amount | amount_2 | type  | type_2 | payment_method | transaction_no                                             | transaction_no_2                                             | payee_name       | payee_account_number                                       | payee_bank |
      | Netsuite | QA-SO-AUTO-{gradle-current-date-yyyyMMddHHmmsss} | QA-SO-AUTO-2-{gradle-current-date-yyyyMMddHHmmsss} | 4.23   | 12.45    | DEBIT | CREDIT | Banking        | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-2-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-AUTO-Payee | QA-SO-AUTO-{KEY_SHIPPER_ID}-{gradle-current-date-yyyyMMdd} | QA-SO-Bank |
