@OperatorV2 @Core @Inbounding @VanInbound @VanInboundPart2
Feature: Van Inbound

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @HighPriority @update-status
  Scenario: Operator Publish Update Status Event For Van Inbound and Start Route Return Pickup Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                 |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Van Inbound Page then click enter
    And Operator fill the tracking ID "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" on Van Inbound Page then click enter
    And Operator click on start route for tid "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" after van inbounding
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    Then Operator verify routes details on Route Logs page using data below:
      | id                                 | status      |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | IN_PROGRESS |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Van En-route to Pickup" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER START ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Van en-route to pickup\n\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: START_ROUTE |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id} |
      | txnType        | PICKUP                                             |
      | txnStatus      | PENDING                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | Van en-route to pickup                             |
    And DB Routing Search - verify transactions record:
      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
      | txnType        | DELIVERY                                           |
      | txnStatus      | PENDING                                            |
      | dnrId          | 0                                                  |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
      | granularStatus | Van en-route to pickup                             |

  @HighPriority
  Scenario: Operator Van Inbounds And Starts Route with Tagged Order - Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-id}                     |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-id-2}                   |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify the tags shown on Edit Order V2 page
      | {order-tag-name}   |
      | {order-tag-name-2} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                 |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Van Inbound Page then click enter
    And Operator fill the tracking ID "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" on Van Inbound Page then click enter
    Then Operator verify the van inbound process is succeed
    And Operator click on start route for tid "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" after van inbounding
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    Then Operator verify routes details on Route Logs page using data below:
      | id                                 | status      |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | IN_PROGRESS |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER INBOUND SCAN                |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER START ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id}                           |
      | type    | 4                                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - Operator verifies order_tags_search record of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order:
      | tagIds               | {order-tag-id},{order-tag-id-2}    |
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | driverId             | {ninja-driver-id}                  |
      | parcelGranularStatus | On Vehicle for Delivery            |

  @HighPriority
  Scenario: Operator Van Inbounds And Starts Route with Tagged Order - Return Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-id}                     |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-id-2}                   |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify the tags shown on Edit Order V2 page
      | {order-tag-name}   |
      | {order-tag-name-2} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Van Inbound Page then click enter
    And Operator fill the tracking ID "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" on Van Inbound Page then click enter
    And Operator click on start route for tid "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" after van inbounding
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    Then Operator verify routes details on Route Logs page using data below:
      | id                                 | status      |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | IN_PROGRESS |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Van En-route to Pickup" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER START ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Van en-route to pickup\n\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: START_ROUTE |
    And DB Core - Operator verifies order_tags_search record of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order:
      | tagIds               | {order-tag-id},{order-tag-id-2}    |
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | driverId             | {ninja-driver-id}                  |
      | parcelGranularStatus | Van en-route to pickup             |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Publish Reservation Event on Start Route
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Van Inbound Page then click enter
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    Then Operator verify routes details on Route Logs page using data below:
      | id                                 | status      |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | IN_PROGRESS |
    And DB Events - verify pickup_events record:
      | pickupId   | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}        |
      | userId     | 397                                             |
      | type       | 4                                               |
      | pickupType | 1                                               |
      | data       | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}} |
