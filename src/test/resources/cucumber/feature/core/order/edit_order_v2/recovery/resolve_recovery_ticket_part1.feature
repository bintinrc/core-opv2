@OperatorV2 @Core @EditOrderV2 @Recovery @ResolveTicket @ResolveTicketPart1
Feature: Resolve Recovery Ticket

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Resolve Recovery Ticket with Outcome = Force Success
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
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | DAMAGED                                    |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (DAMAGED)                    |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | DAMAGED                                    |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          |
      | UPDATE STATUS |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | NV NOT LIABLE - PARCEL DELIVERED         |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | SUCCESS  |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION_PP"
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION_PP.waypointId} |
      | status   | Success                         |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION_DD"
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION_DD.waypointId} |
      | status   | Success                         |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | FORCED SUCCESS  |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Outcome = Order Cancel
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | DAMAGED                               |
      | ticketSubType           | IMPROPER PACKAGING                    |
      | parcelLocation          | DAMAGED RACK                          |
      | liability               | Shipper                               |
      | damageDescription       | GENERATED                             |
      | orderOutcomeDamaged     | NV NOT LIABLE - PARCEL DISPOSED       |
    When Operator verifies that success react notification displayed:
      | top | Ticket has been created! |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED                        |
      | outcome                 | NV NOT LIABLE - PARCEL DISPOSED |
      | keepCurrentOrderOutcome | true                            |
    Then Operator verifies that success react notification displayed:
      | top | ^Ticket ID: .* Updated |
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
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION_PP"
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION_PP.waypointId} |
      | status   | Pending                         |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION_DD"
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION_DD.waypointId} |
      | status   | Pending                         |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | CANCEL          |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Outcome = RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | DAMAGED                                    |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (DAMAGED)                    |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | DAMAGED                                    |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    And Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          |
      | UPDATE STATUS |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | 90                               |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | rtsCustomFieldId | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[2]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | NV NOT LIABLE - RETURN PARCEL            |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    When Operator refresh page
    And Operator unmask Edit Order V2 page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status  | PENDING                        |
      | address | 233E ST. JOHN'S ROAD 757995 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}                 |
      | status   | Pending                                      |
      | routeId  | null                                         |
      | seqNo    | null                                         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | RTS             |
      | UPDATE ADDRESS  |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Outcome = Default No Action
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | DAMAGED                                    |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (DAMAGED)                    |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | DAMAGED                                    |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          |
      | UPDATE STATUS |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | NV TO REPACK AND SHIP                    |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
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

  Scenario: Operator Resolve Recovery Ticket with Completed Order & Outcome = RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | COMPLETED ORDER                            |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (COMPLETED ORDER)            |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | PARCEL EXCEPTION                           |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | 90                               |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | rtsCustomFieldId | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[2]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | RTS                                      |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And Operator verify order events on Edit Order V2 page using data below:
      | name             |
      | UPDATE STATUS    |
      | RESCHEDULE       |
      | RTS              |
      | REVERT COMPLETED |
      | UPDATE ADDRESS   |
      | TICKET UPDATED   |
      | TICKET RESOLVED  |

  Scenario: Operator Resolve Recovery Ticket with Completed Order & Outcome = Resend
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
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | COMPLETED ORDER                            |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (COMPLETED ORDER)            |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | PARCEL EXCEPTION                           |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | RESEND                                   |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And Operator verify order events on Edit Order V2 page using data below:
      | name             |
      | UPDATE STATUS    |
      | RESCHEDULE       |
      | REVERT COMPLETED |
      | TICKET UPDATED   |
      | TICKET RESOLVED  |

  Scenario: Operator Resolve Recovery Ticket with Cancelled Order & Outcome = RESUME DELIVERY
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | CANCELLED ORDER                            |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (CANCELLED ORDER)            |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | PARCEL EXCEPTION                           |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
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
      | outcome          | RESUME DELIVERY                          |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And Operator verify order events on Edit Order V2 page using data below:
      | name             |
      | UPDATE STATUS    |
      | RESCHEDULE       |
      | REVERT COMPLETED |
      | TICKET UPDATED   |
      | TICKET RESOLVED  |

  Scenario: Operator Resolve Recovery Ticket with Cancelled Order & Outcome = RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | CANCELLED ORDER                            |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (CANCELLED ORDER)            |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | PARCEL EXCEPTION                           |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    When Operator refresh page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | 90                               |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | rtsCustomFieldId | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[2]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | RTS                                      |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP  |
      | status | SUCCESS |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And Operator verify order events on Edit Order V2 page using data below:
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
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "requested_tracking_number":"{KEY_CORE_STAMP_TRACKING_NUMBER}","service_type":"Parcel", "service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}          |
    And DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | 90                               |
    And API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | rtsCustomFieldId | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[2]} |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | status           | RESOLVED                                 |
      | outcome          | RTS                                      |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    And Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status  | PENDING                        |
      | address | 233E ST. JOHN'S ROAD 757995 SG |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}                 |
      | status   | Pending                                      |
      | routeId  | null                                         |
      | seqNo    | null                                         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | RTS             |
      | UPDATE ADDRESS  |
      | TICKET UPDATED  |
      | TICKET RESOLVED |
