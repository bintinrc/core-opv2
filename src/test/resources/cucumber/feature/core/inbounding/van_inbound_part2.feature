@OperatorV2 @Core @Inbounding @VanInbound @VanInboundPart2
Feature: Van Inbound

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Publish Update Status Event For Van Inbound and Start Route Delivery Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    Then Operator verify the van inbound process is succeed
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order scan updated
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator go to menu Routing -> Route Logs
    Then Operator verify the route is started after van inbounding using data below:
      | routeDateFrom | {gradle-current-date-yyyy-MM-dd} |
      | routeDateTo   | {gradle-current-date-yyyy-MM-dd} |
      | hubName       | {hub-name}                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER INBOUND SCAN  |
      | routeId | KEY_CREATED_ROUTE_ID |
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER START ROUTE   |
      | routeId | KEY_CREATED_ROUTE_ID |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                        |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Vehicle for Delivery\n\n\nReason: START_ROUTE |
    And DB Operator verifies inbound_scans record with type "4" and correct route_id

  @DeleteOrArchiveRoute
  Scenario: Operator Publish Update Status Event For Van Inbound and Start Route Return Pickup Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator go to menu Routing -> Route Logs
    Then Operator verify the route is started after van inbounding using data below:
      | routeDateFrom | {gradle-current-date-yyyy-MM-dd} |
      | routeDateTo   | {gradle-current-date-yyyy-MM-dd} |
      | hubName       | {hub-name}                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van En-route to Pickup" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER START ROUTE   |
      | routeId | KEY_CREATED_ROUTE_ID |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Van en-route to pickup\n\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: START_ROUTE |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

  Scenario: Operator Van Inbounds And Starts Route with Tagged Order - Delivery
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator searches and selects orders created on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator tags order with:
      | {order-tag-name}   |
      | {order-tag-name-2} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | {order-tag-name}   |
      | {order-tag-name-2} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    Then Operator verify the van inbound process is succeed
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order scan updated
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator go to menu Routing -> Route Logs
    Then Operator verify the route is started after van inbounding using data below:
      | routeDateFrom | {gradle-current-date-yyyy-MM-dd} |
      | routeDateTo   | {gradle-current-date-yyyy-MM-dd} |
      | hubName       | {hub-name}                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER INBOUND SCAN  |
      | routeId | KEY_CREATED_ROUTE_ID |
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER START ROUTE   |
      | routeId | KEY_CREATED_ROUTE_ID |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                        |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Vehicle for Delivery\n\n\nReason: START_ROUTE |
    And DB Operator verifies inbound_scans record with type "4" and correct route_id
    And DB Core - Operator verifies order_tags_search record of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order:
      | tagIds               | {order-tag-id},{order-tag-id-2} |
      | routeId              | {KEY_CREATED_ROUTE_ID}          |
      | driverId             | {KEY_NINJA_DRIVER_ID}           |
      | parcelGranularStatus | On Vehicle for Delivery         |

  Scenario: Operator Van Inbounds And Starts Route with Tagged Order - Return Pickup
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator searches and selects orders created on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator tags order with:
      | {order-tag-name}   |
      | {order-tag-name-2} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | {order-tag-name}   |
      | {order-tag-name-2} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator go to menu Routing -> Route Logs
    Then Operator verify the route is started after van inbounding using data below:
      | routeDateFrom | {gradle-current-date-yyyy-MM-dd} |
      | routeDateTo   | {gradle-current-date-yyyy-MM-dd} |
      | hubName       | {hub-name}                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van En-route to Pickup" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER START ROUTE   |
      | routeId | KEY_CREATED_ROUTE_ID |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Van en-route to pickup\n\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: START_ROUTE |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |
    And DB Core - Operator verifies order_tags_search record of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order:
      | tagIds               | {order-tag-id},{order-tag-id-2} |
      | routeId              | {KEY_CREATED_ROUTE_ID}          |
      | driverId             | {KEY_NINJA_DRIVER_ID}           |
      | parcelGranularStatus | Van en-route to pickup          |

  @DeleteOrArchiveRoute
  Scenario: Publish Reservation Event on Start Route
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator go to menu Routing -> Route Logs
    Then Operator verify the route is started after van inbounding using data below:
      | routeDateFrom | {gradle-current-date-yyyy-MM-dd} |
      | routeDateTo   | {gradle-current-date-yyyy-MM-dd} |
      | hubName       | {hub-name}                       |
    And DB Events - verify pickup_events record:
      | pickupId   | {KEY_CREATED_RESERVATION_ID}        |
      | userId     | 397                                 |
      | type       | 4                                   |
      | pickupType | 1                                   |
      | data       | {"route_id":{KEY_CREATED_ROUTE_ID}} |
