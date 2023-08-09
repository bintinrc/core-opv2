@OperatorV2 @Core @EditOrder @Recovery @ResolveTicket @ResolveTicketPart1 @EditOrder3
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
      | orderOutcomeDamaged     | NV NOT LIABLE - PARCEL DELIVERED      |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED                         |
      | keepCurrentOrderOutcome | true                             |
      | outcome                 | NV NOT LIABLE - PARCEL DELIVERED |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | status   | Success                      |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Route - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Success                      |
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
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
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
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | status   | Pending                      |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Route - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | UPDATE STATUS   |
      | CANCEL          |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  Scenario: Operator Resolve Recovery Ticket with Outcome = RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | DAMAGED                               |
      | orderOutcomeDamaged     | NV NOT LIABLE - RETURN PARCEL         |
      | rtsReason               | Nobody at address                     |
      | damageDescription       | GENERATED                             |
      | liability               | Shipper                               |
      | parcelLocation          | DAMAGED RACK                          |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED                      |
      | outcome                 | NV NOT LIABLE - RETURN PARCEL |
      | keepCurrentOrderOutcome | true                          |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
    When Operator refresh page
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status  | PENDING                                    |
      | address | {KEY_CREATED_ORDER.buildFromAddressString} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Route - verify waypoints record:
      | id       | {KEY_TRANSACTION.waypointId}                 |
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
      | orderOutcomeDamaged     | NV TO REPACK AND SHIP                 |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | name          |
      | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED              |
      | outcome                 | NV TO REPACK AND SHIP |
      | keepCurrentOrderOutcome | true                  |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL EXCEPTION                      |
      | ticketSubType           | COMPLETED ORDER                       |
      | liability               | Shipper                               |
      | orderOutcome            | RTS                                   |
      | rtsReason               | Nobody at address                     |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED |
      | outcome                 | RTS      |
      | keepCurrentOrderOutcome | true     |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL EXCEPTION                      |
      | ticketSubType           | COMPLETED ORDER                       |
      | liability               | Shipper                               |
      | orderOutcome            | RESEND                                |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED |
      | outcome                 | RESEND   |
      | keepCurrentOrderOutcome | true     |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL EXCEPTION                      |
      | ticketSubType           | COMPLETED ORDER                       |
      | liability               | Shipper                               |
      | orderOutcome            | RELABELLED TO SEND                    |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED           |
      | outcome                 | RELABELLED TO SEND |
      | keepCurrentOrderOutcome | true               |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL EXCEPTION                      |
      | ticketSubType           | COMPLETED ORDER                       |
      | liability               | Shipper                               |
      | orderOutcome            | XMAS CAGE                             |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED  |
      | outcome                 | XMAS CAGE |
      | keepCurrentOrderOutcome | true      |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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

  Scenario: Operator Resolve Recovery Ticket with Cancelled Order & Outcome = RESUME DELIVERY
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL EXCEPTION                      |
      | ticketSubType           | CANCELLED ORDER                       |
      | liability               | Shipper                               |
      | orderOutcome            | RESUME DELIVERY                       |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED        |
      | outcome                 | RESUME DELIVERY |
      | keepCurrentOrderOutcome | true            |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL EXCEPTION                      |
      | ticketSubType           | CANCELLED ORDER                       |
      | liability               | Shipper                               |
      | orderOutcome            | RTS                                   |
      | rtsReason               | Nobody at address                     |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED |
      | outcome                 | RTS      |
      | keepCurrentOrderOutcome | true     |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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

  Scenario: Operator Resolve Recovery Ticket with Cancelled Order & Outcome = XMAS CAGE
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL EXCEPTION                      |
      | ticketSubType           | CANCELLED ORDER                       |
      | liability               | Shipper                               |
      | orderOutcome            | XMAS CAGE                             |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Cancelled |
      | granularStatus | Cancelled |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED  |
      | outcome                 | XMAS CAGE |
      | keepCurrentOrderOutcome | true      |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED          |
      | outcome                 | RTS               |
      | rtsReason               | Nobody at address |
      | keepCurrentOrderOutcome | true              |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
      | status  | PENDING                                    |
      | address | {KEY_CREATED_ORDER.buildFromAddressString} |
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
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "requested_tracking_number":"{KEY_TRACKING_NUMBER}","service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED  |
      | outcome                 | XMAS CAGE |
      | keepCurrentOrderOutcome | true      |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
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
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "requested_tracking_number":"{KEY_TRACKING_NUMBER}","service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    When Operator updates recovery ticket on Edit Order V2 page:
      | status                  | RESOLVED       |
      | outcome                 | ORDERS CREATED |
      | keepCurrentOrderOutcome | true           |
    Then Operator verifies that success react notification displayed:
      | top                | ^Ticket ID: .* Updated |
      | waitUntilInvisible | true                   |
    Then Operator verifies ticket status is "RESOLVED" on Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
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
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | MISSING                               |
      | orderOutcomeMissing     | LOST - DECLARED                       |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup New Granular Status: On Hold Old Order Status: Pending New Order Status: On Hold Reason: TICKET_CREATION |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - wait for order state:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Transit                               |
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
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | MISSING                               |
      | orderOutcomeMissing     | FOUND - INBOUND                       |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
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

  @DeleteRoutes
  Scenario: Resolve MISSING PETS Ticket upon Route Inbound
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Recovery                              |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | MISSING                               |
      | orderOutcomeMissing     | FOUND - INBOUND                       |
    When Operator verifies that success react notification displayed:
      | top                | Ticket has been created! |
      | waitUntilInvisible | true                     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                   |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Fail New Delivery Status: Pending Old Granular Status: Pending Reschedule New Granular Status: On Hold Old Order Status: Delivery fail New Order Status: On Hold Reason: TICKET_CREATION |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans       | 1 |
      | parcelProcessedTotal       | 1 |
      | failedDeliveriesValidScans | 1 |
      | failedDeliveriesValidTotal | 1 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
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
      | tags          | name          | description                                                                                                                                            |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold New Granular Status: Arrived at Sorting Hub Old Order Status: On Hold New Order Status: Transit Reason: TICKET_RESOLUTION |
    And Operator verify order events on Edit Order V2 page using data below:
      | name               |
      | ROUTE INBOUND SCAN |
      | TICKET RESOLVED    |