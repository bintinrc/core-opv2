@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @InvoiceDisputes @ErrorByScriptEngineInvoiceDisputes

Feature: Error By Script Engine Invoice Disputes

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Resolve TID with Dispute Type = "Billing Weight" - Invoice Dispute Status is Open - Multiple TIDs has Automatic Resolution with Status Error from Script Engine - Update Some Revised Fees Breakdown and Original Fees Breakdown (uid:c9b3bcda-e239-4203-8fa9-68e890d30a63)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-error-pricing},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 9.9 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[2].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fees/promo dispute memo for this TID","type":"weight","proposed_weight":"10.1"}]},{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fees/promo dispute memo for this TID","type":"weight","proposed_weight":"10.1"}]}]} |
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
      | numberOfValidTIDs   | - |
      | pendingTIDs         | - |
      | acceptedTIDs        | - |
      | rejectedTIDs        | - |
      | errorTIDs           | 2 |
    And Operator verifies Error TID Disputed Orders in Invoice Dispute page using below data:
      | errorTIDCount                       | 2                                                                           |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType                         | Billing Weight,Billing Weight                                               |
      | status                              | Error,Error                                                                 |
      | financeRevisedDeliveryFee           | Pending,Pending                                                             |
      | financeRevisedCodFee                | Pending,Pending                                                             |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending,Pending                                                             |
    And Operator click action button in Error TID tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | disputeType          | Billing Weight                      |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}      |
      | rts                  | No                                  |
      | originalBilledAmount | 8                                   |
      | codAmount            | 5                                   |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 7.9                   |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.64                  |
      | originalBillAmount     | 8.64                  |
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
      | revisedDeliveryFee     | 10                              |
      | nvOriginalBilledAmount | 9                               |
      | internalCommentary     | This is a Test Accepted Dispute |
    And Operator clicks save and exit button
    And Operator verifies Invoice Dispute Case Information using below data:
      | numberOfInvalidTIDs | - |
      | numberOfValidTIDs   | 1 |
      | pendingTIDs         | - |
      | acceptedTIDs        | 1 |
      | rejectedTIDs        | - |
      | errorTIDs           | 1 |
    And Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:
      | manualResolutionCount               | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Accepted                              |
      | financeRevisedDeliveryFee           | 10                                    |
      | financeRevisedCodFee                | 0.1                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | 2.10                                  |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | disputeType          | Billing Weight                      |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}      |
      | rts                  | No                                  |
      | originalBilledAmount | 8                                   |
      | codAmount            | 5                                   |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 7.9                   |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.64                  |
      | originalBillAmount     | 8.64                  |
      | revisedDeliveryFee     | 10                    |
      | revisedRTSFee          | 0                     |
      | revisedCODFee          | 0.1                   |
      | revisedInsuranceFee    | 0                     |
      | revisedTax             | 0.64                  |
      | revisedTotalBillAmount | 10.74                 |
      | deltaAmount            | 2.10                  |
      | remarks                | Fee has been revised. |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Resolve TID with Dispute Type = "Billing Weight" - Invoice Dispute Status is Open - TID has Manual Resolution with Status Error from Script Engine - Not Input Revised Weight - Input All Revised Fees Breakdown - Submit with Internal Commentary (uid:a422f840-8b3b-43da-ab46-ad87a3bc674e)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-error-pricing},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 9.9 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"weight","proposed_weight":"10.1"}]}]} |
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
      | numberOfValidTIDs   | - |
      | pendingTIDs         | - |
      | acceptedTIDs        | - |
      | rejectedTIDs        | - |
      | errorTIDs           | 1 |
    And Operator verifies Error TID Disputed Orders in Invoice Dispute page using below data:
      | errorTIDCount                       | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Error                                 |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Error TID tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | disputeType          | Billing Weight                      |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}      |
      | rts                  | No                                  |
      | originalBilledAmount | 8                                   |
      | codAmount            | 5                                   |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 7.9                   |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.64                  |
      | originalBillAmount     | 8.64                  |
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
      | revisedDeliveryFee  | 10                              |
      | revisedRTSFee       | 3                               |
      | revisedCODFee       | 4                               |
      | revisedInsuranceFee | 5                               |
      | revisedTax          | 6                               |
      | internalCommentary  | This is a Test Accepted Dispute |
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
      | financeRevisedDeliveryFee           | 10                                    |
      | financeRevisedCodFee                | 4                                     |
      | deltaOfOriginalBillAmtAndRevisedAmt | 19.36                                 |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | disputeType          | Billing Weight                      |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}      |
      | rts                  | No                                  |
      | originalBilledAmount | 8                                   |
      | codAmount            | 5                                   |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 7.9                   |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0.1                   |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0.64                  |
      | originalBillAmount     | 8.64                  |
      | revisedDeliveryFee     | 10                    |
      | revisedRTSFee          | 3                     |
      | revisedCODFee          | 4                     |
      | revisedInsuranceFee    | 5                     |
      | revisedTax             | 6                     |
      | revisedTotalBillAmount | 28                    |
      | deltaAmount            | 19.36                 |
      | remarks                | Fee has been revised. |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Resolve TID with Dispute Type = "Billing Weight" - Invoice Dispute Status is Open - TID has Automatic Resolution with Status Error from Script Engine - Input INT without Internal Commentary - Manually Reject (uid:432aadd3-f311-43db-9c9a-4cf599aec643)
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
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 9.9 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"weight","proposed_weight":"10.1"}]}]} |
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
      | numberOfValidTIDs   | - |
      | pendingTIDs         | - |
      | acceptedTIDs        | - |
      | rejectedTIDs        | - |
      | errorTIDs           | 1 |
    And Operator verifies Error TID Disputed Orders in Invoice Dispute page using below data:
      | errorTIDCount                       | 1                                     |
      | trackingId                          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType                         | Billing Weight                        |
      | status                              | Error                                 |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | disputeType          | Billing Weight                      |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}      |
      | rts                  | No                                  |
      | originalBilledAmount | 17.900                              |
      | codAmount            | 5                                   |
    Then Operator clicks reject button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | remarks            | Correct weight was charged based on Ninja weighing system. |
      | internalCommentary | {empty}                                                    |
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
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | disputeType          | Billing Weight                      |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}      |
      | rts                  | No                                  |
      | originalBilledAmount | 17.900                              |
      | codAmount            | 5                                   |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | customRemarkInput  | Correct weight was charged based on Ninja weighing system. |
      | internalCommentary | This is a Test Rejected Dispute                            |