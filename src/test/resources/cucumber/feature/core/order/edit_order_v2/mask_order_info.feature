@OperatorV2 @Core @Order @MaskOrderInfo
Feature: Mask Order Info

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
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

  Scenario: Operator Edit RTS Details on RTS Order When Masked - Update All Details (Contact & Address Changed)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                          |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK 102600 SG 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                               |
      | contact            | Click to reveal (tracked)0004                                                                          |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK 102600 SG SG 102600 |
    When Operator click Delivery -> Return to sender on Edit Order V2 page
    And Operator verifies values in Edit RTS details dialog on Edit Order V2 page:
      | country    | SG           |
      | city       | -            |
      | address1   | Keng Lee Rd  |
      | address2   | Kilang Barat |
      | postalCode | 308402       |
    And Operator RTS order on Edit Order V2 page using data below:
      | reason           | Nobody at address              |
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | All Day (9AM - 10PM)           |
      | recipientContact | 12345678                       |
      | country          | Singapore                      |
      | city             | Singapore                      |
      | address1         | 50 Amber Rd                    |
      | address2         | new home                       |
      | postalCode       | 439888                         |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)5678                                                                                                                                    |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                         |
      | contact            | Click to reveal (tracked)5678                                                                                                                                    |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home Singapore Singapore 439888 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | 12345678                                        |
      | address | 50 Amber Rd new home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                        |
      | contact            | 12345678                                        |
      | destinationAddress | 50 Amber Rd new home Singapore Singapore 439888 |

  Scenario: Operator Edit Return Details on RTS Order When Masked - Update All Details (Contact & Address Changed)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)4434                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)ng Barat 308402 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                  |
      | contact            | Click to reveal (tracked)4434                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)ng Barat SG 308402 |
    When Operator click Return to sender -> Edit RTS Details on Edit Order V2 page
    And Operator verify values in Edit return details dialog on Edit Order V2 page:
      | recipientContact | Click to reveal (tracked)4434                                                 |
      | country          | SG                                                                            |
      | city             | -                                                                             |
      | address1         | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) |
      | address2         | Click to reveal (tracked)ng Barat                                             |
      | postalCode       | 308402                                                                        |
    And Operator edit Return details on Edit Order V2 page:
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | All Day (9AM - 10PM)           |
      | recipientContact | 12345678                       |
      | country          | Singapore                      |
      | city             | Singapore                      |
      | address1         | 50 Amber Rd                    |
      | address2         | new home                       |
      | postalCode       | 439888                         |
    Then Operator verifies that success react notification displayed:
      | top                | Return details updated |
      | waitUntilInvisible | true                   |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)5678                                                                                                                                    |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                         |
      | contact            | Click to reveal (tracked)5678                                                                                                                                    |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home Singapore Singapore 439888 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | 12345678                                        |
      | address | 50 Amber Rd new home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                        |
      | contact            | 12345678                                        |
      | destinationAddress | 50 Amber Rd new home Singapore Singapore 439888 |

  Scenario: Operator Edit RTS Details on RTS Order When Unmasked - Update All Details (Contact & Address Changed)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                          |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK 102600 SG 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                               |
      | contact            | Click to reveal (tracked)0004                                                                          |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK 102600 SG SG 102600 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | +6598980004                             |
      | address | 30A ST. THOMAS WALK 102600 SG 102600 SG |
    When Operator click Delivery -> Return to sender on Edit Order V2 page
    And Operator verifies values in Edit RTS details dialog on Edit Order V2 page:
      | country    | SG           |
      | city       | -            |
      | address1   | Keng Lee Rd  |
      | address2   | Kilang Barat |
      | postalCode | 308402       |
    And Operator RTS order on Edit Order V2 page using data below:
      | reason           | Nobody at address              |
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | All Day (9AM - 10PM)           |
      | recipientContact | 12345678                       |
      | country          | Singapore                      |
      | city             | Singapore                      |
      | address1         | 50 Amber Rd                    |
      | address2         | new home                       |
      | postalCode       | 439888                         |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)5678                                                                                                                                    |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                         |
      | contact            | Click to reveal (tracked)5678                                                                                                                                    |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home Singapore Singapore 439888 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | 12345678                                        |
      | address | 50 Amber Rd new home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                        |
      | contact            | 12345678                                        |
      | destinationAddress | 50 Amber Rd new home Singapore Singapore 439888 |

  Scenario: Operator Edit Return Details on RTS Order When Unmasked - Update All Details (Contact & Address Changed)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    And API Core - Operator rts order:[
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)4434                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)ng Barat 308402 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                  |
      | contact            | Click to reveal (tracked)4434                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)ng Barat SG 308402 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | +9727894434                        |
      | address | Keng Lee Rd Kilang Barat 308402 SG |
    When Operator click Return to sender -> Edit RTS Details on Edit Order V2 page
    And Operator verify values in Edit return details dialog on Edit Order V2 page:
      | recipientContact | Click to reveal (tracked)4434                                                 |
      | country          | SG                                                                            |
      | city             | -                                                                             |
      | address1         | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) |
      | address2         | Click to reveal (tracked)ng Barat                                             |
      | postalCode       | 308402                                                                        |
    And Operator edit Return details on Edit Order V2 page:
      | reason           | Nobody at address              |
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | All Day (9AM - 10PM)           |
      | recipientContact | 12345678                       |
      | country          | Singapore                      |
      | city             | Singapore                      |
      | address1         | 50 Amber Rd                    |
      | address2         | new home                       |
      | postalCode       | 439888                         |
    Then Operator verifies that success react notification displayed:
      | top                | Return details updated |
      | waitUntilInvisible | true                   |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)5678                                                                                                                                    |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                         |
      | contact            | Click to reveal (tracked)5678                                                                                                                                    |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home Singapore Singapore 439888 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | 12345678                                        |
      | address | 50 Amber Rd new home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                        |
      | contact            | 12345678                                        |
      | destinationAddress | 50 Amber Rd new home Singapore Singapore 439888 |

  @DeleteRoutes
  Scenario: Operator Reschedule Order When Masked - Update All Details (Contact & Address Changed)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK","address2":"old address 2","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator click Order settings -> Reschedule order on Edit Order V2 page
    And Operator update delivery reschedule on Edit Order V2 page:
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | All Day (9AM - 10PM)           |
      | recipientContact | 12345678                       |
      | country          | Singapore                      |
      | city             | Singapore                      |
      | address1         | 50 Amber Rd                    |
      | address2         | new home                       |
      | postalCode       | 439888                         |
    Then Operator verifies that success react notification displayed:
      | top                | Order rescheduled successfully |
      | waitUntilInvisible | true                           |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)5678                                                                                                                                    |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                         |
      | contact            | Click to reveal (tracked)5678                                                                                                                                    |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home Singapore Singapore 439888 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | 12345678                                        |
      | address | 50 Amber Rd new home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                        |
      | contact            | 12345678                                        |
      | destinationAddress | 50 Amber Rd new home Singapore Singapore 439888 |

  @DeleteRoutes
  Scenario: Operator Reschedule Order When Masked - Update Name & Date Only (Contact & Address Unchanged)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK","address2":"old address 2","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator click Order settings -> Reschedule order on Edit Order V2 page
    And Operator update delivery reschedule on Edit Order V2 page:
      | recipientName | New name                       |
      | deliveryDate  | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot      | All Day (9AM - 10PM)           |
    Then Operator verifies that success react notification displayed:
      | top                | Order rescheduled successfully |
      | waitUntilInvisible | true                           |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | New name                                                                                                                                                  |
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | name               | New name                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | New name                                    |
      | contact | +6598980004                                 |
      | address | 30A ST. THOMAS WALK old address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                    |
      | name               | New name                                    |
      | contact            | +6598980004                                 |
      | destinationAddress | 30A ST. THOMAS WALK old address 2 SG 102600 |

  @DeleteRoutes
  Scenario: Operator Reschedule Order When Unmasked - Update All Details (Contact & Address Changed)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK","address2":"old address 2","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | +6598980004                                 |
      | address | 30A ST. THOMAS WALK old address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                    |
      | contact            | +6598980004                                 |
      | destinationAddress | 30A ST. THOMAS WALK old address 2 SG 102600 |
    When Operator click Order settings -> Reschedule order on Edit Order V2 page
    And Operator update delivery reschedule on Edit Order V2 page:
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | All Day (9AM - 10PM)           |
      | recipientContact | 12345678                       |
      | country          | Singapore                      |
      | city             | Singapore                      |
      | address1         | 50 Amber Rd                    |
      | address2         | new home                       |
      | postalCode       | 439888                         |
    Then Operator verifies that success react notification displayed:
      | top                | Order rescheduled successfully |
      | waitUntilInvisible | true                           |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)5678                                                                                                                                    |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                         |
      | contact            | Click to reveal (tracked)5678                                                                                                                                    |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home Singapore Singapore 439888 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | 12345678                                        |
      | address | 50 Amber Rd new home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                        |
      | contact            | 12345678                                        |
      | destinationAddress | 50 Amber Rd new home Singapore Singapore 439888 |

  @DeleteRoutes
  Scenario: Operator Reschedule Order When Unmasked - Update Name & Date Only (Contact & Address Unchanged)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK","address2":"old address 2","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | +6598980004                                 |
      | address | 30A ST. THOMAS WALK old address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                    |
      | contact            | +6598980004                                 |
      | destinationAddress | 30A ST. THOMAS WALK old address 2 SG 102600 |
    When Operator click Order settings -> Reschedule order on Edit Order V2 page
    And Operator update delivery reschedule on Edit Order V2 page:
      | recipientName | New name                       |
      | deliveryDate  | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot      | All Day (9AM - 10PM)           |
    Then Operator verifies that success react notification displayed:
      | top                | Order rescheduled successfully |
      | waitUntilInvisible | true                           |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | New name                                                                                                                                                  |
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | name               | New name                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | New name                                    |
      | contact | +6598980004                                 |
      | address | 30A ST. THOMAS WALK old address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                    |
      | name               | New name                                    |
      | contact            | +6598980004                                 |
      | destinationAddress | 30A ST. THOMAS WALK old address 2 SG 102600 |

  Scenario: Operator Edit Delivery Details When Masked - Update All Details (Contact & Address Changed)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK","address2":"old address 2","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator click Delivery -> Edit delivery details on Edit Order V2 page
    And Operator edit delivery details on Edit Order V2 page:
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | All Day (9AM - 10PM)           |
      | recipientContact | 12345678                       |
      | country          | Singapore                      |
      | city             | Singapore                      |
      | address1         | 50 Amber Rd                    |
      | address2         | new home                       |
      | postalCode       | 439888                         |
    Then Operator verifies that success react notification displayed:
      | top                | Delivery details updated |
      | waitUntilInvisible | true                     |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)5678                                                                                                                                    |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                         |
      | contact            | Click to reveal (tracked)5678                                                                                                                                    |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home Singapore Singapore 439888 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | 12345678                                        |
      | address | 50 Amber Rd new home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                        |
      | contact            | 12345678                                        |
      | destinationAddress | 50 Amber Rd new home Singapore Singapore 439888 |

  Scenario: Operator Edit Delivery Details When Masked - Update Name & Date Only (Contact & Address Unchanged)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK","address2":"old address 2","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator click Delivery -> Edit delivery details on Edit Order V2 page
    And Operator edit delivery details on Edit Order V2 page:
      | recipientName | New name                       |
      | deliveryDate  | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot      | All Day (9AM - 10PM)           |
    Then Operator verifies that success react notification displayed:
      | top                | Delivery details updated |
      | waitUntilInvisible | true                     |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | New name                                                                                                                                                  |
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | name               | New name                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | New name                                    |
      | contact | +6598980004                                 |
      | address | 30A ST. THOMAS WALK old address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                    |
      | name               | New name                                    |
      | contact            | +6598980004                                 |
      | destinationAddress | 30A ST. THOMAS WALK old address 2 SG 102600 |

  Scenario: Operator Edit Delivery Details When Unmasked - Update All Details (Contact & Address Changed)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK","address2":"old address 2","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | +6598980004                                 |
      | address | 30A ST. THOMAS WALK old address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                    |
      | contact            | +6598980004                                 |
      | destinationAddress | 30A ST. THOMAS WALK old address 2 SG 102600 |
    When Operator click Delivery -> Edit delivery details on Edit Order V2 page
    And Operator edit delivery details on Edit Order V2 page:
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | All Day (9AM - 10PM)           |
      | recipientContact | 12345678                       |
      | country          | Singapore                      |
      | city             | Singapore                      |
      | address1         | 50 Amber Rd                    |
      | address2         | new home                       |
      | postalCode       | 439888                         |
    Then Operator verifies that success react notification displayed:
      | top                | Delivery details updated |
      | waitUntilInvisible | true                     |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)5678                                                                                                                                    |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked)home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                        |
      | contact            | 12345678                                        |
      | destinationAddress | 50 Amber Rd new home Singapore Singapore 439888 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | 12345678                                        |
      | address | 50 Amber Rd new home 439888 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                        |
      | contact            | 12345678                                        |
      | destinationAddress | 50 Amber Rd new home Singapore Singapore 439888 |

  Scenario: Operator Edit Delivery Details When Unmasked - Update Name & Date Only (Contact & Address Unchanged)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK","address2":"old address 2","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | contact | +6598980004                                 |
      | address | 30A ST. THOMAS WALK old address 2 102600 SG |
    When Operator click Delivery -> Edit delivery details on Edit Order V2 page
    And Operator edit delivery details on Edit Order V2 page:
      | recipientName | New name                       |
      | deliveryDate  | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot      | All Day (9AM - 10PM)           |
    Then Operator verifies that success react notification displayed:
      | top                | Delivery details updated |
      | waitUntilInvisible | true                     |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | New name                                                                                                                                                  |
      | contact | Click to reveal (tracked)0004                                                                                                                             |
      | address | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                                                                                                                                  |
      | name               | New name                                                                                                                                                  |
      | contact            | Click to reveal (tracked)0004                                                                                                                             |
      | destinationAddress | Click to reveal (tracked) Click to reveal (tracked) Click to reveal (tracked) WALK Click to reveal (tracked) Click to reveal (tracked)address 2 SG 102600 |
    When Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | New name                                    |
      | contact | +6598980004                                 |
      | address | 30A ST. THOMAS WALK old address 2 102600 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                    |
      | name               | New name                                    |
      | contact            | +6598980004                                 |
      | destinationAddress | 30A ST. THOMAS WALK old address 2 SG 102600 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op