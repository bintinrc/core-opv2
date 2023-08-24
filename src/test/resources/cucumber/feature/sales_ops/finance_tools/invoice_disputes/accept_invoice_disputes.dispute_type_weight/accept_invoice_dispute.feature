@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @InvoiceDisputes @AcceptInvoiceDisputes

Feature: Accept Invoice Disputes

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Manually Approve TID with Dispute Type "Billing Weight" and TID has all Fees - Calculate Revised Delivery Fee - Input Maximum Decimal Digit - Not Update Revised Fees Breakdown - Without Input Internal Commentary - Save by "Save and Next" (uid:f500eecb-1a46-4cfe-bf4c-9f548c905936)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-invoice-disputes},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "M", "weight": 5.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":{"weight": 6.0}} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                       |
      | hubId                | {hub-id}                                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ARRIVED_AT_SORTING_HUB"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":{"weight": 6.0}} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}                       |
      | hubId                | {hub-id}                                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "ARRIVED_AT_SORTING_HUB"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[2].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","external_ref_id":"{gradle-next-0-day-yyyy-MM-dd}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fees/promo dispute memo for this TID","type":"weight","proposed_weight":"7.0"}]},{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fees/promo dispute memo for this TID","type":"weight","proposed_weight":"7.0"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | shipperId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator click load selection
    And Operator clicks action button
    And DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 2 |
      | pendingTIDs         | 2 |
      | acceptedTIDs        | - |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 2                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Pending                               |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                    |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.808                 |
      | originalBillAmount     | 10.908                |
      | revisedDeliveryFee     | {empty}               |
      | revisedRTSFee          | {empty}               |
      | revisedCODFee          | {empty}               |
      | revisedInsuranceFee    | {empty}               |
      | revisedTax             | {empty}               |
      | revisedTotalBillAmount | {empty}               |
      | deltaAmount            | {empty}               |
      | remarks                | Fee has been revised. |
      | internalCommentary     | {empty}               |
    And Operator enters Manual Resolution data using data below:
      | revisedWeightInput | 8.123456789012 |
    And Operator clicks calculate button
    And Operator clicks save and next button
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    And Operator close the invoice dispute manual resolution modal
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 2 |
      | pendingTIDs         | 1 |
      | acceptedTIDs        | 1 |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 2                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 14.247                                |
      | financeRevisedCodFee                | 0.1                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | 4.5868                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                    |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.808                 |
      | originalBillAmount     | 10.908                |
      | revisedDeliveryFee     | 14.247                |
      | revisedRTSFee          | 0                     |
      | revisedCODFee          | 0.1                   |
      | revisedInsuranceFee    | 0                     |
      | revisedTax             | 1.1478                |
      | revisedTotalBillAmount | 15.4948               |
      | deltaAmount            | 4.5868                |
      | remarks                | Fee has been revised. |
      | internalCommentary     | {empty}               |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Manually Approve TID with Dispute Type "Billing Weight" - Remarks is auto-populated - Calculate Revised Delivery Fee - Input INT - Update Some of Revised Fees Breakdown - Input Internal Commentary - Save by "Save and Exit" (uid:dd0560f7-3167-41a2-9bed-c39f536442ea)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-invoice-disputes},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "M", "weight": 5.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":{"weight": 6.0}} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                       |
      | hubId                | {hub-id}                                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ARRIVED_AT_SORTING_HUB"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","external_ref_id":"{gradle-next-0-day-yyyy-MM-dd}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"weight","proposed_weight":"7.0"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | shipperId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator click load selection
    And Operator clicks action button
    And DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | 1 |
      | acceptedTIDs        | - |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Pending                               |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                    |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.808                 |
      | originalBillAmount     | 10.908                |
      | revisedDeliveryFee     | {empty}               |
      | revisedRTSFee          | {empty}               |
      | revisedCODFee          | {empty}               |
      | revisedInsuranceFee    | {empty}               |
      | revisedTax             | {empty}               |
      | revisedTotalBillAmount | {empty}               |
      | deltaAmount            | {empty}               |
      | remarks                | Fee has been revised. |
      | internalCommentary     | {empty}               |
    And Operator clicks calculate button
    And Operator enters Manual Resolution data using data below:
      | revisedDeliveryFee | 12                              |
      | revisedTax         | 2                               |
      | internalCommentary | This is a Test Accepted Dispute |
    And Operator clicks save and exit button
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | - |
      | acceptedTIDs        | 1 |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 12                                    |
      | financeRevisedCodFee                | 0.1                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | 3.192                                 |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                              |
      | originalRTSFee         | 0                               |
      | originalCODFee         | 0.1                             |
      | originalInsuranceFee   | 0                               |
      | originalTax            | 0.808                           |
      | originalBillAmount     | 10.908                          |
      | revisedDeliveryFee     | 12                              |
      | revisedRTSFee          | 0                               |
      | revisedCODFee          | 0.1                             |
      | revisedInsuranceFee    | 0                               |
      | revisedTax             | 2                               |
      | revisedTotalBillAmount | 14.1                            |
      | deltaAmount            | 3.192                           |
      | remarks                | Fee has been revised.           |
      | internalCommentary     | This is a Test Accepted Dispute |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Manually Approve TID with Dispute Type "Billing Weight" that already "Rejected" before - Calculate Revised Delivery Fee - Input INT - Update Some of Original Fees Breakdown and Revised Fees Breakdown - Input Internal Commentary - Save by "Save and Exit" (uid:03c0adf7-a87f-426e-9cab-25c9b040b6c1)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-invoice-disputes},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "M", "weight": 5.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":{"weight": 6.0}} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                       |
      | hubId                | {hub-id}                                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ARRIVED_AT_SORTING_HUB"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","external_ref_id":"{gradle-next-0-day-yyyy-MM-dd}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"weight","proposed_weight":"7.0"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | shipperId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator click load selection
    And Operator clicks action button
    And DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | 1 |
      | acceptedTIDs        | - |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Pending                               |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    Then Operator clicks reject button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | remarks            | Correct weight was charged. |
      | internalCommentary | {empty}                     |
    And Operator enters Manual Resolution data using data below:
      | internalCommentary | This is a Test Rejected Dispute |
    And Operator clicks save and exit button
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | - |
      | acceptedTIDs        | - |
      | rejectedTIDs        | 1 |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount | 1                                     |
      | trackingId            | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType           | Billing Weight                        |
      | status                | Rejected                              |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    Then Operator clicks Manual adjustment button
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                              |
      | originalRTSFee         | 0                               |
      | originalCODFee         | 0.1                             |
      | originalInsuranceFee   | 0                               |
      | originalTax            | 0.808                           |
      | originalBillAmount     | 10.908                          |
      | revisedDeliveryFee     | {empty}                         |
      | revisedRTSFee          | {empty}                         |
      | revisedCODFee          | {empty}                         |
      | revisedInsuranceFee    | {empty}                         |
      | revisedTax             | {empty}                         |
      | revisedTotalBillAmount | {empty}                         |
      | deltaAmount            | {empty}                         |
      | remarks                | Fee has been revised.           |
      | internalCommentary     | This is a Test Rejected Dispute |
    And Operator clicks calculate button
    And Operator enters Manual Resolution data using data below:
      | originalBillAmount | 10                              |
      | revisedDeliveryFee | 12                              |
      | internalCommentary | This is a Test Accepted Dispute |
    And Operator clicks save and confirm button
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | - |
      | acceptedTIDs        | 1 |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 12                                    |
      | financeRevisedCodFee                | 0.1                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | 2.160                                 |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                              |
      | originalRTSFee         | 0                               |
      | originalCODFee         | 0.1                             |
      | originalInsuranceFee   | 0                               |
      | originalTax            | 0.808                           |
      | originalBillAmount     | 10.908                          |
      | revisedDeliveryFee     | 12                              |
      | revisedRTSFee          | 0                               |
      | revisedCODFee          | 0.1                             |
      | revisedInsuranceFee    | 0                               |
      | revisedTax             | 0.968                           |
      | revisedTotalBillAmount | 13.068                          |
      | deltaAmount            | 2.160                           |
      | remarks                | Fee has been revised.           |
      | internalCommentary     | This is a Test Accepted Dispute |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Update Finance Revised Weight for TID with Dispute Type "Billing Weight" that already "Accepted" before (uid:3720d9ac-7790-4cb1-addf-16cc7bccaa2e)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-invoice-disputes},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "M", "weight": 5.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":{"weight": 6.0}} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                       |
      | hubId                | {hub-id}                                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ARRIVED_AT_SORTING_HUB"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","external_ref_id":"{gradle-next-0-day-yyyy-MM-dd}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"weight","proposed_weight":"7.0"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | shipperId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator click load selection
    And Operator clicks action button
    And DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | 1 |
      | acceptedTIDs        | - |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Pending                               |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                    |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.808                 |
      | originalBillAmount     | 10.908                |
      | revisedDeliveryFee     | {empty}               |
      | revisedRTSFee          | {empty}               |
      | revisedCODFee          | {empty}               |
      | revisedInsuranceFee    | {empty}               |
      | revisedTax             | {empty}               |
      | revisedTotalBillAmount | {empty}               |
      | deltaAmount            | {empty}               |
      | remarks                | Fee has been revised. |
      | internalCommentary     | {empty}               |
    And Operator clicks calculate button
    And Operator clicks save and exit button
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | - |
      | acceptedTIDs        | 1 |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 12                                    |
      | financeRevisedCodFee                | 0.1                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | 2.160                                 |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    Then Operator clicks Manual adjustment button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                    |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.808                 |
      | originalBillAmount     | 10.908                |
      | revisedDeliveryFee     | 12                    |
      | revisedRTSFee          | 0                     |
      | revisedCODFee          | 0.1                   |
      | revisedInsuranceFee    | 0                     |
      | revisedTax             | 0.968                 |
      | revisedTotalBillAmount | 13.068                |
      | deltaAmount            | 2.160                 |
      | remarks                | Fee has been revised. |
      | internalCommentary     | {empty}               |
    And Operator enters Manual Resolution data using data below:
      | revisedWeightInput | 8                               |
      | internalCommentary | This is a Test Accepted Dispute |
    And Operator clicks calculate button
    And Operator clicks save and confirm button
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | - |
      | acceptedTIDs        | 1 |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 14                                    |
      | financeRevisedCodFee                | 0.1                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | 4.320                                 |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                              |
      | originalRTSFee         | 0                               |
      | originalCODFee         | 0.1                             |
      | originalInsuranceFee   | 0                               |
      | originalTax            | 0.808                           |
      | originalBillAmount     | 10.908                          |
      | revisedDeliveryFee     | 14                              |
      | revisedRTSFee          | 0                               |
      | revisedCODFee          | 0.1                             |
      | revisedInsuranceFee    | 0                               |
      | revisedTax             | 1.128                           |
      | revisedTotalBillAmount | 15.228                          |
      | deltaAmount            | 4.320                           |
      | remarks                | Fee has been revised.           |
      | internalCommentary     | This is a Test Accepted Dispute |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Manually Approve TID with Dispute Type "Billing Weight" and TID has all Fees - Not Input Revised Weight - Fill All Revised Fees Breakdown - Without Input Internal Commentary - Save by "Save and Exit" (uid:98523bda-d697-40a3-89ca-0b4051553346)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-invoice-disputes},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "M", "weight": 5.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":{"weight": 6.0}} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                       |
      | hubId                | {hub-id}                                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ARRIVED_AT_SORTING_HUB"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","external_ref_id":"{gradle-next-0-day-yyyy-MM-dd}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"weight","proposed_weight":"7.0"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | shipperId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator click load selection
    And Operator clicks action button
    And DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | 1 |
      | acceptedTIDs        | - |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Pending                               |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                    |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.808                 |
      | originalBillAmount     | 10.908                |
      | revisedDeliveryFee     | {empty}               |
      | revisedRTSFee          | {empty}               |
      | revisedCODFee          | {empty}               |
      | revisedInsuranceFee    | {empty}               |
      | revisedTax             | {empty}               |
      | revisedTotalBillAmount | {empty}               |
      | deltaAmount            | {empty}               |
      | remarks                | Fee has been revised. |
      | internalCommentary     | {empty}               |
    And Operator enters Manual Resolution data using data below:
      | revisedWeightInput  | 8  |
      | revisedDeliveryFee  | 12 |
      | revisedRTSFee       | 5  |
      | revisedCODFee       | 5  |
      | revisedInsuranceFee | 3  |
      | revisedTax          | 2  |
    And Operator clicks save and exit button
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | - |
      | acceptedTIDs        | 1 |
      | rejectedTIDs        | - |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 12                                    |
      | financeRevisedCodFee                | 5                                     |
      | deltaOfOriginalBillAmtAndRevisedAmt | 16.092                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 10.1                                  |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                    |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.808                 |
      | originalBillAmount     | 10.908                |
      | revisedDeliveryFee     | 12                    |
      | revisedRTSFee          | 5                     |
      | revisedCODFee          | 5                     |
      | revisedInsuranceFee    | 3                     |
      | revisedTax             | 2                     |
      | revisedTotalBillAmount | 27                    |
      | deltaAmount            | 16.092                |
      | remarks                | Fee has been revised. |
      | internalCommentary     | {empty}               |