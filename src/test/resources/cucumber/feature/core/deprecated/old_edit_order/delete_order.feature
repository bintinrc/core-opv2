#@OperatorV2 @Core @EditOrder @DeleteOrder @EditOrder4
Feature: Delete Order

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path
  Scenario: Operator Delete Order - Status = Pending Pickup (uid:6364a910-2590-4a04-adf1-368a9b789b3e)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And DB Operator verify the order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDER_ID[1]}     |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
      | data      | {"shipper_id":{shipper-v4-legacy-id}} |

  @DeleteOrArchiveRoute
  Scenario: Operator Delete Order - Status = Van en-route to Pickup (uid:dcb07b88-ecda-4b51-85c1-381b3ff898e9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van en-route to Pickup" on Edit Order page
    When Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And DB Operator verify the order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDER_ID[1]}     |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
      | data      | {"shipper_id":{shipper-v4-legacy-id}} |

  Scenario: Operator Delete Order - Status = Staging (uid:9b41fbd7-7079-49d9-81c6-81505e5ffd2c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Staging" on Edit Order page
    And Operator verify order granular status is "Staging" on Edit Order page
    And Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Delete Order - Status = Pickup Fail (uid:1ea40765-c2f6-4d5e-9847-6d17a7921eab)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pickup Fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page
    And Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And DB Operator verify the order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDER_ID[1]}     |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
      | data      | {"shipper_id":{shipper-v4-legacy-id}} |

  @DeleteOrArchiveRoute
  Scenario: Operator Delete Order with Invoiced Amount
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type":"return","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"test":123,"what":"is this?","foo":{"bar":"wah"}}},"from":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30A ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"to":{"name":"George Ezra","phone_number":"+65189178","email":"ezra@g.ent","address":{"address1":"999 Toa Payoh North","address2":"","country":"SG","postcode":"318993"}},"parcel_job":{"experimental_allow_redirect_to_dp":false,"experimental_from_international":false,"experimental_to_international":false,"cash_on_delivery":100,"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_service_type":"Scheduled","pickup_service_level":"Standard","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"pickup_address":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30 ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"pickup_address_id":"add03","pickup_instruction":"Please be careful with the v-day flowers.","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"Please be careful with the v-day flowers.","dimensions":{"weight":2.6,"height":2.7,"length":2.8,"width":2.9}},"experimental_customs_declaration":{"customs_description":"this order to test ORDER-516"},"billing":{"invoiced_amount":500.0}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And DB Operator verify the order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDER_ID[1]}                             |
      | type      | 49                                                            |
      | userId    | 397                                                           |
      | userName  | AUTOMATION EDITED                                             |
      | userEmail | {operator-portal-uid}                                         |
      | data      | {"shipper_id":{shipper-v4-legacy-id},"invoiced_amount":500.0} |
