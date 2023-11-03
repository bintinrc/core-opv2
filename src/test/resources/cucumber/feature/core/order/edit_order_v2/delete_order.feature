@OperatorV2 @Core @EditOrderV2 @DeleteOrder
Feature: Delete Order

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Disallow Delete Order - Status = Completed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Completed                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Delete Order" is disabled on Edit Order V2 page

  Scenario: Operator Disallow Delete Order - Status = Returned To Sender
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Returned To Sender                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Returned To Sender" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Delete Order" is disabled on Edit Order V2 page

  Scenario: Operator Disallow Delete Order - Status = Cancelled
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Cancelled                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify menu item "Order Settings" > "Delete Order" is disabled on Edit Order V2 page

  Scenario: Operator Disallow Delete Order - Status = En-route to Sorting Hub
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | En-route to Sorting Hub            |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order V2 page
    And Operator delete order on Edit Order V2 page
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                         |
      | bottom | ^.*Error Message: Order can only be deleted if in the following states : \[Staging, Pending Pickup, Van en-route to pickup, Pickup fail\].* |

  Scenario: Operator Disallow Delete Order - Invalid Password
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And Operator delete order on Edit Order V2 page with invalid password
    Then Operator verifies that error react notification displayed:
      | top | Invalid Password |

  @happy-path @HighPriority
  Scenario: Operator Delete Order - Status = Pending Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator delete order on Edit Order V2 page
    And Operator waits for 5 seconds
    Then Operator verifies All Orders Page is displayed
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}    |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
      | data      | {"shipper_id":{shipper-v4-legacy-id}} |

  Scenario: Operator Delete Order - Status = Staging
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Staging" on Edit Order V2 page
    And Operator verify order granular status is "Staging" on Edit Order V2 page
    And Operator delete order on Edit Order V2 page
    And Operator waits for 5 seconds
    Then Operator verifies All Orders Page is displayed
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

  Scenario: Operator Delete Order - Status = Van en-route to Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Van en-route to Pickup             |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Van en-route to Pickup" on Edit Order V2 page
    And Operator delete order on Edit Order V2 page
    And Operator waits for 5 seconds
    Then Operator verifies All Orders Page is displayed
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}    |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
      | data      | {"shipper_id":{shipper-v4-legacy-id}} |

  Scenario: Operator Delete Order - Status = Pickup Fail
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Pickup Fail                        |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pickup Fail" on Edit Order V2 page
    And Operator verify order granular status is "Pickup Fail" on Edit Order V2 page
    And Operator delete order on Edit Order V2 page
    And Operator waits for 5 seconds
    Then Operator verifies All Orders Page is displayed
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}    |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
      | data      | {"shipper_id":{shipper-v4-legacy-id}} |

  Scenario: Operator Delete Order with Invoiced Amount
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"return","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"test":123,"what":"is this?","foo":{"bar":"wah"}}},"from":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30A ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"to":{"name":"George Ezra","phone_number":"+65189178","email":"ezra@g.ent","address":{"address1":"999 Toa Payoh North","address2":"","country":"SG","postcode":"318993"}},"parcel_job":{"experimental_allow_redirect_to_dp":false,"experimental_from_international":false,"experimental_to_international":false,"cash_on_delivery":100,"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_service_type":"Scheduled","pickup_service_level":"Standard","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"pickup_address":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30 ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"pickup_address_id":"add03","pickup_instruction":"Please be careful with the v-day flowers.","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"Please be careful with the v-day flowers.","dimensions":{"weight":2.6,"height":2.7,"length":2.8,"width":2.9}},"experimental_customs_declaration":{"customs_description":"this order to test ORDER-516"},"billing":{"invoiced_amount":500.0}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And Operator delete order on Edit Order V2 page
    And Operator waits for 5 seconds
    Then Operator verifies All Orders Page is displayed
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                            |
      | type      | 49                                                            |
      | userId    | 397                                                           |
      | userName  | AUTOMATION EDITED                                             |
      | userEmail | {operator-portal-uid}                                         |
      | data      | {"shipper_id":{shipper-v4-legacy-id},"invoiced_amount":500.0} |
