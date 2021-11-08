@OperatorV2 @OperatorV2Part1 @LaunchBrowser @SalesOps @AllOrders
Feature: All Orders

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Check Parcel Fees and Total Tax in Edit Order Page - Order is RTS (uid:9f792f94-bbd4-413e-a6e3-41ae93e66544)
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
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total        | 10.593 |
      | deliveryFee  | 9      |
      | codFee       | -      |
      | insuranceFee | 2.4    |
      | handlingFee  | 1.2    |
      | rtsFee       | -2.7   |
      | gst          | 0.693  |
      | insuredValue | 120    |

  Scenario: Operator Check Parcel Fees and Total Tax in Edit Order Page - Order is Not RTS (uid:54939c63-2079-416f-b58d-2dbffb0e59bb)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-rts-discount-30-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-sop-v4-rts-discount-30-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","is_rts": true, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "To Address1","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 90,"insured_value": 120, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And Finance Operator waits for "1" seconds
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total        | 14.98 |
      | deliveryFee  | 9.5   |
      | codFee       | 0.9   |
      | insuranceFee | 2.4   |
      | handlingFee  | 1.2   |
      | rtsFee       | -     |
      | gst          | 0.98  |
      | insuredValue | 120   |