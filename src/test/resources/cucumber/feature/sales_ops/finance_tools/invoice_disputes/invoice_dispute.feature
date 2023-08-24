@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @InvoiceDisputes

Feature: Invoice Disputes

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Invoice Disputes - Search by Shipper ID (uid:8658b143-739d-43d6-ac93-cf00c83d2d1d)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","external_ref_id":"{gradle-next-0-day-yyyy-MM-dd}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"weight dispute memo for this TID","proposed_weight":3.5,"type":"weight"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | shipperId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator click load selection
    Then DB Billing - Operator get invoice disputes count for shippers and date range from billing_qa_gl.invoice_dispute table using below data:
      | fromDate   | {gradle-next-0-day-yyyy-MM-dd} 00:00:00 |
      | toDate     | {gradle-next-0-day-yyyy-MM-dd} 23:59:59 |
      | shipperIds | {KEY_SHIPPER_SHIPPER.legacyId}          |
    And Operator verifies the result count
    And DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator verify the invoice dispute details

  Scenario: Search Invoice Disputes - Search by Multiple Shipper ID (uid:d77ef4a7-2cde-4baa-a447-0f1f1eee8464)
    #First Shipper
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_1_{gradle-next-0-day-yyyyMMddHHmmsss}","external_ref_id":"{gradle-next-0-day-yyyy-MM-dd}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"weight dispute memo for this TID","proposed_weight":3.5,"type":"weight"}]}]} |
    #Second Shipper
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[2].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[2].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[2].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_2_{gradle-next-0-day-yyyyMMddHHmmsss}","external_ref_id":"{gradle-next-0-day-yyyy-MM-dd}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"weight dispute memo for this TID","proposed_weight":3.5,"type":"weight"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | shipperId | {KEY_INVOICE_DISPUTES_CREATE_RESPONSE[1].legacyShipperId} |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd}                            |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd}                            |
    And Operator add filters according to data below:
      | shipperId | {KEY_INVOICE_DISPUTES_CREATE_RESPONSE[2].legacyShipperId} |
    And Operator click load selection
    Then DB Billing - Operator get invoice disputes count for shippers and date range from billing_qa_gl.invoice_dispute table using below data:
      | fromDate   | {gradle-next-0-day-yyyy-MM-dd} 00:00:00                                                                             |
      | toDate     | {gradle-next-0-day-yyyy-MM-dd} 23:59:59                                                                             |
      | shipperIds | {KEY_INVOICE_DISPUTES_CREATE_RESPONSE[1].legacyShipperId},{KEY_INVOICE_DISPUTES_CREATE_RESPONSE[2].legacyShipperId} |
    And Operator verifies the result count
    Then DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator verify the invoice dispute details
    Then DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[2]}"
    And Operator verify the invoice dispute details

  Scenario Outline: Search Invoice Disputes - Search by Invoice ID (uid:965cb0d8-3c1b-47ab-a719-66468d005c9b)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","external_ref_id":"{gradle-next-0-day-yyyy-MM-dd}","invoice_id":"<invoiceId>","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"weight dispute memo for this TID","proposed_weight":3.5,"type":"weight"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | invoiceId | <invoiceId>                    |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator click load selection
    Then DB Billing - Operator get invoice disputes count for invoice id and date range from billing_qa_gl.invoice_dispute table using below data:
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} 00:00:00 |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} 23:59:59 |
      | invoiceId | <invoiceId>                             |
    And Operator verifies the result count
    And DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator verify the invoice dispute details
    Examples:
      | invoiceId                                      |
      | invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss} |

  Scenario: Search Invoice Disputes - Search by Status = Open (uid:afd94225-35ff-44b6-8212-a70316b8bdc1)
    When Operator go to menu Finance Tools -> Invoice Disputes
    Then Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | caseStatus | Open                                |
      | fromDate   | {gradle-previous-30-day-yyyy-MM-dd} |
      | toDate     | {gradle-next-0-day-yyyy-MM-dd}      |
    And Operator click load selection
    Then DB Billing - Operator get invoice disputes count for case statuses and date range from billing_qa_gl.invoice_dispute table using below data:
      | fromDate     | {gradle-previous-30-day-yyyy-MM-dd} 00:00:00 |
      | toDate       | {gradle-next-0-day-yyyy-MM-dd} 23:59:59      |
      | caseStatuses | OPEN                                         |
    And Operator verifies the result count

  Scenario: Search Invoice Disputes - Search by Status = Closed (uid:88a973e8-78b1-4f9c-a52f-87b3cd72dc9f)
    When Operator go to menu Finance Tools -> Invoice Disputes
    Then Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | caseStatus | Closed                              |
      | fromDate   | {gradle-previous-30-day-yyyy-MM-dd} |
      | toDate     | {gradle-next-0-day-yyyy-MM-dd}      |
    And Operator click load selection
    Then DB Billing - Operator get invoice disputes count for case statuses and date range from billing_qa_gl.invoice_dispute table using below data:
      | fromDate     | {gradle-previous-30-day-yyyy-MM-dd} 00:00:00 |
      | toDate       | {gradle-next-0-day-yyyy-MM-dd} 23:59:59      |
      | caseStatuses | CLOSED                                       |
    And Operator verifies the result count

  Scenario: Search Invoice Disputes - Search by Multiple Status (uid:41df5302-1a63-418d-9701-0fc00b6e1501)
    When Operator go to menu Finance Tools -> Invoice Disputes
    Then Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | caseStatus | Open                                |
      | fromDate   | {gradle-previous-30-day-yyyy-MM-dd} |
      | toDate     | {gradle-next-0-day-yyyy-MM-dd}      |
    Then Operator add filters according to data below:
      | caseStatus | Closed |
    And Operator click load selection
    Then DB Billing - Operator get invoice disputes count for case statuses and date range from billing_qa_gl.invoice_dispute table using below data:
      | fromDate     | {gradle-previous-30-day-yyyy-MM-dd} 00:00:00 |
      | toDate       | {gradle-next-0-day-yyyy-MM-dd} 23:59:59      |
      | caseStatuses | OPEN,CLOSED                                  |
    And Operator verifies the result count

  Scenario: Search Invoice Disputes - Search by Date (uid:46ed8af7-ebf8-4eac-9c17-ce33ae03cdee)
    When Operator go to menu Finance Tools -> Invoice Disputes
    Then Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | fromDate | {gradle-previous-30-day-yyyy-MM-dd} |
      | toDate   | {gradle-next-0-day-yyyy-MM-dd}      |
    And Operator click load selection
    Then DB Billing - Operator get invoice disputes count for date range from billing_qa_gl.invoice_dispute table using below data:
      | fromDate | {gradle-previous-30-day-yyyy-MM-dd} 00:00:00 |
      | toDate   | {gradle-next-0-day-yyyy-MM-dd} 23:59:59      |
    And Operator verifies the result count

