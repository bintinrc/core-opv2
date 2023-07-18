@NewRecoveryTicketsPage @OperatorV2 @ClearCache @ClearCookies
Feature: New Recovery Tickets

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Ticket Via CSV Modals - Upload CSV file without header
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator upload a CSV file without header
    Then Operator verifies error message is displayed
      | top      | Invalid csv. Please include headers in csv file. |
      | fileName | No Headers File.csv                              |

  Scenario: Operator Create Bulk Ticket - Recovery Ticket - Partial Success
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator downloads sample csv file on Create Tickets Via CSV modal
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | type               | PE,PE                                                                                 |
      | subType            | CN,BA                                                                                 |
      | investigationGroup | XB                                                                                    |
      | assigneeEmail      | automationTest@gmail.com                                                              |
      | investigationHubId | 1                                                                                     |
      | entrySource        | RS                                                                                    |
      | ticketNotes        | automation test                                                                       |
    Then Operator verifies partial success message is displayed
      | top      | Successfully create tickets for following tracking ID(s)     |
      | bottom   | We are unable to create tickets for following tracking ID(s) |
      | fileName | csv_create_tickets_                                          |
    When Operator click "Done" on Creat Ticket Via CSV dialog
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    Then Operator verifies invalid search result message is shown on Find Tickets by CSV dialog
      | message     | No relevant PETS tickets for these Tracking IDs found |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}            |
    When Operator click Load Selection button on Find Tickets by CSV dialog
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType/subType  | PARCEL EXCEPTION : CANCELLED ORDER         |
      | orderGranularStatus | On Hold                                    |

  Scenario:Operator Create Bulk Ticket - Recovery Ticket - Error data
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | NINJRECOVERY112606       |
      | type               | PE                       |
      | subType            | CN                       |
      | investigationGroup | XB                       |
      | assigneeEmail      | automationTest@gmail.com |
      | investigationHubId | 1                        |
      | entrySource        | RS                       |
      | ticketNotes        | automation test          |
    Then Operator verifies error message is displayed
      | top      | The uploaded csv contains invalid tracking id. |
      | fileName | csv_create_tickets_                            |
    When Operator click "Download Error Data File" on Creat Ticket Via CSV dialog
    Then Operator verify error data file downloaded successfully with correct content

  Scenario: Operator Create Bulk Ticket - Recovery Ticket - Proceed with valid data
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator downloads sample csv file on Create Tickets Via CSV modal
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}, NINJREC112606 |
      | type               | PE,SI                                                     |
      | subType            | CN,DP                                                     |
      | investigationGroup | XB                                                        |
      | assigneeEmail      | automationTest@gmail.com                                  |
      | investigationHubId | 1                                                         |
      | entrySource        | RS                                                        |
      | ticketNotes        | automation test                                           |
    Then Operator verifies error message is displayed
      | top      | The uploaded csv contains invalid tracking id. |
      | fileName | csv_create_tickets_                            |
    When Operator click "Proceed With Valid Data" on Creat Ticket Via CSV dialog
    Then Operator verifies error message is displayed
      | top      | Successfully create tickets for following tracking ID(s) |
      | fileName | csv_create_tickets_                                      |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

  Scenario: Operator Find tickets By CSV - all TIDs not found
    Given Operator goes to new Recovery Tickets page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | NINJRECOVERY112606 |
      | AUTORECOVERY126346 |
    Then Operator verifies invalid search result message is shown on Find Tickets by CSV dialog
      | message     | No relevant PETS tickets for these Tracking IDs found |
      | trackingIds | NINJRECOVERY112606,AUTORECOVERY126346                 |

  Scenario: Operator Find tickets By CSV - some TIDs not found
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
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
    When Operator goes to new Recovery Tickets page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | AUTORECOVERY126346                    |
    Then Operator verifies invalid search result message is shown on Find Tickets by CSV dialog
      | message     | No relevant PETS tickets for these Tracking IDs found |
      | trackingIds | AUTORECOVERY126346                                    |
    When Operator click Load Selection button on Find Tickets by CSV dialog
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | PARCEL EXCEPTION : INACCURATE ADDRESS        |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | {ticketing-creator-user-name}                |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | daysSince           | -1                                           |
      | created             | {date: 0 days next, yyyy-MM-dd}              |

  Scenario: Operator Find tickets By CSV - search results
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
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
    When Operator goes to new Recovery Tickets page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | PARCEL EXCEPTION : INACCURATE ADDRESS        |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | {ticketing-creator-user-name}                |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | daysSince           | -1                                           |
      | created             | {date: 0 days next, yyyy-MM-dd}              |

  @BulkCSV
  Scenario Outline: Operator Create Bulk Ticket - Recovery Ticket - PARCEL EXCEPTION - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | type               | PE,PE                                                                                 |
      | subType            | <acronym>,<acronym>                                                                   |
      | investigationGroup | RCY                                                                                   |
      | assigneeEmail      | ekki.syam@ninjavan.co                                                                 |
      | investigationHubId | {hub-id}                                                                              |
      | entrySource        | RS                                                                                    |
      | ticketNotes        | automation test                                                                       |
    When Operator click "Done" on Creat Ticket Via CSV dialog
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" with granular status "ON_HOLD"
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" with granular status "ON_HOLD"
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | <ticketType/Subtype>                         |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}   |
      | ticketType/subType  | <ticketType/Subtype>                         |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[2].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    Examples:
      | Dataset Name                                 | acronym | ticketType/Subtype                             |
      | ticket_subtype = CUSTOMER REJECTED           | CR      | PARCEL EXCEPTION : CUSTOMER REJECTED           |
      | ticket_subtype = CANCELLED ORDER             | CN      | PARCEL EXCEPTION : CANCELLED ORDER             |
      | ticket_subtype = COMPLETED ORDER             | CO      | PARCEL EXCEPTION : COMPLETED ORDER             |
      | ticket_subtype = DISPUTED ORDER INFO         | DO      | PARCEL EXCEPTION : DISPUTED ORDER INFO         |
      | ticket_subtype = DP OVERSIZED                | DZ      | PARCEL EXCEPTION : DP OVERSIZED                |
      | ticket_subtype = INACCURATE ADDRESS          | IA      | PARCEL EXCEPTION : INACCURATE ADDRESS          |
      | ticket_subtype = MAXIMUM ATTEMPTS (DELIVERY) | MA      | PARCEL EXCEPTION : MAXIMUM ATTEMPTS (DELIVERY) |
      | ticket_subtype = MAXIMUM ATTEMPTS (RTS)      | MR      | PARCEL EXCEPTION : MAXIMUM ATTEMPTS (RTS)      |
      | ticket_subtype = RESTRICTED ZONES            | RZ      | PARCEL EXCEPTION : RESTRICTED ZONES            |

  @BulkCSV
  Scenario Outline: Operator Create Bulk Ticket - Recovery Ticket - SHIPPER ISSUE - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | type               | SI,SI                                                                                 |
      | subType            | <acronym>,<acronym>                                                                   |
      | investigationGroup | RCY                                                                                   |
      | assigneeEmail      | ekki.syam@ninjavan.co                                                                 |
      | investigationHubId | {hub-id}                                                                              |
      | entrySource        | RS                                                                                    |
      | ticketNotes        | automation test                                                                       |
    When Operator click "Done" on Creat Ticket Via CSV dialog
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" with granular status "ON_HOLD"
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" with granular status "ON_HOLD"
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | <ticketType/Subtype>                         |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}   |
      | ticketType/subType  | <ticketType/Subtype>                         |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[2].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    Examples:
      | Dataset Name                          | acronym | ticketType/Subtype                   |
      | ticket_subtype = REJECTED RETURN      | RR      | SHIPPER ISSUE : REJECTED RETURN      |
      | ticket_subtype = DUPLICATE PARCEL     | DP      | SHIPPER ISSUE : DUPLICATE PARCEL     |
      | ticket_subtype = NO LABEL             | NL      | SHIPPER ISSUE : NO LABEL             |
      | ticket_subtype = NO ORDER             | NO      | SHIPPER ISSUE : NO ORDER             |
      | ticket_subtype = OVERWEIGHT/OVERSIZED | OO      | SHIPPER ISSUE : OVERWEIGHT/OVERSIZED |
      | ticket_subtype = RESTRICTED GOODS     | RG      | SHIPPER ISSUE : RESTRICTED GOODS     |
      | ticket_subtype = POOR LABELLING       | PL      | SHIPPER ISSUE : POOR LABELLING       |
      | ticket_subtype = POOR PACKAGING       | PP      | SHIPPER ISSUE : POOR PACKAGING       |
      | ticket_subtype = SUSPICIOUS PARCEL    | SP      | SHIPPER ISSUE : SUSPICIOUS PARCEL    |

  @BulkCSV
  Scenario Outline: Operator Create Bulk Ticket - Recovery Ticket - PARCEL ON HOLD - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | type               | PH,PH                                                                                 |
      | subType            | <acronym>,<acronym>                                                                   |
      | investigationGroup | RCY                                                                                   |
      | assigneeEmail      | ekki.syam@ninjavan.co                                                                 |
      | investigationHubId | {hub-id}                                                                              |
      | entrySource        | RS                                                                                    |
      | ticketNotes        | automation test                                                                       |
    When Operator click "Done" on Creat Ticket Via CSV dialog
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" with granular status "ON_HOLD"
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" with granular status "ON_HOLD"
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | <ticketType/Subtype>                         |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}   |
      | ticketType/subType  | <ticketType/Subtype>                         |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[2].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    Examples:
      | Dataset Name                                    | acronym | ticketType/Subtype                              |
      | ticket_subtype = SHIPPER REQUEST                | SQ      | PARCEL ON HOLD : SHIPPER REQUEST                |
      | ticket_subtype = CUSTOMER REQUEST               | CQ      | PARCEL ON HOLD : CUSTOMER REQUEST               |
      | ticket_subtype = PAYMENT PENDING (NINJA DIRECT) | ND      | PARCEL ON HOLD : PAYMENT PENDING (NINJA DIRECT) |

  @BulkCSV
  Scenario: Operator Create Bulk Ticket - Recovery Ticket - DAMAGED
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | type               | DM,DM                                                                       |
      | investigationGroup | RCY                                                                         |
      | assigneeEmail      | ekki.syam@ninjavan.co                                                       |
      | investigationHubId | {hub-id}                                                                    |
      | entrySource        | RS                                                                          |
      | ticketNotes        | automation test                                                             |
    When Operator click "Done" on Creat Ticket Via CSV dialog
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator filter search result by field "Tracking ID" with value "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | DAMAGED                                      |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}   |
      | ticketType/subType  | DAMAGED                                      |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[2].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

  @BulkCSV
  Scenario: Operator Create Bulk Ticket - Recovery Ticket - MISSING
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | type               | MI,MI                                                                       |
      | investigationGroup | RCY                                                                         |
      | assigneeEmail      | ekki.syam@ninjavan.co                                                       |
      | investigationHubId | {hub-id}                                                                    |
      | entrySource        | RS                                                                          |
      | ticketNotes        | automation test                                                             |
    When Operator click "Done" on Creat Ticket Via CSV dialog
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator filter search result by field "Tracking ID" with value "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | MISSING                                      |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}   |
      | ticketType/subType  | MISSING                                      |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[2].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

  @BulkCSV
  Scenario: Operator Create Bulk Ticket - Recovery Ticket - SELF COLLECTION
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | type               | SC,SC                                                                       |
      | investigationGroup | RCY                                                                         |
      | assigneeEmail      | ekki.syam@ninjavan.co                                                       |
      | investigationHubId | {hub-id}                                                                    |
      | entrySource        | RS                                                                          |
      | ticketNotes        | automation test                                                             |
    When Operator click "Done" on Creat Ticket Via CSV dialog
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator filter search result by field "Tracking ID" with value "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | SELF COLLECTION                              |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}   |
      | ticketType/subType  | SELF COLLECTION                              |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[2].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

  @BulkCSV
  Scenario: Operator Create Bulk Ticket - Recovery Ticket - SLA BREACH
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    Given Operator goes to new Recovery Tickets page
    When Operator create ticket by csv in Recovery Tickets page
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | type               | SB,SB                                                                       |
      | investigationGroup | RCY                                                                         |
      | assigneeEmail      | ekki.syam@ninjavan.co                                                       |
      | investigationHubId | {hub-id}                                                                    |
      | entrySource        | RS                                                                          |
      | ticketNotes        | automation test                                                             |
    When Operator click "Done" on Creat Ticket Via CSV dialog
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator downloads search csv sample file on Find Tickets by CSV modal
    And Operator upload a csv on Find Tickets By CSV dialog
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator filter search result by field "Tracking ID" with value "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | SLA BREACH                                   |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}   |
      | ticketType/subType  | SLA BREACH                                   |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[2].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
      | assignee            | Ekki Syam                                    |
      | daysSince           | 0                                            |
      | created             | {date: 0 days next, yyyy-MM-dd}              |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "On Hold" on Edit Order V2 page
    And Operator verify order granular status is "On Hold" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |