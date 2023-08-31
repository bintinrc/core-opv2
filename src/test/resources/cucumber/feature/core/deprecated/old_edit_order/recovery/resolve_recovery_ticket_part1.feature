@OperatorV2 @Core @EditOrder @Recovery @ResolveTicket @ResolveTicketPart1 @EditOrder3
Feature: Resolve Recovery Ticket

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Resolve Recovery Ticket with Outcome = Force Success
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
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
      | status | SUCCESS |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | SUCCESS  |
    And API Operator get order details
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
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
    Given New Stamp ID with "COPV2" prefix was generated
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_STAMP_ID}           |
      | ticketType         | SHIPPER ISSUE            |
      | subTicketType      | NO ORDER                 |
      | entrySource        | CUSTOMER COMPLAINT       |
      | investigatingParty | 448                      |
      | investigatingHubId | {hub-id}                 |
      | orderOutcomeName   | ORDER OUTCOME (NO ORDER) |
      | creatorUserId      | 117472837373252971898    |
      | creatorUserName    | Ekki Syam                |
      | creatorUserEmail   | ekki.syam@ninjavan.co    |
    And API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "requested_tracking_number":"{KEY_TRACKING_NUMBER}","service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status    | RESOLVED          |
      | outcome   | RTS               |
      | rtsReason | Nobody at address |
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
      | country  | {KEY_CREATED_ORDER.fromCountry}  |
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | RTS             |
      | UPDATE ADDRESS  |
      | TICKET UPDATED  |
      | TICKET RESOLVED |
