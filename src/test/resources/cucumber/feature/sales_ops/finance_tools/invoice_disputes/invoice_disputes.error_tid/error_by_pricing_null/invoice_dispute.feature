@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @InvoiceDisputes @ErrorByPricingNullInvoiceDisputes

Feature: Error By Pricing Null Invoice Disputes

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Resolve TID with Dispute Type = "Billing Weight" - Invoice Dispute Status is Open - TID has Automatic Resolution with Error Pricing Null - Input Some Original Fees Breakdown with Internal Commentary - Not Update Revised Fees Breakdown (uid:cab512a2-cd3d-4b73-9e7f-d90c3ed63fd9)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-error-pricing},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 10.1 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"weight","proposed_weight":"9.9"}]}]} |
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
      | originalBilledAmount | -                                   |
      | codAmount            | 5                                   |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 0                     |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0                     |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0                     |
      | originalBillAmount     | 0                     |
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
      | nvOriginalBilledAmount | 10                              |
      | revisedWeightInput     | 9                               |
      | originalDeliveryFee    | 10                              |
      | internalCommentary     | This is a Test Accepted Dispute |
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
      | financeRevisedDeliveryFee           | 7                                     |
      | financeRevisedCodFee                | 0.1                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | -2.332                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | disputeType          | Billing Weight                      |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}      |
      | rts                  | No                                  |
      | originalBilledAmount | 10                                  |
      | codAmount            | 5                                   |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 10                    |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0                     |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0                     |
      | originalBillAmount     | 10                    |
      | revisedDeliveryFee     | 7                     |
      | revisedRTSFee          | 0                     |
      | revisedCODFee          | 0.1                   |
      | revisedInsuranceFee    | 0                     |
      | revisedTax             | 0.568                 |
      | revisedTotalBillAmount | 7.668                 |
      | deltaAmount            | -2.332                |
      | remarks                | Fee has been revised. |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Resolve TID with Dispute Type = "Non-Weight" - Invoice Dispute Status is Open - TID has Automatic Resolution with Error Pricing Null - Input for All Original Fees Breakdown and Revised Fees Breakdown - without Internal Commentary (uid:7c4e94bd-5a40-4235-95d6-662608661cde)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-error-pricing},"salesperson_discount": {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","discount_amount": 2,"type": "FLAT"},"pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | sg                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 5,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 10.1 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"fees/cod"}]}]} |
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
      | disputeType                         | Fees - COD                            |
      | status                              | Error                                 |
      | financeRevisedDeliveryFee           | Pending                               |
      | financeRevisedCodFee                | Pending                               |
      | deltaOfOriginalBillAmtAndRevisedAmt | Pending                               |
    And Operator click action button in Error TID tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | disputeType          | Fees - COD                          |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}      |
      | rts                  | No                                  |
      | originalBilledAmount | -                                   |
      | codAmount            | 5                                   |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 0                     |
      | originalRTSFee         | 0                     |
      | originalCODFee         | 0                     |
      | originalInsuranceFee   | 0                     |
      | originalTax            | 0                     |
      | originalBillAmount     | 0                     |
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
      | originalDeliveryFee    | 1.23  |
      | originalRTSFee         | 2.34  |
      | originalCODFee         | 3.21  |
      | originalInsuranceFee   | 5.43  |
      | originalTax            | 6.75  |
      | nvOriginalBilledAmount | 88.31 |
      | revisedDeliveryFee     | 2     |
      | revisedRTSFee          | 3     |
      | revisedCODFee          | 4     |
      | revisedInsuranceFee    | 5     |
      | revisedTax             | 6     |
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
      | financeRevisedDeliveryFee           | 2                                     |
      | financeRevisedCodFee                | 4                                     |
      | deltaOfOriginalBillAmtAndRevisedAmt | -68.31                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | disputeType          | Fees - COD                          |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}      |
      | rts                  | No                                  |
      | originalBilledAmount | 81.56                               |
      | codAmount            | 5                                   |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 1.23                  |
      | originalRTSFee         | 2.34                  |
      | originalCODFee         | 3.21                  |
      | originalInsuranceFee   | 5.43                  |
      | originalTax            | 6.75                  |
      | originalBillAmount     | 88.31                 |
      | revisedDeliveryFee     | 2                     |
      | revisedRTSFee          | 3                     |
      | revisedCODFee          | 4                     |
      | revisedInsuranceFee    | 5                     |
      | revisedTax             | 6                     |
      | revisedTotalBillAmount | 20                    |
      | deltaAmount            | -68.31                |
      | remarks                | Fee has been revised. |