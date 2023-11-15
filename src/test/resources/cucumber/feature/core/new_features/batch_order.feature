@OperatorV2 @Core @NewFeatures @BatchOrder
Feature: Batch Order

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority
  Scenario: Rollback Order - Valid Batch Id, Status = Pending Pickup
    Given API Operator creates a batch
    And API Shipper create multiple V4 orders under batch using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                         |
      | batchId             | {KEY_CREATED_BATCH_ID}                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperId           | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH_ID}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                | type   | fromName                                | fromAddress                                                           | toName                                | toAddress                                                           | status  | granularStatus |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[1].toName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressWithCountryString} | Pending | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[2].toName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressWithCountryString} | Pending | Pending Pickup |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast displayed:
      | top | Rollback Successfully |
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And DB Operator verify the order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDER_ID[1]}     |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
      | data      | {"shipper_id":{shipper-v4-legacy-id}} |

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Rollback Order - Valid Batch Id, Status = Van En-route to Pickup
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates a batch
    And API Shipper create multiple V4 orders under batch using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                               |
      | batchId             | {KEY_CREATED_BATCH_ID}                                                                                                                                                                                                                                                                                                          |
      | shipperId           | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH_ID}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                | type   | fromName                                | fromAddress                                                           | toName                                | toAddress                                                           | status  | granularStatus         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[1].toName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressWithCountryString} | Transit | Van en-route to pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[2].toName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressWithCountryString} | Transit | Van en-route to pickup |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast displayed:
      | top | Rollback Successfully |
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And DB Operator verify the order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDER_ID[1]}     |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
      | data      | {"shipper_id":{shipper-v4-legacy-id}} |

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Rollback Order - Valid Batch Id, Status = Pickup Fail
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates a batch
    And API Shipper create multiple V4 orders under batch using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                               |
      | batchId             | {KEY_CREATED_BATCH_ID}                                                                                                                                                                                                                                                                                                          |
      | shipperId           | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Driver failed multiple C2C/Return orders pickup
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH_ID}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                | type   | fromName                                | fromAddress                                                           | toName                                | toAddress                                                           | status      | granularStatus |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[1].toName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressWithCountryString} | Pickup fail | Pickup fail    |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[2].toName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressWithCountryString} | Pickup fail | Pickup fail    |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast displayed:
      | top | Rollback Successfully |
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And DB Operator verify the order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDER_ID[1]}     |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
      | data      | {"shipper_id":{shipper-v4-legacy-id}} |

  @HighPriority
  Scenario: Rollback Order - Valid Batch Id, Status = Staging
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates a batch
    And API Shipper create multiple V4 orders under batch using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                            |
      | batchId             | {KEY_CREATED_BATCH_ID}                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperId           | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | {"is_staged" : true, "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH_ID}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                | type   | fromName                                | fromAddress                                                           | toName                                | toAddress                                                           | status  | granularStatus |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[1].toName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressWithCountryString} | Staging | Staging        |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[2].toName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressWithCountryString} | Staging | Staging        |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast displayed:
      | top | Rollback Successfully |
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |

  @MediumPriority
  Scenario: Rollback Order - Invalid Batch Id
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu New Features -> Batch Order
    And Operator search for "1111" batch on Batch Orders page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                         |
      | bottom | ^.*Error Message: Order batch with batch id 1111 not found!.* |

  @MediumPriority
  Scenario: Rollback Order - Valid Batch Id, Order Not Allowed to be Deleted
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates a batch
    And API Shipper create V4 order under batch using data below:
      | batchId             | {KEY_CREATED_BATCH_ID}                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperId           | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH_ID}" batch on Batch Orders page
    And Operator rollback orders on Batch Orders page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                                                                                                                                                      |
      | bottom | ^.*Error Message: Can't delete order {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} in Arrived at Sorting Hub state. Order can only be deleted if in the following states : \[Staging, Pending Pickup, Van en-route to pickup, Pickup fail\].* |

  @HighPriority
  Scenario: Rollback Order - Order has Invoice Amount
    Given API Operator creates a batch
    And API Shipper create multiple V4 orders under batch using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | batchId             | {KEY_CREATED_BATCH_ID}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperId           | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","requested_tracking_number":null,"reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"test":123,"what":"is this?","foo":{"bar":"wah"}}},"from":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30A ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"to":{"name":"George Ezra","phone_number":"+65189178","email":"ezra@g.ent","address":{"address1":"999 Toa Payoh North","address2":"","country":"SG","postcode":"318993"}},"parcel_job":{"experimental_allow_redirect_to_dp":false,"experimental_from_international":false,"experimental_to_international":false,"cash_on_delivery":100,"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_service_type":"Scheduled","pickup_service_level":"Standard","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"pickup_address":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30 ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"pickup_address_id":"add03","pickup_instruction":"Please be careful with the v-day flowers.","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"Please be careful with the v-day flowers.","dimensions":{"weight":2.6,"height":2.7,"length":2.8,"width":2.9}},"experimental_customs_declaration":{"customs_description":"this order to test ORDER-516"},"billing":{"invoiced_amount":500.0}} |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH_ID}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                | type   | fromName                                | fromAddress                                                           | toName                                | toAddress                                                           | status  | granularStatus |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[1].toName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressWithCountryString} | Pending | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[2].toName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressWithCountryString} | Pending | Pending Pickup |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast displayed:
      | top | Rollback Successfully |
    And DB Operator verifies orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And DB Operator verify the order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDER_ID[1]}                             |
      | type      | 49                                                            |
      | userId    | 397                                                           |
      | userName  | AUTOMATION EDITED                                             |
      | userEmail | {operator-portal-uid}                                         |
      | data      | {"shipper_id":{shipper-v4-legacy-id},"invoiced_amount":500.0} |
    And DB Operator verify the order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDER_ID[2]}                             |
      | type      | 49                                                            |
      | userId    | 397                                                           |
      | userName  | AUTOMATION EDITED                                             |
      | userEmail | {operator-portal-uid}                                         |
      | data      | {"shipper_id":{shipper-v4-legacy-id},"invoiced_amount":500.0} |
