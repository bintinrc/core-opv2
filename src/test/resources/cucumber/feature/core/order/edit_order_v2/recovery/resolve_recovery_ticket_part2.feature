@OperatorV2 @Core @EditOrderV2 @ResolveTicket @ResolveTicketPart2
Feature: Resolve Recovery Ticket

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Resolve Recovery Ticket with No Order & Outcome = XMAS CAGE
    Given New Stamp ID with "{shipper-v4-prefix}" prefix was generated
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_CORE_STAMP_ID}            |
      | ticketType         | SHIPPER ISSUE                  |
      | subTicketType      | NO ORDER                       |
      | entrySource        | CUSTOMER COMPLAINT             |
      | investigatingParty | 456                            |
      | investigatingHubId | {hub-id}                       |
      | shipperZendeskId   | 1                              |
      | custZendeskId      | 1                              |
      | ticketNotes        | GENERATED                      |
      | orderOutcomeName   | ORDER OUTCOME (NO ORDER)       |
      | creatorUserId      | {ticketing-creator-user-id}    |
      | creatorUserName    | {ticketing-creator-user-name}  |
      | creatorUserEmail   | {ticketing-creator-user-email} |
    #And Operator go to menu Recovery -> Recovery Tickets
#    And Operator create new ticket on page Recovery Tickets using data below:
#      | trackingId              | {KEY_STAMP_ID}     |
#      | entrySource             | CUSTOMER COMPLAINT |
#      | investigatingDepartment | Recovery           |
#      | investigatingHub        | {hub-name}         |
#      | ticketType              | SHIPPER ISSUE      |
#      | ticketSubType           | NO ORDER           |
#      | orderOutcome            | XMAS CAGE          |
#      | issueDescription        | GENERATED          |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "requested_tracking_number":"{KEY_CORE_STAMP_TRACKING_NUMBER}","service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | XMAS CAGE                                |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
#    When Operator updates recovery ticket on Edit Order V2 page:
#      | status                  | RESOLVED  |
#      | outcome                 | XMAS CAGE |
#      | keepCurrentOrderOutcome | true      |
#    Then Operator verifies that success react notification displayed:
#      | top | ^Ticket ID: .* Updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP    |
      | status | CANCELLED |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY  |
      | status | CANCELLED |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | CANCEL          |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with No Order & Outcome = ORDERS CREATED
    Given New Stamp ID with "{shipper-v4-prefix}" prefix was generated
#    And Operator go to menu Recovery -> Recovery Tickets
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_CORE_STAMP_ID}            |
      | ticketType         | SHIPPER ISSUE                  |
      | subTicketType      | NO ORDER                       |
      | entrySource        | CUSTOMER COMPLAINT             |
      | investigatingParty | 456                            |
      | investigatingHubId | {hub-id}                       |
      | shipperZendeskId   | 1                              |
      | custZendeskId      | 1                              |
      | ticketNotes        | GENERATED                      |
      | orderOutcomeName   | ORDER OUTCOME (NO ORDER)       |
      | creatorUserId      | {ticketing-creator-user-id}    |
      | creatorUserName    | {ticketing-creator-user-name}  |
      | creatorUserEmail   | {ticketing-creator-user-email} |
#    And Operator create new ticket on page Recovery Tickets using data below:
#      | trackingId              | {KEY_STAMP_ID}     |
#      | entrySource             | CUSTOMER COMPLAINT |
#      | investigatingDepartment | Recovery           |
#      | investigatingHub        | {hub-name}         |
#      | ticketType              | SHIPPER ISSUE      |
#      | ticketSubType           | NO ORDER           |
#      | orderOutcome            | ORDERS CREATED     |
#      | issueDescription        | GENERATED          |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "requested_tracking_number":"{KEY_CORE_STAMP_TRACKING_NUMBER}","service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | ORDERS CREATED                           |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
#    When Operator updates recovery ticket on Edit Order V2 page:
#      | status                  | RESOLVED       |
#      | outcome                 | ORDERS CREATED |
#      | keepCurrentOrderOutcome | true           |
#    Then Operator verifies that success react notification displayed:
#      | top | ^Ticket ID: .* Updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Completed Order & Outcome = RELABELLED TO SEND
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | COMPLETED ORDER                            |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | orderOutcomeName   | ORDER OUTCOME (COMPLETED ORDER)            |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
#    When Operator create new recovery ticket on Edit Order V2 page:
#      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
#      | entrySource             | CUSTOMER COMPLAINT                    |
#      | investigatingDepartment | Recovery                              |
#      | investigatingHub        | {hub-name}                            |
#      | ticketType              | PARCEL EXCEPTION                      |
#      | ticketSubType           | COMPLETED ORDER                       |
#      | liability               | Shipper                               |
#      | orderOutcome            | RELABELLED TO SEND                    |
#    When Operator verifies that success react notification displayed:
#      | top | Ticket has been created! |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
#    When Operator updates recovery ticket on Edit Order V2 page:
#      | status                  | RESOLVED           |
#      | outcome                 | RELABELLED TO SEND |
#      | keepCurrentOrderOutcome | true               |
#    Then Operator verifies that success react notification displayed:
#      | top | ^Ticket ID: .* Updated |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | RELABELLED TO SEND                       |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | SUCCESS  |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Completed Order & Outcome = XMAS CAGE
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | COMPLETED ORDER                            |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | orderOutcomeName   | ORDER OUTCOME (COMPLETED ORDER)            |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
#    When Operator create new recovery ticket on Edit Order V2 page:
#      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
#      | entrySource             | CUSTOMER COMPLAINT                    |
#      | investigatingDepartment | Recovery                              |
#      | investigatingHub        | {hub-name}                            |
#      | ticketType              | PARCEL EXCEPTION                      |
#      | ticketSubType           | COMPLETED ORDER                       |
#      | liability               | Shipper                               |
#      | orderOutcome            | XMAS CAGE                             |
#    When Operator verifies that success react notification displayed:
#      | top | Ticket has been created! |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
#    When Operator updates recovery ticket on Edit Order V2 page:
#      | status                  | RESOLVED  |
#      | outcome                 | XMAS CAGE |
#      | keepCurrentOrderOutcome | true      |
#    Then Operator verifies that success react notification displayed:
#      | top | ^Ticket ID: .* Updated |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | XMAS CAGE                                |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | SUCCESS  |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Cancelled Order & Outcome = XMAS CAGE
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | CANCELLED ORDER                            |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | orderOutcomeName   | ORDER OUTCOME (CANCELLED ORDER)            |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
#    When Operator create new recovery ticket on Edit Order V2 page:
#      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
#      | entrySource             | CUSTOMER COMPLAINT                    |
#      | investigatingDepartment | Recovery                              |
#      | investigatingHub        | {hub-name}                            |
#      | ticketType              | PARCEL EXCEPTION                      |
#      | ticketSubType           | CANCELLED ORDER                       |
#      | liability               | Shipper                               |
#      | orderOutcome            | XMAS CAGE                             |
#    When Operator verifies that success react notification displayed:
#      | top | Ticket has been created! |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | XMAS CAGE                                |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
#    When Operator updates recovery ticket on Edit Order V2 page:
#      | status                  | RESOLVED  |
#      | outcome                 | XMAS CAGE |
#      | keepCurrentOrderOutcome | true      |
#    Then Operator verifies that success react notification displayed:
#      | top | ^Ticket ID: .* Updated |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP    |
      | status | CANCELLED |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY  |
      | status | CANCELLED |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Resolve MISSING PETS Ticket upon Global Inbound
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | MISSING                                    |
      #| subTicketType      | CANCELLED ORDER                            |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)                    |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
#    When Operator create new recovery ticket on Edit Order V2 page:
#      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
#      | entrySource             | CUSTOMER COMPLAINT                    |
#      | investigatingDepartment | Recovery                              |
#      | investigatingHub        | {hub-name}                            |
#      | ticketType              | MISSING                               |
#      | orderOutcomeMissing     | LOST - DECLARED                       |
#    When Operator verifies that success react notification displayed:
#      | top | Ticket has been created! |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                          |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub New Granular Status: On Hold Old Order Status: Transit New Order Status: On Hold Reason: TICKET_CREATION |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And Operator waits for 2 seconds
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    Then DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    Then DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: On Hold\nNew Order Status: Transit\n\nReason: TICKET_RESOLUTION |
    And Operator verify order events on Edit Order V2 page using data below:
      | name             |
      | HUB INBOUND SCAN |
      | TICKET RESOLVED  |

  Scenario: Resolve MISSING PETS Ticket upon Parcel Sweep
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | MISSING                                    |
      #| subTicketType      | CANCELLED ORDER                            |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)                    |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
#    When Operator create new recovery ticket on Edit Order V2 page:
#      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
#      | entrySource             | CUSTOMER COMPLAINT                    |
#      | investigatingDepartment | Recovery                              |
#      | investigatingHub        | {hub-name}                            |
#      | ticketType              | MISSING                               |
#      | orderOutcomeMissing     | FOUND - INBOUND                       |
#    When Operator verifies that success react notification displayed:
#      | top | Ticket has been created! |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: On Hold\n\nOld Order Status: Transit\nNew Order Status: On Hold\n\nReason: TICKET_CREATION |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                 |
      | hubId              | {hub-id}                                                              |
      | taskId             | 1                                                                     |
    When Operator waits for 2 seconds
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    Then DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    Then DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: On Hold\nNew Order Status: Transit\n\nReason: TICKET_RESOLUTION |
    And Operator verify order events on Edit Order V2 page using data below:
      | name                |
      | PARCEL ROUTING SCAN |
      | TICKET RESOLVED     |

  Scenario: Operator Resume Pickup For On Hold Order - Ticket Type = Parcel Exception, Inaccurate Address
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
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
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
#    When Operator updates recovery ticket on Edit Order V2 page:
#      | status  | RESOLVED      |
#      | outcome | RESUME PICKUP |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | RESUME PICKUP                            |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    And Operator refresh page
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_TRANSACTION_BEFORE"
    And DB Core - verify transactions record:
      | id     | {KEY_PP_TRANSACTION_BEFORE.id} |
      | status | Fail                           |
    And DB Core - verify waypoints record:
      | id     | {KEY_PP_TRANSACTION_BEFORE.waypointId} |
      | status | Fail                                   |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION_BEFORE"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION_BEFORE.id} |
      | status | Pending                        |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION_BEFORE.waypointId} |
      | status | Pending                                |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_TRANSACTION_AFTER"
    And DB Core - verify transactions record:
      | id     | {KEY_PP_TRANSACTION_AFTER.id} |
      | status | Pending                       |
    And DB Core - verify waypoints record:
      | id     | {KEY_PP_TRANSACTION_AFTER.waypointId} |
      | status | Pending                               |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION_AFTER"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION_AFTER.id} |
      | status | Pending                       |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION_AFTER.waypointId} |
      | status | Pending                               |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | RESUME PICKUP   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: On Hold\nNew Order Status: Transit\n\nReason: TICKET_RESOLUTION |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: Pending Pickup\n\nOld Order Status: Transit\nNew Order Status: Pending\n\nReason: RESUME_PICKUP |

  Scenario: Operator Resume Pickup For On Hold Order - Ticket Type = Shipper Issue, Poor Labelling
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
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
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
#    When Operator updates recovery ticket on Edit Order V2 page:
#      | status  | RESOLVED      |
#      | outcome | RESUME PICKUP |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | RESUME PICKUP                            |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    And Operator refresh page
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_TRANSACTION_BEFORE"
    And DB Core - verify transactions record:
      | id     | {KEY_PP_TRANSACTION_BEFORE.id} |
      | status | Fail                           |
    And DB Core - verify waypoints record:
      | id     | {KEY_PP_TRANSACTION_BEFORE.waypointId} |
      | status | Fail                                   |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION_BEFORE"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION_BEFORE.id} |
      | status | Pending                        |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION_BEFORE.waypointId} |
      | status | Pending                                |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_TRANSACTION_AFTER"
    And DB Core - verify transactions record:
      | id     | {KEY_PP_TRANSACTION_AFTER.id} |
      | status | Pending                       |
    And DB Core - verify waypoints record:
      | id     | {KEY_PP_TRANSACTION_AFTER.waypointId} |
      | status | Pending                               |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION_AFTER"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION_AFTER.id} |
      | status | Pending                       |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION_AFTER.waypointId} |
      | status | Pending                               |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | RESUME PICKUP   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: On Hold\nNew Order Status: Transit\n\nReason: TICKET_RESOLUTION |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub\nNew Granular Status: Pending Pickup\n\nOld Order Status: Transit\nNew Order Status: Pending\n\nReason: RESUME_PICKUP |
