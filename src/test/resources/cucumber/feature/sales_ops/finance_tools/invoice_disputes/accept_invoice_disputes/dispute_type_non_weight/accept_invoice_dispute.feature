@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @InvoiceDisputes @AcceptInvoiceDisputes

Feature: Accept Invoice Disputes

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Manually Approve TID with Dispute Type "Fees - Zone" and TID has all Fees - Input Finance Revised Delivery Fee with Decimal - Input NV original bill amount with INT - Input Internal Commentary - Save by "Save and Exit" (uid:6a759beb-388d-46b6-98f1-d534bb137b53)
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
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"fees/zone"}]}]} |
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
      | disputeType                         | Fees - Zone                           |
      | status                              | Pending                               |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Fees - Zone                           |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                     |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.648                 |
      | originalBillAmount     | 8.748                 |
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
      | revisedDeliveryFee | 7.45                            |
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
      | disputeType                         | Fees - Zone                           |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 7.45                                  |
      | financeRevisedCodFee                | 0.1                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | -0.550                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Fees - Zone                           |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                               |
      | originalRTSFee         | 0                               |
      | originalCODFee         | 0.1                             |
      | originalInsuranceFee   | 0                               |
      | originalTax            | 0.648                           |
      | originalBillAmount     | 8.748                           |
      | revisedDeliveryFee     | 7.45                            |
      | revisedRTSFee          | 0                               |
      | revisedCODFee          | 0.1                             |
      | revisedInsuranceFee    | 0                               |
      | revisedTax             | 0.648                           |
      | revisedTotalBillAmount | 8.198                           |
      | deltaAmount            | -0.550                          |
      | remarks                | Fee has been revised.           |
      | internalCommentary     | This is a Test Accepted Dispute |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Manually Approve TID with Dispute Type "Fees - Promo" and TID has all Fees - Input Finance Revised Delivery Fee and COD Fee with INT - Without Input Internal Commentary - Save by "Save and Next" (uid:efcf516d-de6f-446c-a554-580e70f12418)
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
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[2].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fees/promo dispute memo for this TID","type":"fees/promo"}]},{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fees/promo dispute memo for this TID","type":"fees/promo"}]}]} |
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
      | manualResolutionCount               | 2                                                                           |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType                         | Fees - Pricing promo,Fees - Pricing promo                                   |
      | status                              | Pending,Pending                                                             |
      | financeRevisedDeliveryFee           | Pending,Pending                                                             |
      | financeRevisedCodFee                | Pending,Pending                                                             |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending,Pending                                                             |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType          | Fees - Pricing promo                  |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                     |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.648                 |
      | originalBillAmount     | 8.748                 |
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
      | revisedDeliveryFee | 7 |
      | revisedCODFee      | 1 |
    And Operator clicks save and next button
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Fees - Pricing promo                  |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
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
      | manualResolutionCount               | 2                                                                           |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType                         | Fees - Pricing promo,Fees - Pricing promo                                   |
      | status                              | Pending,Accepted                                                            |
      | financeRevisedDeliveryFee           | Pending,7                                                                   |
      | financeRevisedCodFee                | Pending,1                                                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending,-0.100                                                              |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType          | Fees - Pricing promo                  |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                     |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.648                 |
      | originalBillAmount     | 8.748                 |
      | revisedDeliveryFee     | 7                     |
      | revisedRTSFee          | 0                     |
      | revisedCODFee          | 1                     |
      | revisedInsuranceFee    | 0                     |
      | revisedTax             | 0.648                 |
      | revisedTotalBillAmount | 8.648                 |
      | deltaAmount            | -0.100                |
      | remarks                | Fee has been revised. |
      | internalCommentary     | {empty}               |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Manually Approve TID with Dispute Type "Others" and TID has all Fees - Input Finance Revised Delivery Fee and COD Fee with INT - Input All Original Fees Breakdown - Input Internal Commentary - Save by "Save and Exit" (uid:e4939339-bad8-4d6a-8a9f-428cfa8472ff)
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
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"others dispute memo for this TID","type":"others"}]}]} |
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
      | disputeType                         | Others                                |
      | status                              | Pending                               |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Others                                |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                     |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.648                 |
      | originalBillAmount     | 8.748                 |
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
      | revisedDeliveryFee | 7                               |
      | revisedCODFee      | 1                               |
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
      | disputeType                         | Others                                |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 7                                     |
      | financeRevisedCodFee                | 1                                     |
      | deltaOfOriginalBillAmtAndRevisedAmt | -0.100                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Others                                |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                               |
      | originalRTSFee         | 0                               |
      | originalCODFee         | 0.1                             |
      | originalInsuranceFee   | 0                               |
      | originalTax            | 0.648                           |
      | originalBillAmount     | 8.748                           |
      | revisedDeliveryFee     | 7                               |
      | revisedRTSFee          | 0                               |
      | revisedCODFee          | 1                               |
      | revisedInsuranceFee    | 0                               |
      | revisedTax             | 0.648                           |
      | revisedTotalBillAmount | 8.648                           |
      | deltaAmount            | -0.100                          |
      | remarks                | Fee has been revised.           |
      | internalCommentary     | This is a Test Accepted Dispute |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Manually Approve TID with Dispute Type "Fees - COD" that already "Rejected" before - Remarks is auto-populated - Input Finance Revised Delivery Fee and COD Fee with INT - Input Internal Commentary - Save by "Save and Exit" (uid:593e65a9-5935-4218-9433-f6d09e9af792)
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
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fees/cod dispute memo for this TID","type":"fees/cod"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | shipperId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator click load selection
    And Operator clicks action button
    And DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    Then Operator clicks reject button
    And Operator select remark as "Correct rate was charged."
    And Operator clicks save and exit button
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | - |
      | acceptedTIDs        | - |
      | rejectedTIDs        | 1 |
      | errorTIDs           | - |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Fees - COD                            |
      | status                              | Rejected                              |
      | financeRevisedDeliveryFee           | -                                     |
      | financeRevisedCodFee                | -                                     |
      | deltaOfOriginalBillAmtAndRevisedAmt | -                                     |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    Then Operator clicks Manual adjustment button
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Fees - COD                            |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                     |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.648                 |
      | originalBillAmount     | 8.748                 |
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
      | revisedDeliveryFee | 7                               |
      | revisedCODFee      | 1                               |
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
      | disputeType                         | Fees - COD                            |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 7                                     |
      | financeRevisedCodFee                | 1                                     |
      | deltaOfOriginalBillAmtAndRevisedAmt | -0.100                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Fees - COD                            |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                               |
      | originalRTSFee         | 0                               |
      | originalCODFee         | 0.1                             |
      | originalInsuranceFee   | 0                               |
      | originalTax            | 0.648                           |
      | originalBillAmount     | 8.748                           |
      | revisedDeliveryFee     | 7                               |
      | revisedRTSFee          | 0                               |
      | revisedCODFee          | 1                               |
      | revisedInsuranceFee    | 0                               |
      | revisedTax             | 0.648                           |
      | revisedTotalBillAmount | 8.648                           |
      | deltaAmount            | -0.100                          |
      | remarks                | Fee has been revised.           |
      | internalCommentary     | This is a Test Accepted Dispute |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Update Finance Revised Delivery Fee for TID with Dispute Type "Non-Weight" that already "Accepted" before (uid:124ffcf0-b219-48c2-90a8-bcc517111dd9)
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
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fees/cod dispute memo for this TID","type":"fees/cod"}]}]} |
    And Operator go to menu Finance Tools -> Invoice Disputes
    When Invoice Dispute Orders page is loaded
    Then Operator add filters according to data below:
      | shipperId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | fromDate  | {gradle-next-0-day-yyyy-MM-dd} |
      | toDate    | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator click load selection
    And Operator clicks action button
    And DB Billing - Operator gets disputes details from the billing_qa_gl.invoice_disputes table for case id "{KEY_LIST_OF_INVOICE_DISPUTES_CASE_IDS[1]}"
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    Then Operator clicks accept button
    And Operator enters Manual Resolution data using data below:
      | revisedDeliveryFee | 6   |
      | revisedCODFee      | 0.5 |
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
      | disputeType                         | Fees - COD                            |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 6                                     |
      | financeRevisedCodFee                | 0.5                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | -1.600                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    Then Operator clicks Manual adjustment button
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Fees - COD                            |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                     |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.648                 |
      | originalBillAmount     | 8.748                 |
      | revisedDeliveryFee     | 6                     |
      | revisedRTSFee          | 0                     |
      | revisedCODFee          | 0.5                   |
      | revisedInsuranceFee    | 0                     |
      | revisedTax             | 0.648                 |
      | revisedTotalBillAmount | 7.148                 |
      | deltaAmount            | -1.600                |
      | remarks                | Fee has been revised. |
      | internalCommentary     | {empty}               |
    And Operator enters Manual Resolution data using data below:
      | revisedDeliveryFee | 7                               |
      | revisedCODFee      | 1                               |
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
      | disputeType                         | Fees - COD                            |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 7                                     |
      | financeRevisedCodFee                | 1                                     |
      | deltaOfOriginalBillAmtAndRevisedAmt | -0.100                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Fees - COD                            |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 8.1                                   |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 8                               |
      | originalRTSFee         | 0                               |
      | originalCODFee         | 0.1                             |
      | originalInsuranceFee   | 0                               |
      | originalTax            | 0.648                           |
      | originalBillAmount     | 8.748                           |
      | revisedDeliveryFee     | 7                               |
      | revisedRTSFee          | 0                               |
      | revisedCODFee          | 1                               |
      | revisedInsuranceFee    | 0                               |
      | revisedTax             | 0.648                           |
      | revisedTotalBillAmount | 8.648                           |
      | deltaAmount            | -0.100                          |
      | remarks                | Fee has been revised.           |
      | internalCommentary     | This is a Test Accepted Dispute |