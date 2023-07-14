@OperatorV2 @Core @EditOrderV2 @MaskOrderInfo
Feature: Mask Order Info

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Edit Delivery Details Once Contact Has Less Than 5 Chars - Order is Masked
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "1234","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | 1234                                                                                                                                                                                                                        |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)orth {gradle-current-date-yyyyMMddHHmmsss} Click to reveal (tracked) {gradle-current-date-yyyyMMddHHmmsss} 159363 SG |
    When Operator click Delivery -> Edit delivery details on Edit Order V2 page
    Then Operator verify values in Edit delivery details dialog on Edit Order V2 page:
      | recipientContact | 1234 |
    When Operator edit delivery details on Edit Order V2 page:
      | recipientContact | 12345 |
    Then Operator verifies that success react notification displayed:
      | top | Delivery details updated |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | *2345 |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | contact            | Click to reveal (tracked)2345                                                                                                                                                                                               |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)orth {gradle-current-date-yyyyMMddHHmmsss} Click to reveal (tracked) {gradle-current-date-yyyyMMddHHmmsss} SG 159363 |
    When Operator unmask contact number of Delivery transaction on Edit Order V2 page
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | contact | 12345 |
    When Operator unmask destination address of Delivery transaction on Edit Order V2 page
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | destinationAddress | 998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss} home {gradle-current-date-yyyyMMddHHmmsss} SG 159363 |