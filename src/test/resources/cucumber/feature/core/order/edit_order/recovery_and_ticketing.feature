@OperatorV2 @Core @Order @EditOrder @RecoveryAndTicketing
Feature: Recovery & Ticketing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Create Recovery Ticket For Pending Reschedule Order (uid:3812f660-c9d7-45a8-96ef-2ae379eace0d)
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
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
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_BEFORE"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource                   | CUSTOMER COMPLAINT |
      | investigatingDepartment       | Recovery           |
      | investigatingHub              | {hub-name}         |
      | ticketType                    | PARCEL EXCEPTION   |
      | ticketSubType                 | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And API Operator get order details
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name           |
      | TICKET CREATED |
      | UPDATE STATUS  |
      | RESCHEDULE     |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | DD                                  |
      | status     | Fail                                |
      | routeId    | {KEY_CREATED_ROUTE_ID}              |
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
      | routeId    | null                               |

  @DeleteOrArchiveRoute
  Scenario: Operator Create Recovery Ticket For On Vehicle for Delivery (uid:baf8f8c8-6c0f-4e36-a182-948a8d6f3028)
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
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
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle For Delivery" on Edit Order page
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_BEFORE"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource                   | CUSTOMER COMPLAINT |
      | investigatingDepartment       | Recovery           |
      | investigatingHub              | {hub-name}         |
      | ticketType                    | PARCEL EXCEPTION   |
      | ticketSubType                 | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And API Operator get order details
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name           |
      | TICKET CREATED |
      | UPDATE STATUS  |
      | RESCHEDULE     |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | DD                                  |
      | status     | Fail                                |
      | routeId    | {KEY_CREATED_ROUTE_ID}              |
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
      | routeId    | null                               |

  @DeleteOrArchiveRoute
  Scenario: Operator Create Recovery Ticket For Pickup Fail (uid:4c2a89c6-0345-4775-9d27-23c3b222d615)
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
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | FAIL |
    When Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION_BEFORE"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource                   | CUSTOMER COMPLAINT |
      | investigatingDepartment       | Recovery           |
      | investigatingHub              | {hub-name}         |
      | ticketType                    | PARCEL EXCEPTION   |
      | ticketSubType                 | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And API Operator get order details
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name           |
      | TICKET CREATED |
      | UPDATE STATUS  |
      | RESCHEDULE     |
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP |
      | status | FAIL   |
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP  |
      | status | PENDING |
    When Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | PP                                  |
      | status     | Fail                                |
      | routeId    | {KEY_CREATED_ROUTE_ID}              |
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | PP                                 |
      | status     | Pending                            |
      | routeId    | null                               |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op