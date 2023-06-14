@OperatorV2 @OperatorV2Part1 @LaunchBrowser @SalesOps @AllOrdersFees
Feature: All Orders

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Check Parcel Fees and Total Tax in Edit Order Page - Order is RTS (uid:9f792f94-bbd4-413e-a6e3-41ae93e66544)
    Given Operator go to menu Shipper -> All Shippers
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-rts-discount-30-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-sop-v4-rts-discount-30-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 90,"insured_value": 120, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator force succeed created order without cod
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total        | 11.826 |
      | deliveryFee  | 10.5   |
      | codFee       | -      |
      | insuranceFee | 2.4    |
      | handlingFee  | 1.2    |
      | rtsFee       | -3.15  |
      | gst          | 0.876  |
      | insuredValue | 120    |

  Scenario: Operator Check Parcel Fees and Total Tax in Edit Order Page - Order is Not RTS (uid:54939c63-2079-416f-b58d-2dbffb0e59bb)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-rts-discount-30-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-sop-v4-rts-discount-30-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 90,"insured_value": 120, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total        | 15.12 |
      | deliveryFee  | 9.5   |
      | codFee       | 0.9   |
      | insuranceFee | 2.4   |
      | handlingFee  | 1.2   |
      | rtsFee       | -     |
      | gst          | 1.12  |
      | insuredValue | 120   |

  Scenario: Operator Check Billing Weight, Size, Source in Edit Order Page - Normal Order by Shipper With billing_weight_logic STANDARD - Provide Shipper, DWS and Manual Measurement - Manually Completed Order (uid:d31ba1e2-4121-4537-8471-7be918ee783a)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-standard-weight-logic-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-sop-normal-standard-weight-logic-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "XXL", "weight": "2.0", "width": "1.0", "height": "1.0", "length": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | { "hub_id":{hub-id},"dimensions": {"l": 300,"w": 300,"h": 300},"weight": {"value": "6000.0"},"barcodes": ["{KEY_CREATED_ORDER_TRACKING_ID}"] } |
    And Operator waits for 2 seconds
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id},"dimensions": {"weight": "5.0", "length": "80.0", "width": "80.0", "height": "80.0", "size": "L" } } |
    And Operator waits for 2 seconds
    When API Operator force succeed created order
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | billingWeight | 6 kg |
      | billingSize   | M    |
      | source        | DWS  |

  Scenario: Operator Check Billing Weight, Size, Source in Edit Order Page - Normal Order by Shipper With billing_weight_logic STANDARD - Provide Shipper Size and Manual Measurement - Manually Completed Order (uid:d7a3825a-52cb-4780-8636-0851d2085301)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-standard-weight-logic-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-sop-normal-standard-weight-logic-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "XXL", "weight": "2.0", "width": "1.0", "height": "1.0", "length": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator waits for 1 seconds
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id},"dimensions": {"weight": "5.0", "length": "80.0", "width": "80.0", "height": "80.0", "size": "L" } } |
    And Operator waits for 1 seconds
    When API Operator force succeed created order
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | billingWeight | 5 kg   |
      | billingSize   | XL     |
      | source        | MANUAL |

  Scenario: Operator Check Billing Weight, Size, Source in Edit Order Page - Normal Order by Shipper With billing_weight_logic STANDARD - Provide Shipper Dimensions - Send No Shipper Size & Weight - Manually Completed Order (uid:2c7a3837-86c5-44bb-aa8d-6476f7660e50)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-standard-weight-logic-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-sop-normal-standard-weight-logic-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"width": "30.0", "height": "30.0", "length": "30.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator waits for 1 seconds
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And Operator waits for 2 seconds
    When API Operator force succeed created order
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | billingWeight | 0.1 kg       |
      | billingSize   | notAvailable |
      | source        | SHIPPER      |

  Scenario: Operator Check Billing Weight, Size, Source in Edit Order Page - Normal Order by Shipper With billing_weight_logic LEGACY - Provide Shipper and DWS Measurement - Update Order Measurement - Manually Completed Order (uid:7fc77624-426a-45f3-ac33-40312cdef3e8)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-rts-discount-30-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-sop-v4-rts-discount-30-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "XXL", "weight": "2.0", "width": "1.0", "height": "1.0", "length": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | { "hub_id":{hub-id},"dimensions": {"l": 300,"w": 300,"h": 300},"weight": {"value": "6000.0"},"barcodes": ["{KEY_CREATED_ORDER_TRACKING_ID}"] } |
    And Operator waits for 1 seconds
    And API Operator update order dimensions using data below:
      | length        | 50 |
      | width         | 50 |
      | height        | 50 |
      | weight        | 11 |
      | pricingWeight | 11 |
    And API Operator update parcel size to "XL"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And Operator waits for 1 seconds
    When API Operator force succeed created order
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | billingWeight | 11 kg  |
      | billingSize   | M      |
      | source        | LEGACY |

  @DeleteNewlyCreatedShipper
  Scenario: Operator Check Billing Weight, Size, Source in Edit Order Page - Normal Order by Shipper without Pricing Profile - Manually Completed Order (uid:34d4fc49-3eb9-41eb-b66a-f65f241a81d4)
    Given API Operator create new 'normal' shipper
    And API Shipper set Shipper V4 using data below:
      | legacyId | {KEY_LEGACY_SHIPPER_ID} |
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 90,"insured_value": 120, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator waits for 1 seconds
    When API Operator force succeed created order
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | billingWeight | notAvailable |
      | billingSize   | notAvailable |
      | source        | notAvailable |

  Scenario: Operator Check Parcel Fees and Total Tax in Edit Order Page - Order is in Pending Pickup (uid:3a893e49-4bc6-4b93-abcf-693b881d2fd4)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-rts-discount-30-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-sop-v4-rts-discount-30-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 90,"insured_value": 120, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total         | 15.12  |
      | deliveryFee   | 9.5    |
      | codFee        | 0.9    |
      | insuranceFee  | 2.4    |
      | handlingFee   | 1.2    |
      | rtsFee        | -      |
      | gst           | 1.12   |
      | insuredValue  | 120    |
      | billingWeight | 1 kg   |
      | billingSize   | S      |
      | source        | LEGACY |


  Scenario: Operator Check Parcel Fees and Total Tax in Edit Order Page - Price change when order is in Arrived at Sorting Hub (uid:3da0b054-fe4a-402f-b99d-a8a96d46150c)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-rts-discount-30-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-sop-v4-rts-discount-30-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 2.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 1 seconds
    Then API Operator update order pricing_weight to 5.0
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total         | 56.7   |
      | deliveryFee   | 52.5   |
      | codFee        | -      |
      | insuranceFee  | -      |
      | handlingFee   | -      |
      | rtsFee        | -      |
      | gst           | 4.2    |
      | insuredValue  | -      |
      | billingWeight | 5 kg   |
      | billingSize   | S      |
      | source        | LEGACY |

  Scenario: Operator Check Parcel Fees and Total Tax in Edit Order Page - Order in Arrived at Sorting Hub and return price error (uid:645b057b-8afa-4d50-8dba-59c1ca60c882)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-no-pricing-profile-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-sop-normal-no-pricing-profile-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 2.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 1 seconds
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total        | - |
      | deliveryFee  | - |
      | codFee       | - |
      | insuranceFee | - |
      | handlingFee  | - |
      | rtsFee       | - |
      | gst          | - |
      | insuredValue | - |


  Scenario: Operator Check Parcel Fees and Total Tax in Edit Order Page - Order in Completed and return price error (uid:d29c1bc5-2075-45c8-be6e-4f606e371488)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-no-pricing-profile-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-sop-normal-no-pricing-profile-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 2.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 1 seconds
    And API Operator force succeed created order
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total        | - |
      | deliveryFee  | - |
      | codFee       | - |
      | insuranceFee | - |
      | handlingFee  | - |
      | rtsFee       | - |
      | gst          | - |
      | insuredValue | - |

  Scenario: Operator Check Parcel Fees and Total Tax in Edit Order Page - Price change after batch recalculate when order is Arrived at Sorting Hub (uid:c16a42ba-831a-4d67-bdf0-5333e4dfe5ad)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-rts-discount-30-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-sop-v4-rts-discount-30-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 2.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 1 seconds
    Then API Operator update order pricing_weight to 1.0
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator recalculate order price
    Then API Operator update order pricing_weight to 5.0
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total         | 56.7   |
      | deliveryFee   | 52.5   |
      | codFee        | -      |
      | insuranceFee  | -      |
      | handlingFee   | -      |
      | rtsFee        | -      |
      | gst           | 4.2    |
      | insuredValue  | -      |
      | billingWeight | 5 kg   |
      | billingSize   | S      |
      | source        | LEGACY |


  Scenario: Operator Check All Pricing Details Edit Order Page - Shipper Has BWL = Legacy - Normal Order - Provide Shipper and DWS Measurement -  Driver Success Delivery Order - Bulk Update Order's Weight
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-so-normal-noDiscount-pl-def-bwl-legacy-94169-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-so-normal-noDiscount-pl-def-bwl-legacy-94169-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 90,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "L", "weight": "7.0", "width": "50.0", "height": "50.0", "length": "50.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 2 seconds
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | { "hub_id":{hub-id},"dimensions": {"l": 300,"w": 300,"h": 300},"weight": {"value": 6000},"barcodes": ["{KEY_CREATED_ORDER_TRACKING_ID}"] } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verifies pricing information on Edit Order page:
      | total         | 22.356 |
      | deliveryFee   | 18.0   |
      | codFee        | 2.7    |
      | insuranceFee  | -      |
      | handlingFee   | -      |
      | rtsFee        | -      |
      | gst           | 1.656  |
      | insuredValue  | 75     |
      | billingWeight | 6 kg   |
      | billingSize   | M      |
      | source        | LEGACY |
    Then API Operator update order pricing_weight to 4.32 using order-weight-update
    And Finance Operator waits for "1" seconds
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total         | 16.9128 |
      | deliveryFee   | 12.96   |
      | codFee        | 2.7     |
      | insuranceFee  | -       |
      | handlingFee   | -       |
      | rtsFee        | -       |
      | gst           | 1.2528  |
      | insuredValue  | 75      |
      | billingWeight | 4.32 kg |
      | billingSize   | M       |
      | source        | LEGACY  |

  Scenario: Operator Check All Pricing Details Edit Order Page - Shipper Has BWL = Legacy - Normal Order - Order Has All Fees - Update Order's To Address Zone - Driver Inbound Scan - Update Order's Weight - Batch Recalculate
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-so-normal-noDiscount-pl-def-bwl-legacy-94169-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-so-normal-noDiscount-pl-def-bwl-legacy-94169-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 90,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "L", "weight": "7.0", "width": "50.0", "height": "50.0", "length": "50.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 2 seconds
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator edits the delivery details of an order using data below:
      | orderId | {KEY_CREATED_ORDER_ID}                                                                                                                                                                                                                                                                                                                  |
      | request | {"to":{"name":"QA-SO-Automation","email":"address.sg.6598980000@ninjavan.co","phone_number":"+6281386061359","address":{"address1":"204a Compassvale Drive, Singapore 541204, Singapore","address2":"204a","postcode":"018981","city":"Singapore","country":"Singapore","latitude":1.3937771459369028,"longitude":103.89553739533046}}} |
    Then Operator waits for 1 seconds
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    Then API Operator update order pricing_weight to 5.0
    Then Operator waits for 2 seconds
    Then API Operator recalculate order price
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verifies pricing information on Edit Order page:
      | total         | 24.516 |
      | deliveryFee   | 20.0   |
      | codFee        | 2.7    |
      | insuranceFee  | -      |
      | handlingFee   | -      |
      | rtsFee        | -      |
      | gst           | 1.816  |
      | insuredValue  | 75     |
      | billingWeight | 5 kg   |
      | billingSize   | L      |
      | source        | LEGACY |

  Scenario: Operator Check Delivery Fee is shown as Nett Delivery Fee in Edit Order Page - Order has campaign flat discount (uid:43e80c37-cd8a-44fe-8f50-586d3d5cae9e)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper_active_campaign_standard_parcel-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper_active_campaign_standard_parcel-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "M", "weight": 2.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 1 seconds
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total       | 21.6 |
      | deliveryFee | 20   |

  Scenario: Operator Check Delivery Fee is shown as Nett Delivery Fee in Edit Order Page - Order has campaign percentage discount (uid:b6d2808c-89a2-4bf6-ba6b-74f8558bd2a3)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper_active_campaign_standard_parcel-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper_active_campaign_standard_parcel-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"NEXTDAY","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "M", "weight": 2.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator waits for 1 seconds
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total       | 37.8 |
      | deliveryFee | 35.0 |