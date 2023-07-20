@OperatorV2 @Core @EditOrder @Recovery @ResolveTicket @ResolveTicketPart2 @EditOrder3
Feature: Resolve Recovery Ticket

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

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

  Scenario: Resolve MISSING PETS Ticket upon Global Inbound
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Operator get order details
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: On Hold\nNew Order Status: Transit\n\nReason: TICKET_RESOLUTION |
    And Operator verify order events on Edit order page using data below:
      | name             |
      | HUB INBOUND SCAN |
      | TICKET RESOLVED  |

  Scenario: Resolve MISSING PETS Ticket upon Parcel Sweep
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
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
      | tags          | name          | description                                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Hold\n\nOld Order Status: Transit\nNew Order Status: On Hold\n\nReason: TICKET_CREATION |
    When API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    And Operator wait until order granular status changes to "Arrived at Sorting Hub"
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Operator get order details
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: On Hold\nNew Order Status: Transit\n\nReason: TICKET_RESOLUTION |
    And Operator verify order events on Edit order page using data below:
      | name                |
      | PARCEL ROUTING SCAN |
      | TICKET RESOLVED     |

  Scenario: Resolve MISSING PETS Ticket upon Route Inbound
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail delivery waypoint from Route Manifest page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
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
    And Operator verify order events with description on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                                                                   |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Fail New Delivery Status: Pending Old Granular Status: Pending Reschedule New Granular Status: On Hold Old Order Status: Delivery fail New Order Status: On Hold Reason: TICKET_CREATION |
    And Operator verify order events on Edit order page using data below:
      | name       |
      | RESCHEDULE |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans       | 1 |
      | parcelProcessedTotal       | 1 |
      | failedDeliveriesValidScans | 1 |
      | failedDeliveriesValidTotal | 1 |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verifies ticket status is "RESOLVED" on Edit Order page
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Operator get order details
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator verify order events with description on Edit order page using data below:
      | tags          | name          | description                                                                                                                                            |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold New Granular Status: Arrived at Sorting Hub Old Order Status: On Hold New Order Status: Transit Reason: TICKET_RESOLUTION |
    And Operator verify order events on Edit order page using data below:
      | name            |
#  need to enable once issue is fixed
#      | ROUTE INBOUND  SCAN |
      | TICKET RESOLVED |

  Scenario: Operator Resume Pickup For On Hold Order - Ticket Type = Parcel Exception, Inaccurate Address
    When Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | PARCEL EXCEPTION                      |
      | subTicketType      | INACCURATE ADDRESS                    |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | orderOutcomeName   | ORDER OUTCOME (INACCURATE ADDRESS)    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED      |
      | outcome | RESUME PICKUP |
    And Operator refresh page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator get "Pickup" transaction with status "Fail"
    Then DB Operator verifies waypoint status is "FAIL"
    When Operator get "Pickup" transaction with status "Pending"
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And Operator verify order events on Edit order page using data below:
      | name            |
      | RESUME PICKUP   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |
    And Operator verify order events with description on Edit order page using data below:
      | tags          | name          | description                                                                                                                                            |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold New Granular Status: Arrived at Sorting Hub Old Order Status: On Hold New Order Status: Transit Reason: TICKET_RESOLUTION |
    And Operator verify order events with description on Edit order page using data below:
      | tags          | name          | description                                                                                                                                               |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub New Granular Status: Pending Pickup Old Order Status: Transit New Order Status: Pending Reason: RESUME_PICKUP |

  Scenario: Operator Resume Pickup For On Hold Order - Ticket Type = Shipper Issue, Poor Labelling
    When Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | SHIPPER ISSUE                         |
      | subTicketType      | POOR LABELLING                        |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | orderOutcomeName   | ORDER OUTCOME (POOR LABELLING)        |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED      |
      | outcome | RESUME PICKUP |
    And Operator refresh page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator get "Pickup" transaction with status "Fail"
    Then DB Operator verifies waypoint status is "FAIL"
    When Operator get "Pickup" transaction with status "Pending"
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And Operator verify order events on Edit order page using data below:
      | name            |
      | RESUME PICKUP   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |
    And Operator verify order events with description on Edit order page using data below:
      | tags          | name          | description                                                                                                                                            |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold New Granular Status: Arrived at Sorting Hub Old Order Status: On Hold New Order Status: Transit Reason: TICKET_RESOLUTION |
    And Operator verify order events with description on Edit order page using data below:
      | tags          | name          | description                                                                                                                                               |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub New Granular Status: Pending Pickup Old Order Status: Transit New Order Status: Pending Reason: RESUME_PICKUP |
