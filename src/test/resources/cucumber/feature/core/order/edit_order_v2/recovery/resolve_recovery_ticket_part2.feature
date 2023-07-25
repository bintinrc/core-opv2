@OperatorV2 @Core @EditOrderV2 @ResolveTicket @ResolveTicketPart2
Feature: Resolve Recovery Ticket

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

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
    When Operator updates recovery ticket on Edit Order V2 page:
      | status  | RESOLVED      |
      | outcome | RESUME PICKUP |
    And Operator refresh page
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_TRANSACTION_BEFORE"
    And DB Core - verify transactions record:
      | id     | {KEY_PP_TRANSACTION_BEFORE.id} |
      | status | Failed                         |
    And DB Core - verify waypoints record:
      | id     | {KEY_PP_TRANSACTION_BEFORE.waypointId} |
      | status | Failed                                 |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION_BEFORE"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION_BEFORE.id} |
      | status | Failed                         |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION_BEFORE.waypointId} |
      | status | Failed                                 |
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
    When Operator updates recovery ticket on Edit Order V2 page:
      | status  | RESOLVED      |
      | outcome | RESUME PICKUP |
    And Operator refresh page
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_TRANSACTION_BEFORE"
    And DB Core - verify transactions record:
      | id     | {KEY_PP_TRANSACTION_BEFORE.id} |
      | status | Failed                         |
    And DB Core - verify waypoints record:
      | id     | {KEY_PP_TRANSACTION_BEFORE.waypointId} |
      | status | Failed                                 |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_TRANSACTION_BEFORE"
    And DB Core - verify transactions record:
      | id     | {KEY_DD_TRANSACTION_BEFORE.id} |
      | status | Failed                         |
    And DB Core - verify waypoints record:
      | id     | {KEY_DD_TRANSACTION_BEFORE.waypointId} |
      | status | Failed                                 |
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
