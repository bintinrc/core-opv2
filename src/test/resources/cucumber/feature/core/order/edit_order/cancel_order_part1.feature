@OperatorV2 @Core @EditOrder @CancelOrder @CancelOrderPart1 @EditOrder1 @RoutingModules
Feature: Cancel Order

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Cancel Order - On Hold
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator create new recovery ticket on Edit Order page:
      | entrySource                   | CUSTOMER COMPLAINT |
      | investigatingDepartment       | Recovery           |
      | investigatingHub              | {hub-name}         |
      | ticketType                    | PARCEL EXCEPTION   |
      | ticketSubType                 | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page
    When API Operator cancel created order and get error:
      | statusCode | 500               |
      | message    | Order is On Hold! |

  @happy-path
  Scenario: Cancel Order - Pending Pickup
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator get order details
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify order summary on Edit order page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Pickup transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Delivery transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit order page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                     |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Cancelled\n\nOld Order Status: Pending\nNew Order Status: Cancelled\n\nReason: CANCEL |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Jaro Scores of the created order after cancel

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Cancel Order - Van En-route to Pickup
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van En-route to Pickup" on Edit Order page
    When Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator get order details
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify order summary on Edit order page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    When API Operator get order details
    And API Operator verify Pickup transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And DB Operator verifies transaction route id is null
    And API Operator verify Delivery transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status  | CANCELLED |
      | routeId |           |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit order page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                             |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Van en-route to pickup\nNew Granular Status: Cancelled\n\nOld Order Status: Transit\nNew Order Status: Cancelled\n\nReason: CANCEL |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

    And DB Operator verifies route_monitoring_data is hard-deleted
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Jaro Scores of the created order after cancel

  @DeleteOrArchiveRoute
  Scenario: Cancel Order - Pickup Fail
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
    And API Driver failed the C2C/Return order pickup using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pickup Fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page
    When Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator get order details
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify order summary on Edit order page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Pickup transaction of the created order using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And API Operator verify Delivery transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit order page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                      |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pickup fail\nNew Granular Status: Cancelled\n\nOld Order Status: Pickup fail\nNew Order Status: Cancelled\n\nReason: CANCEL |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And Operator save the last DELIVERY transaction of the created order as "KEY_TRANSACTION_AFTER"
    And DB Operator verify Jaro Scores:
      | waypointId                         | archived | status  |
      | {KEY_TRANSACTION_AFTER.waypointId} | 1        | Pending |

  Scenario: Cancel Order - Staging
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Staging" on Edit Order page
    And Operator verify order granular status is "Staging" on Edit Order page
    And Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    When API Operator get order details
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify order summary on Edit order page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Pickup transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Delivery transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit order page using data below:
      | name | CANCEL |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                              |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Staging\nNew Granular Status: Cancelled\n\nOld Order Status: Staging\nNew Order Status: Cancelled\n\nReason: CANCEL |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Jaro Scores of the created order after cancel

  @DeleteOrArchiveRoute
  Scenario: Cancel Order - En-route to Sorting Hub
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 5           |
      | failureReasonIndexMode | FIRST       |
    And API Operator delete or archive created route
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When API Operator cancel created order and get error:
      | statusCode | 500                               |
      | message    | Order is En-route to Sorting Hub! |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute
  Scenario: Cancel Order - Arrived at Sorting Hub
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator cancel created order and get error:
      | statusCode | 500                              |
      | message    | Order is Arrived at Sorting Hub! |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute
  Scenario: Cancel Order - On Vehicle for Delivery
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When API Operator cancel created order and get error:
      | statusCode | 500                               |
      | message    | Order is On Vehicle for Delivery! |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page
