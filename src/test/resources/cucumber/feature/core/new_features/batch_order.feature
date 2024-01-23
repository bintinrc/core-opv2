@OperatorV2 @Core @NewFeatures @BatchOrder @test
Feature: Batch Order

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority
  Scenario: Rollback Order - Valid Batch Id, Status = Pending Pickup
    When API Order - Operator v4.1 create new batch
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                            |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                     |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                            |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                     |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH.batchId}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                 | type   | fromName                                 | fromAddress                                                            | toName                                 | toAddress                                                            | status  | granularStatus |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressWithCountryString} | Pending | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortToAddressWithCountryString} | Pending | Pending Pickup |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast "Rollback successfully" displayed
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}    |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[2].id}    |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Rollback Order - Valid Batch Id, Status = Van En-route to Pickup
    When API Order - Operator v4.1 create new batch
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                           |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                    |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                           |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                    |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                              |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                              |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH.batchId}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                 | type   | fromName                                 | fromAddress                                                            | toName                                 | toAddress                                                            | status  | granularStatus         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressWithCountryString} | Transit | Van en-route to pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortToAddressWithCountryString} | Transit | Van en-route to pickup |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast displayed:
      | top | Rollback Successfully |
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}    |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[2].id}    |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Rollback Order - Valid Batch Id, Status = Pickup Fail
    When API Order - Operator v4.1 create new batch
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                           |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                    |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                           |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                    |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                              |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                              |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH.batchId}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                 | type   | fromName                                 | fromAddress                                                            | toName                                 | toAddress                                                            | status      | granularStatus |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressWithCountryString} | Pickup fail | Pickup fail    |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | Return | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortToAddressWithCountryString} | Pickup fail | Pickup fail    |
    When Operator rollback orders on Batch Orders page
    And Operator search for "{KEY_CREATED_BATCH.batchId}" batch on Batch Orders page
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}    |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[2].id}    |
      | type      | 49                                    |
      | userId    | 397                                   |
      | userName  | AUTOMATION EDITED                     |
      | userEmail | {operator-portal-uid}                 |

  @HighPriority
  Scenario: Rollback Order - Valid Batch Id, Status = Staging
    When API Order - Operator v4.1 create new batch
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                                       |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "is_staged":true, "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                                       |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "is_staged":true, "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH.batchId}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                 | type   | fromName                                 | fromAddress                                                            | toName                                 | toAddress                                                            | status  | granularStatus |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressWithCountryString} | Staging | Staging        |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortToAddressWithCountryString} | Staging | Staging        |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast "Rollback successfully" displayed
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |

  @MediumPriority
  Scenario: Rollback Order - Invalid Batch Id
    Given Operator go to menu New Features -> Batch Order
    When Operator search for "1111" batch on Batch Orders page
    Then Operator verifies that error toast "Error Message:" displayed
      | description | Error Message: Order batch with batch id 1111 not found! |

  @MediumPriority
  Scenario: Rollback Order - Valid Batch Id, Order Not Allowed to be Deleted
    When API Order - Operator v4.1 create new batch
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                                       |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "is_staged":true, "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH.batchId}" batch on Batch Orders page
    And Operator rollback orders on Batch Orders page
    Then Operator verifies that error toast "Error Message:" displayed
      | description | Error Message: Can't delete order {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} in Arrived at Sorting Hub state. Order can only be deleted if in the following states : [Staging, Pending Pickup, Van en-route to pickup, Pickup fail] |

  @HighPriority
  Scenario: Rollback Order - Order has Invoice Amount
    When API Order - Operator v4.1 create new batch
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","requested_tracking_number":null,"reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"test":123,"what":"is this?","foo":{"bar":"wah"}}},"from":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30A ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"to":{"name":"George Ezra","phone_number":"+65189178","email":"ezra@g.ent","address":{"address1":"999 Toa Payoh North","address2":"","country":"SG","postcode":"318993"}},"parcel_job":{"experimental_allow_redirect_to_dp":false,"experimental_from_international":false,"experimental_to_international":false,"cash_on_delivery":100,"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_service_type":"Scheduled","pickup_service_level":"Standard","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"pickup_address":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30 ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"pickup_address_id":"add03","pickup_instruction":"Please be careful with the v-day flowers.","delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"Please be careful with the v-day flowers.","dimensions":{"weight":2.6,"height":2.7,"length":2.8,"width":2.9}},"experimental_customs_declaration":{"customs_description":"this order to test ORDER-516"},"billing":{"invoiced_amount":500.0}} |
    When API Order - Shipper create order for the created batch using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | batchId             | KEY_CREATED_BATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | globalShipperId     | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","requested_tracking_number":null,"reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"test":123,"what":"is this?","foo":{"bar":"wah"}}},"from":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30A ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"to":{"name":"George Ezra","phone_number":"+65189178","email":"ezra@g.ent","address":{"address1":"999 Toa Payoh North","address2":"","country":"SG","postcode":"318993"}},"parcel_job":{"experimental_allow_redirect_to_dp":false,"experimental_from_international":false,"experimental_to_international":false,"cash_on_delivery":100,"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_service_type":"Scheduled","pickup_service_level":"Standard","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"pickup_address":{"name":"binti v4.1","phone_number":"+65189189","email":"binti@test.co","address":{"address1":"30 ST. THOMAS WALK","address2":"","country":"SG","postcode":"238111","latitude":1.29756148374631,"longitude":103.835816578705}},"pickup_address_id":"add03","pickup_instruction":"Please be careful with the v-day flowers.","delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"Please be careful with the v-day flowers.","dimensions":{"weight":2.6,"height":2.7,"length":2.8,"width":2.9}},"experimental_customs_declaration":{"customs_description":"this order to test ORDER-516"},"billing":{"invoiced_amount":500.0}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator go to menu New Features -> Batch Order
    And Operator search for "{KEY_CREATED_BATCH.batchId}" batch on Batch Orders page
    Then Operator verifies orders info on Batch Orders page:
      | trackingId                                 | type   | fromName                                 | fromAddress                                                            | toName                                 | toAddress                                                            | status  | granularStatus |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressWithCountryString} | Pending | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | Normal | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortFromAddressWithCountryString} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortToAddressWithCountryString} | Pending | Pending Pickup |
    When Operator rollback orders on Batch Orders page
    Then Operator verifies that success toast "Rollback successfully" displayed
    And DB Core - verify orders records are hard-deleted in orders table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in transactions table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders from "KEY_LIST_OF_CREATED_ORDERS" records are hard-deleted in waypoints table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_details table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders records are hard-deleted in order_delivery_verifications table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Order Create - verify orders records are hard-deleted in reserve_tracking_ids table:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                            |
      | type      | 49                                                            |
      | userId    | 397                                                           |
      | userName  | AUTOMATION EDITED                                             |
      | userEmail | {operator-portal-uid}                                         |
      | data      | {"invoiced_amount":500.0} |
    And DB Events - verify order_events record:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[2].id}                            |
      | type      | 49                                                            |
      | userId    | 397                                                           |
      | userName  | AUTOMATION EDITED                                             |
      | userEmail | {operator-portal-uid}                                         |
      | data      | {"invoiced_amount":500.0} |
