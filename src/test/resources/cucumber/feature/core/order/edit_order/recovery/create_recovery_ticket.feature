@OperatorV2 @Core @EditOrder @Recovery @CreateTicket @EditOrder3
Feature: Create Recovery Ticket

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Create Recovery Ticket For Return Pickup
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
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
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
    And DB Operator verifies route_monitoring_data is hard-deleted
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Create Recovery Ticket For Pending Reschedule Order
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
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
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
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Create Recovery Ticket For Pickup Fail
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
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
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |

  Scenario: Operator Create and Search Recovery Ticket For Hub Inbound Scan
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                     |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: HUB_INBOUND |
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
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Hold\n\nOld Order Status: Transit\nNew Order Status: On Hold\n\nReason: TICKET_CREATION |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Create and Search Recovery Ticket For Route Inbound Scan
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver pickup the created parcel successfully
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans  | 1 |
      | parcelProcessedTotal  | 2 |
      | c2cReturnPickupsScans | 1 |
      | c2cReturnPickupsTotal | 2 |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
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
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name               |
      | TICKET CREATED     |
      | ROUTE INBOUND SCAN |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Hold\n\nOld Order Status: Transit\nNew Order Status: On Hold\n\nReason: TICKET_CREATION |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Create and Search Recovery Ticket For Outbound Scan
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_DESTINATION_HUB_ID}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator waits for 10 seconds
    And API Operator sweep parcel:
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
      | hubId | {KEY_DESTINATION_HUB_ID}        |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name        | PARCEL ROUTING SCAN                     |
      | hubName     | {KEY_CREATED_ORDER.destinationHub}      |
      | description | Scanned at Hub {KEY_DESTINATION_HUB_ID} |
    And Operator verify order event on Edit order page using data below:
      | name        | OUTBOUND SCAN                           |
      | hubName     | {KEY_CREATED_ORDER.destinationHub}      |
      | description | Scanned at Hub {KEY_DESTINATION_HUB_ID} |
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | FOUND - INBOUND    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name           |
      | TICKET CREATED |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Hold\n\nOld Order Status: Transit\nNew Order Status: On Hold\n\nReason: TICKET_CREATION |
    When API Operator get order details
    Then Operator verify Delivery transaction on Edit order page using data below:
      | routeId |  |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | routeId | 0 |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |

    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

    And DB Operator verifies route_monitoring_data is hard-deleted
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |

  Scenario: Operator Create and Search Recovery Ticket For Warehouse Sweep Scan
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator sweep parcel:
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
      | hubId | {hub-id}                        |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    When Operator refresh page
    And Operator verify order event on Edit order page using data below:
      | name        | PARCEL ROUTING SCAN     |
      | hubName     | {hub-name}              |
      | description | Scanned at Hub {hub-id} |
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | FOUND - INBOUND    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name           |
      | TICKET CREATED |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Hold\n\nOld Order Status: Transit\nNew Order Status: On Hold\n\nReason: TICKET_CREATION |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |


  Scenario: Operator Create and Search Recovery Ticket For Driver Pickup Scan
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: En-route to Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: BATCH_POD_UPDATE |
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER PICKUP SCAN   |
      | routeId | KEY_CREATED_ROUTE_ID |
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
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                   |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: En-route to Sorting Hub\nNew Granular Status: On Hold\n\nOld Order Status: Transit\nNew Order Status: On Hold\n\nReason: TICKET_CREATION |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |
