@OperatorV2 @Core @NewFeatures @BatchOrder
Feature: Batch Order

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Rollback Order - Valid Batch Id, Status = Pending Pickup (uid:411fe6b0-f984-4bda-80c2-3f4da00a97f8)
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
      | top                | Rollback Successfully |
      | waitUntilInvisible | true                  |
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

  @DeleteOrArchiveRoute
  Scenario: Rollback Order - Valid Batch Id, Status = Van En-route to Pickup (uid:4802ac7b-e874-49b2-96bb-cf56451f1cae)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator start the route
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH_ID}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                | type   | fromName                                | fromAddress                                                           | toName                                | toAddress                                                           | status  | granularStatus         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[1].toName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressWithCountryString} | Transit | Van en-route to pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDER[2].toName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressWithCountryString} | Transit | Van en-route to pickup |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast displayed:
      | top                | Rollback Successfully |
      | waitUntilInvisible | true                  |
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

  @DeleteOrArchiveRoute
  Scenario: Rollback Order - Valid Batch Id, Status = Pickup Fail (uid:6daf555d-d582-4328-9f68-d04b98e6931b)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator start the route
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
      | top                | Rollback Successfully |
      | waitUntilInvisible | true                  |
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

  Scenario: Rollback Order - Valid Batch Id, Status = Staging (uid:b4cbfdac-28df-4d85-9e16-578c4d3d473c)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | top                | Rollback Successfully |
      | waitUntilInvisible | true                  |
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

  Scenario: Rollback Order - Invalid Batch Id (uid:d52ba19e-b344-48a5-a264-a7101450934e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu New Features -> Batch Order
    And Operator search for "1111" batch on Batch Orders page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                         |
      | bottom | ^.*Error Message: Order batch with batch id 1111 not found!.* |

  Scenario: Rollback Order - Valid Batch Id, Order Not Allowed to be Deleted (uid:57cfd4b5-5631-436e-818b-5a6ff1e21830)
    Given Operator go to menu Shipper Support -> Blocked Dates
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op