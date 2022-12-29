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


