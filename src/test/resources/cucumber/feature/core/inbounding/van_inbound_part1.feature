@OperatorV2 @Core @Inbounding @VanInbound @VanInboundPart1
Feature: Van Inbound

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @happy-path
  Scenario: Operator Van Inbounds And Starts Route with Valid Tracking ID
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
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
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                        |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Vehicle for Delivery\n\n\nReason: START_ROUTE |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id}                           |
      | type    | 4                                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2
  Scenario: Operator Van Inbounds with Invalid Tracking ID
    Given Operator go to menu Utilities -> QRCode Printing
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Van Inbound Page then click enter
    And Operator fill the tracking ID "INVALID_TRACKING_ID" on Van Inbound Page then click enter
    Then Operator verify the tracking ID "INVALID_TRACKING_ID" that has been input on Van Inbound Page is invalid

  @ArchiveRouteCommonV2
  Scenario: Operator Van Inbounds with Empty Tracking ID
    Given Operator go to menu Utilities -> QRCode Printing
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Van Inbound Page then click enter
    And Operator fill the empty tracking ID on Van Inbound Page
    Then Operator verify the tracking ID that has been input on Van Inbound Page is empty

  @ArchiveRouteCommonV2
  Scenario: Operator Van Inbounds Multiple Orders With Different Order Status And Checks Scanned Parcels
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Vehicle for Delivery            |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | Arrived at Sorting Hub             |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                 |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}                                 |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Van Inbound Page then click enter
    And Operator scan "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking ID on Van Inbound Page
    Then Operator verifies "1/2" scanned parcels displayed on Van Inbound Page
    When Operator scan "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" tracking ID on Van Inbound Page
    Then Operator verifies "2/2" scanned parcels displayed on Van Inbound Page
    When Operator click Scanned Parcels area on Van Inbound Page
    Then Operator verifies Scanned Parcels dialog contains orders info:
      | trackingId                            | name                                   | contact                                   | address                                              | granularStatus          | status  |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} | {KEY_LIST_OF_CREATED_ORDERS[1].toContact} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | On Vehicle for Delivery | Transit |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ORDERS[2].toName} | {KEY_LIST_OF_CREATED_ORDERS[2].toContact} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | Arrived at Sorting Hub  | Transit |

  @ArchiveRouteCommonV2
  Scenario: Operator Van Inbounds And Starts Route Multiple Success, Failed and Pending Pickups In A Route
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                 |
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | En-route to Sorting Hub            |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | Pickup Fail                        |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                 |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2}                                  |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[3]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[3}                                  |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Van Inbound Page then click enter
    And Operator scan "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking ID on Van Inbound Page
    And Operator scan "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" tracking ID on Van Inbound Page
    And Operator scan "{KEY_LIST_OF_CREATED_TRACKING_IDS[3]}" tracking ID on Van Inbound Page
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order V2 page
    And Operator verify order events are not presented on Edit Order V2 page:
      | DRIVER START ROUTE  |
      | DRIVER INBOUND SCAN |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order status is "Pickup fail" on Edit Order V2 page
    And Operator verify order granular status is "Pickup Fail" on Edit Order V2 page
    And Operator verify order events are not presented on Edit Order V2 page:
      | DRIVER START ROUTE  |
      | DRIVER INBOUND SCAN |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    And Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Van en-route to pickup" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER START ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Van en-route to pickup\n\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: START_ROUTE |
    And Operator verify order events are not presented on Edit Order V2 page:
      | DRIVER INBOUND SCAN |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | status | IN_PROGRESS                        |

  @ArchiveRouteCommonV2
  Scenario: Operator Van Inbounds And Starts Route Multiple Success, Failed and Pending Deliveries In A Route
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                 |
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Completed                          |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | Pending Reschedule                 |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | granularStatus | Arrived At Sorting Hub             |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                 |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2}                                  |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[3]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[3}                                  |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Van Inbound Page then click enter
    And Operator scan "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking ID on Van Inbound Page
    And Operator scan "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" tracking ID on Van Inbound Page
    And Operator scan "{KEY_LIST_OF_CREATED_TRACKING_IDS[3]}" tracking ID on Van Inbound Page
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify order events are not presented on Edit Order V2 page:
      | DRIVER START ROUTE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER INBOUND SCAN                |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "Delivery Fail" on Edit Order V2 page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order V2 page
    And Operator verify order events are not presented on Edit Order V2 page:
      | DRIVER START ROUTE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER INBOUND SCAN                |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    And Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER START ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER INBOUND SCAN                |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                        |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Vehicle for Delivery\n\n\nReason: START_ROUTE |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | status | IN_PROGRESS                        |
