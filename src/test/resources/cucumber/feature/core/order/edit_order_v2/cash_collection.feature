@OperatorV2 @Core @EditOrderV2 @CashCollection
Feature: Cash Collection

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Edit Cash Collection Details - Add Cash on Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnPickup | yes   |
      | amount       | 10.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cop | COP SGD10 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                         |
      | description | Cash On Pickup changed from 0 to 10 |
    And DB Core - verify orders record:
      | id    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | codId | not null                           |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then DB Core - verify cods record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].cod.id} |
      | goodsAmount  | 10.00                                  |
      | collectionAt | PP                                     |

  @happy-path @HighPriority
  Scenario: Edit Cash Collection Details - Add Cash on Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes   |
      | amount         | 10.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD SGD10 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                           |
      | description | Cash On Delivery changed from 0 to 10 |
    And DB Core - verify orders record:
      | id    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | codId | not null                           |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then DB Core - verify cods record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].cod.id} |
      | goodsAmount  | 10.00                                  |
      | collectionAt | DD                                     |

  @MediumPriority
  Scenario: Edit Cash Collection Details - Update Cash on Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnPickup | yes   |
      | amount       | 10.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cop | COP SGD10 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                             |
      | description | Cash On Pickup changed from 23.57 to 10 |
    And DB Core - verify orders record:
      | id    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | codId | not null                           |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then DB Core - verify cods record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].cod.id} |
      | goodsAmount  | 10.00                                  |
      | collectionAt | PP                                     |

  @happy-path @HighPriority
  Scenario: Edit Cash Collection Details - Update Cash on Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes   |
      | amount         | 10.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD SGD10 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                               |
      | description | Cash On Delivery changed from 23.57 to 10 |
    And DB Core - verify orders record:
      | id    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | codId | not null                           |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then DB Core - verify cods record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].cod.id} |
      | goodsAmount  | 10.00                                  |
      | collectionAt | DD                                     |

  @MediumPriority
  Scenario: Edit Cash Collection Details - Remove Cash on Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnPickup | no |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator refresh page
    And Operator verify COP icon is not displayed on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                            |
      | description | Cash On Pickup changed from 23.57 to 0 |
    And DB Core - verify orders record:
      | id    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | codId | null                               |
    Then DB Core - verify cods record:
      | id        | {KEY_LIST_OF_CREATED_ORDERS[1].cod.id} |
      | deletedAt | not null                               |

  @happy-path @HighPriority
  Scenario: Edit Cash Collection Details - Remove Cash on Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | no |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator refresh page
    Then Operator verify COD icon is not displayed on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                              |
      | description | Cash On Delivery changed from 23.57 to 0 |
    And DB Core - verify orders record:
      | id    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | codId | null                               |
    Then DB Core - verify cods record:
      | id        | {KEY_LIST_OF_CREATED_ORDERS[1].cod.id} |
      | deletedAt | not null                               |

  @MediumPriority
  Scenario: Disable Update Cash Button if Order State is Completed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Completed                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Edit Cash Collection Details" is disabled on Edit Order V2 page

  @MediumPriority
  Scenario: Disable Update Cash Button if Order State is Returned to Sender
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Returned To Sender                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Returned To Sender" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Edit Cash Collection Details" is disabled on Edit Order V2 page

  @MediumPriority
  Scenario: Disable Update Cash Button if Order State is On Vehicle for Delivery with non-RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Vehicle for Delivery            |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Edit Cash Collection Details" is disabled on Edit Order V2 page

  @MediumPriority
  Scenario: Disable Update Cash Button if Order State is On Vehicle for Delivery with RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Vehicle for Delivery            |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Edit Cash Collection Details" is disabled on Edit Order V2 page

  @MediumPriority
  Scenario: Enable Update Cash Button if Order State is Arrived at Sorting Hub with non-RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes   |
      | amount         | 10.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD SGD10 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                               |
      | description | Cash On Delivery changed from 23.57 to 10 |
    And DB Core - verify orders record:
      | id    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | codId | not null                           |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then DB Core - verify cods record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].cod.id} |
      | goodsAmount  | 10.00                                  |
      | collectionAt | DD                                     |

  @MediumPriority
  Scenario: Disable Update Cash Button if Order State is Arrived at Sorting Hub with RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes   |
      | amount         | 10.00 |
    Then Operator verifies that error react notification displayed:
      | bottom | ^.*Error Message: Not allowed to update an RTS order.* |