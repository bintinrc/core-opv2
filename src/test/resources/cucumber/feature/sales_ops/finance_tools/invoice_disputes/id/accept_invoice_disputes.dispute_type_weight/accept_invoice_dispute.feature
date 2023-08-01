@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsID @InvoiceDisputesID

Feature: Accept Invoice Disputes

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Manually Approve TID with Dispute Type "Billing Weight" - Calculate Revised Delivery Fee - Input INT - Input Internal Commentary - Save by "Save and Exit" - ID (uid:8c41eb85-c798-4cdd-878c-eb16a39b3a9c)
    Given API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Script Engine - Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_SHIPPER_SHIPPER.id}"
      | {"shipper_id": "{KEY_SHIPPER_SHIPPER.id}","effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","comments": null,"pricing_script_id": {pricing-script-id-all}, "pricing_levers": {"cod_min_fee": 50,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    And API Auth - Operator generate client id and client secret for shipper with data below:
      | appCode   | SHIPPER                        |
      | appUserId | {KEY_SHIPPER_SHIPPER.legacyId} |
      | systemId  | id                             |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientId}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {KEY_AUTH_LIST_OF_CLIENT_CREDENTIALS[1].clientSecret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":{"weight": 2.0}} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                       |
      | hubId                | {hub-id-2}                                                  |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ARRIVED_AT_SORTING_HUB"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Then DB Billing - Operator verifies order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}" is added to billing_qa_gl.priced_orders
    Then API Billing - Operator creates invoice disputes using below data:
      | {"dispute_filed_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","dispute_memo":"test dispute","dispute_person_email":"qa@ninjavan.co","dispute_person_name":"Automation","external_ref":"external_ref_{gradle-next-0-day-yyyyMMddHHmmsss}","invoice_id":"invoice_id_{gradle-next-0-day-yyyyMMddHHmmsss}","shipper_id":{KEY_SHIPPER_SHIPPER.id},"tids":[{"tid":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","dispute_memo":"test dispute","issues":[{"dispute_memo":"fee-zone dispute memo for this TID","type":"weight","proposed_weight":"3.0"}]}]} |
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
      | originalBilledAmount | 18.5000                               |
      | codAmount            | 5                                     |
    Then Operator clicks accept button
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 18                       |
      | originalRTSFee         | 0                        |
      | originalCODFee         | 0.5                      |
      | originalInsuranceFee   | 0                        |
      | originalTax            | 0.2035                   |
      | originalBillAmount     | 18.7035                  |
      | revisedDeliveryFee     | {empty}                  |
      | revisedRTSFee          | {empty}                  |
      | revisedCODFee          | {empty}                  |
      | revisedInsuranceFee    | {empty}                  |
      | revisedTax             | {empty}                  |
      | revisedTotalBillAmount | {empty}                  |
      | deltaAmount            | {empty}                  |
      | remarks                | Tagihan telah diperbarui |
      | internalCommentary     | {empty}                  |
    And Operator clicks calculate button
    And Operator enters Manual Resolution data using data below:
      | revisedWeightInput | 4                               |
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
      | financeRevisedDeliveryFee           | 27                                    |
      | financeRevisedCodFee                | 0.5                                   |
      | deltaOfOriginalBillAmtAndRevisedAmt | 9.0990                                |
    And Operator click action button in Manual Resolution tab for "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" TID
    And Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:
      | tid                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | disputeType          | Billing Weight                        |
      | completionDate       | {gradle-next-0-day-yyyy-MM-dd}        |
      | rts                  | No                                    |
      | originalBilledAmount | 18.5000                               |
      | codAmount            | 5                                     |
    And Operator verifies Manual Resolution data in manual resolution modal using data below:
      | originalDeliveryFee    | 18                              |
      | originalRTSFee         | 0                               |
      | originalCODFee         | 0.5                             |
      | originalInsuranceFee   | 0                               |
      | originalTax            | 0.2035                          |
      | originalBillAmount     | 18.7035                         |
      | revisedDeliveryFee     | 27                              |
      | revisedRTSFee          | 0                               |
      | revisedCODFee          | 0.5                             |
      | revisedInsuranceFee    | 0                               |
      | revisedTax             | 0.3025                          |
      | revisedTotalBillAmount | 27.8025                         |
      | deltaAmount            | 9.0990                          |
      | remarks                | Tagihan telah diperbarui        |
      | internalCommentary     | This is a Test Accepted Dispute |