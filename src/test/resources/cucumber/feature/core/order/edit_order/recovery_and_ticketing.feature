@OperatorV2 @Core @EditOrder @RecoveryAndTicketing @EditOrder3
Feature: Recovery & Ticketing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Create Recovery Ticket For Return Pickup (uid:a0dc605d-7a22-43db-929c-d38311720b52)
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
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
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
    When Operator refresh page
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
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Operator get order details
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted

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
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | DD                                  |
      | status     | Fail                                |
      | routeId    | {KEY_CREATED_ROUTE_ID}              |
    Then DB Operator verifies transactions record:
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
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | DD                                  |
      | status     | Fail                                |
      | routeId    | {KEY_CREATED_ROUTE_ID}              |
    Then DB Operator verifies transactions record:
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
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | PP                                  |
      | status     | Fail                                |
      | routeId    | {KEY_CREATED_ROUTE_ID}              |
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | PP                                 |
      | status     | Pending                            |
      | routeId    | null                               |

  Scenario: Operator Resolve Recovery Ticket with Outcome = Force Success
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT               |
      | investigatingDepartment | Recovery                         |
      | investigatingHub        | {hub-name}                       |
      | ticketType              | DAMAGED                          |
      | ticketSubType           | IMPROPER PACKAGING               |
      | parcelLocation          | DAMAGED RACK                     |
      | liability               | Shipper                          |
      | damageDescription       | GENERATED                        |
      | orderOutcomeDamaged     | NV NOT LIABLE - PARCEL DELIVERED |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED                         |
      | outcome | NV NOT LIABLE - PARCEL DELIVERED |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP  |
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | SUCCESS  |
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | FORCED SUCCESS  |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Outcome = Order Cancel
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT              |
      | investigatingDepartment | Recovery                        |
      | investigatingHub        | {hub-name}                      |
      | ticketType              | DAMAGED                         |
      | ticketSubType           | IMPROPER PACKAGING              |
      | parcelLocation          | DAMAGED RACK                    |
      | liability               | Shipper                         |
      | damageDescription       | GENERATED                       |
      | orderOutcomeDamaged     | NV NOT LIABLE - PARCEL DISPOSED |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED                        |
      | outcome | NV NOT LIABLE - PARCEL DISPOSED |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP    |
      | status | CANCELLED |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY  |
      | status | CANCELLED |
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | CANCEL          |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Outcome = RTS
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT            |
      | investigatingDepartment | Recovery                      |
      | investigatingHub        | {hub-name}                    |
      | ticketType              | DAMAGED                       |
      | ticketSubType           | IMPROPER PACKAGING            |
      | parcelLocation          | DAMAGED RACK                  |
      | liability               | Shipper                       |
      | damageDescription       | GENERATED                     |
      | orderOutcomeDamaged     | NV NOT LIABLE - RETURN PARCEL |
      | rtsReason               | Nobody at address             |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED                      |
      | outcome | NV NOT LIABLE - RETURN PARCEL |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                    |
      | address | {KEY_CREATED_ORDER.buildFromAddressString} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Operator get order details
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id       | {KEY_TRANSACTION.waypointId}     |
      | status   | Pending                          |
      | routeId  | null                             |
      | seqNo    | null                             |
      | address1 | {KEY_CREATED_ORDER.fromAddress1} |
      | address2 | {KEY_CREATED_ORDER.fromAddress2} |
      | postcode | {KEY_CREATED_ORDER.fromPostcode} |
      | city     | {KEY_CREATED_ORDER.fromCity}     |
      | country  | {KEY_CREATED_ORDER.fromCountry}  |
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | RTS             |
      | UPDATE ADDRESS  |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Outcome = Default No Action
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT    |
      | investigatingDepartment | Recovery              |
      | investigatingHub        | {hub-name}            |
      | ticketType              | DAMAGED               |
      | ticketSubType           | IMPROPER PACKAGING    |
      | parcelLocation          | DAMAGED RACK          |
      | liability               | Shipper               |
      | damageDescription       | GENERATED             |
      | orderOutcomeDamaged     | NV TO REPACK AND SHIP |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED              |
      | outcome | NV TO REPACK AND SHIP |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Completed Order & Outcome = RTS
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | PARCEL EXCEPTION   |
      | ticketSubType           | COMPLETED ORDER    |
      | liability               | Shipper            |
      | orderOutcome            | RTS                |
      | rtsReason               | Nobody at address  |
    When Operator refresh page
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED |
      | outcome | RTS      |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And Operator verify order events on Edit order page using data below:
      | name             |
      | UPDATE STATUS    |
      | RESCHEDULE       |
      | RTS              |
      | REVERT COMPLETED |
      | UPDATE ADDRESS   |
      | TICKET UPDATED   |
      | TICKET RESOLVED  |

  Scenario: Operator Resolve Recovery Ticket with Completed Order & Outcome = Resend
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | PARCEL EXCEPTION   |
      | ticketSubType           | COMPLETED ORDER    |
      | liability               | Shipper            |
      | orderOutcome            | RESEND             |
    When Operator refresh page
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED |
      | outcome | RESEND   |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And Operator verify order events on Edit order page using data below:
      | name             |
      | UPDATE STATUS    |
      | RESCHEDULE       |
      | REVERT COMPLETED |
      | TICKET UPDATED   |
      | TICKET RESOLVED  |

  Scenario: Operator Resolve Recovery Ticket with Cancelled Order & Outcome = RESUME DELIVERY
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator cancel created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | PARCEL EXCEPTION   |
      | ticketSubType           | CANCELLED ORDER    |
      | liability               | Shipper            |
      | orderOutcome            | RESUME DELIVERY    |
    When Operator refresh page
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED        |
      | outcome | RESUME DELIVERY |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And Operator verify order events on Edit order page using data below:
      | name             |
      | UPDATE STATUS    |
      | RESCHEDULE       |
      | REVERT COMPLETED |
      | TICKET UPDATED   |
      | TICKET RESOLVED  |

  Scenario: Operator Resolve Recovery Ticket with Cancelled Order & Outcome = RTS
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator cancel created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | PARCEL EXCEPTION   |
      | ticketSubType           | CANCELLED ORDER    |
      | liability               | Shipper            |
      | orderOutcome            | RTS                |
      | rtsReason               | Nobody at address  |
    When Operator refresh page
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED |
      | outcome | RTS      |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And Operator verify order events on Edit order page using data below:
      | name             |
      | UPDATE STATUS    |
      | REVERT COMPLETED |
      | RESCHEDULE       |
      | RTS              |
      | TICKET UPDATED   |
      | TICKET RESOLVED  |

  Scenario: Operator Resolve Recovery Ticket with No Order & Outcome = RTS
    Given New Stamp ID with "{shipper-v4-prefix}" prefix was generated
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_STAMP_ID}     |
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | SHIPPER ISSUE      |
      | ticketSubType           | NO ORDER           |
      | orderOutcome            | RTS                |
      | issueDescription        | GENERATED          |
      | rtsReason               | Nobody at address  |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "requested_tracking_number":"{KEY_TRACKING_NUMBER}","service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED |
      | outcome | RTS      |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                    |
      | address | {KEY_CREATED_ORDER.buildFromAddressString} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Operator get order details
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id       | {KEY_TRANSACTION.waypointId}     |
      | status   | Pending                          |
      | routeId  | null                             |
      | seqNo    | null                             |
      | address1 | {KEY_CREATED_ORDER.fromAddress1} |
      | address2 | {KEY_CREATED_ORDER.fromAddress2} |
      | postcode | {KEY_CREATED_ORDER.fromPostcode} |
      | city     | {KEY_CREATED_ORDER.fromCity}     |
      | country  | {KEY_CREATED_ORDER.fromCountry}  |
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | RTS             |
      | UPDATE ADDRESS  |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with No Order & Outcome = XMAS CAGE
    Given New Stamp ID with "{shipper-v4-prefix}" prefix was generated
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_STAMP_ID}     |
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | SHIPPER ISSUE      |
      | ticketSubType           | NO ORDER           |
      | orderOutcome            | XMAS CAGE          |
      | issueDescription        | GENERATED          |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "requested_tracking_number":"{KEY_TRACKING_NUMBER}","service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED  |
      | outcome | XMAS CAGE |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP    |
      | status | CANCELLED |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY  |
      | status | CANCELLED |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | CANCEL          |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with No Order & Outcome = ORDERS CREATED
    Given New Stamp ID with "{shipper-v4-prefix}" prefix was generated
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_STAMP_ID}     |
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | SHIPPER ISSUE      |
      | ticketSubType           | NO ORDER           |
      | orderOutcome            | ORDERS CREATED     |
      | issueDescription        | GENERATED          |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "requested_tracking_number":"{KEY_TRACKING_NUMBER}","service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED       |
      | outcome | ORDERS CREATED |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Completed Order & Outcome = RELABELLED TO SEND
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | PARCEL EXCEPTION   |
      | ticketSubType           | COMPLETED ORDER    |
      | liability               | Shipper            |
      | orderOutcome            | RELABELLED TO SEND |
    When Operator refresh page
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED           |
      | outcome | RELABELLED TO SEND |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | SUCCESS  |
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Completed Order & Outcome = XMAS CAGE
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | PARCEL EXCEPTION   |
      | ticketSubType           | COMPLETED ORDER    |
      | liability               | Shipper            |
      | orderOutcome            | XMAS CAGE          |
    When Operator refresh page
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED  |
      | outcome | XMAS CAGE |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | SUCCESS  |
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Cancelled Order & Outcome = XMAS CAGE
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator cancel created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | PARCEL EXCEPTION   |
      | ticketSubType           | CANCELLED ORDER    |
      | liability               | Shipper            |
      | orderOutcome            | XMAS CAGE          |
    When Operator refresh page
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED  |
      | outcome | XMAS CAGE |
    Then Operator verifies that success toast displayed:
      | top | ^Ticket ID : .* updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    And Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY  |
      | status | CANCELLED |
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP    |
      | status | CANCELLED |
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op