@NewRecoveryTicketsPage @OperatorV2 @ClearCache @ClearCookies
Feature: New Recovery Tickets

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Ticket Via CSV Modals - Upload CSV file without header
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
      | daysSince           | 0                                            |
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
      | daysSince           | 0                                            |
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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
    Given Operator go to menu Recovery -> Recovery Tickets
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

  Scenario Outline: Operator Create Single Ticket - Recovery Ticket - PARCEL ON HOLD - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | ROUTE INBOUNDING                      |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL ON HOLD                        |
      | ticketSubType           | <ticketSubtype>                       |
      | orderOutcome            | RESUME DELIVERY                       |
      | exceptionReason         | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | PARCEL ON HOLD : <ticketSubtype>             |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
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

    Examples:
      | Dataset Name                                    | ticketSubtype                  |
      | ticket_subtype = SHIPPER REQUEST                | SHIPPER REQUEST                |
      | ticket_subtype = CUSTOMER REQUEST               | CUSTOMER REQUEST               |
      | ticket_subtype = PAYMENT PENDING (NINJA DIRECT) | PAYMENT PENDING (NINJA DIRECT) |

  Scenario Outline: Operator Create Single Ticket - Recovery Ticket - PARCEL EXCEPTION - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                   | ROUTE INBOUNDING                      |
      | investigatingDepartment       | Fleet (First Mile)                    |
      | investigatingHub              | {hub-name}                            |
      | ticketType                    | PARCEL EXCEPTION                      |
      | ticketSubType                 | <ticketSubtype>                       |
      | orderOutcomeInaccurateAddress | RTS                                   |
      | rtsReason                     | Nobody at address                     |
      | exceptionReason               | GENERATED                             |
      | custZendeskId                 | 1                                     |
      | shipperZendeskId              | 1                                     |
      | ticketNotes                   | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | PARCEL EXCEPTION : <ticketSubtype>           |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
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

    Examples:
      | Dataset Name         | ticketSubtype               |
      | cancelled order      | CANCELLED ORDER             |
      | completed order      | COMPLETED ORDER             |
      | customer rejected    | CUSTOMER REJECTED           |
      | disputed order info  | DISPUTED ORDER INFO         |
      | dp oversized         | DP OVERSIZED                |
      | inaccurate address   | INACCURATE ADDRESS          |
      | max attempt delivery | MAXIMUM ATTEMPTS (DELIVERY) |
      | max attempt rts      | MAXIMUM ATTEMPTS (RTS)      |
      | restricted zones     | RESTRICTED ZONES            |

  Scenario Outline: Operator Create Single Ticket - Recovery Ticket - SHIPPER ISSUE - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                 | ROUTE INBOUNDING                      |
      | investigatingDepartment     | Fleet (First Mile)                    |
      | investigatingHub            | {hub-name}                            |
      | ticketType                  | SHIPPER ISSUE                         |
      | ticketSubType               | <ticketSubtype>                       |
      | orderOutcomeDuplicateParcel | RTS                                   |
      | rtsReason                   | Nobody at address                     |
      | issueDescription            | GENERATED                             |
      | custZendeskId               | 1                                     |
      | shipperZendeskId            | 1                                     |
      | ticketNotes                 | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | ticketType/subType  | SHIPPER ISSUE : <ticketSubtype>              |
      | orderGranularStatus | On Hold                                      |
      | ticketCreator       | QA Ninja                                     |
      | shipper             | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | redTickets          | False                                        |
      | investigatingHub    | {hub-name}                                   |
      | investigatingDept   | Recovery                                     |
      | status              | PENDING                                      |
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

    Examples:
      | Dataset Name         | ticketSubtype        |
      | duplicate parcel     | DUPLICATE PARCEL     |
      | no order             | NO ORDER             |
      | overweight oversized | OVERWEIGHT/OVERSIZED |
      | poor packaging label | POOR PACKAGING/LABEL |
      | rejected return      | REJECTED RETURN      |
      | restricted goods     | RESTRICTED GOODS     |

  Scenario: Operator Create Single Ticket - Recovery Ticket - DAMAGED
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | DAMAGED                               |
      | orderOutcomeDamaged     | NV LIABLE - PARTIAL - RESUME DELIVERY |
      | parcelLocation          | DAMAGED RACK                          |
      | liability               | Fleet (First Mile)                    |
      | damageDescription       | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
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

  Scenario: Operator Create Single Ticket - Recovery Ticket - MISSING
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | MISSING                               |
      | orderOutcomeMissing     | LOST - DECLARED                       |
      | parcelDescription       | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
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

  Scenario: Operator Create Single Ticket - Recovery Ticket - SELF COLLECTION
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                 | DRIVER TURN                           |
      | investigatingDepartment     | Fleet (First Mile)                    |
      | investigatingHub            | {hub-name}                            |
      | ticketType                  | SELF COLLECTION                       |
      | orderOutcomeDuplicateParcel | COLLECTED BY SHIPPER                  |
      | custZendeskId               | 1                                     |
      | shipperZendeskId            | 1                                     |
      | ticketNotes                 | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
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

  Scenario: Operator Create Single Ticket - Recovery Ticket - SLA BREACH
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | DRIVER TURN                           |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | SLA BREACH                            |
      | orderOutcome            | RESUME DELIVERY                       |
      | breachReason            | Auto breach reason                    |
      | breachLeg               | Forward                               |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
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

  Scenario Outline: Operator Create Single Ticket - Recovery Ticket - SHIPPER ISSUE - No Label/No Order - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}123 |
      | entrySource             | DRIVER TURN                              |
      | investigatingDepartment | Fleet (First Mile)                       |
      | investigatingHub        | {hub-name}                               |
      | ticketType              | SHIPPER ISSUE                            |
      | ticketSubType           | <ticketSubtype>                          |
      | orderOutcome            | XMAS CAGE                                |
      | issueDescription        | GENERATED                                |
      | custZendeskId           | 1                                        |
      | shipperZendeskId        | 1                                        |
      | ticketNotes             | GENERATED                                |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies correct ticket details as following:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}123 |
      | ticketType/subType | SHIPPER ISSUE : <ticketSubtype>          |
      | ticketCreator      | QA Ninja                                 |
      | redTickets         | False                                    |
      | investigatingHub   | {hub-name}                               |
      | investigatingDept  | Recovery                                 |
      | status             | PENDING                                  |
      | daysSince          | 0                                        |
      | created            | {date: 0 days next, yyyy-MM-dd}          |

    Examples:
      | Dataset Name | ticketSubtype |
      | No label     | NO LABEL      |
      | no order     | NO ORDER      |

  Scenario: Create Bulk PETS via CSV - with invalid Hub
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
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create ticket by csv in Recovery Tickets page
    And Operator Upload a CSV file Create Tickets Via CSV modal with following data:
      | trackingIds        | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | type               | DM,DM                                                                       |
      | investigationGroup | RCY                                                                         |
      | assigneeEmail      | ekki.syam@ninjavan.co                                                       |
      | investigationHubId | 999999                                                                      |
      | entrySource        | RS                                                                          |
      | ticketNotes        | automation test                                                             |
    Then Operator verifies error message is displayed
      | top           | We are unable to create tickets for following tracking ID(s) |
      | failureReason | Investigating hub is not a valid hub!                        |
      | fileName      | csv_create_tickets_                                          |

  Scenario Outline: Resolve Ticket - ticket_type = DAMAGED - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | DAMAGED                               |
      | orderOutcomeDamaged     | <orderOutcome>                        |
      | parcelLocation          | DAMAGED RACK                          |
      | liability               | Fleet (First Mile)                    |
      | damageDescription       | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "<postStatus>" on Edit Order V2 page
    And Operator verify order granular status is "<postGranularStatus>" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

    Examples:
      | Dataset Name                                           | orderOutcome                           | postStatus | postGranularStatus |
      | order_outcome = NV NOT LIABLE - PARCEL DELIVERED       | NV NOT LIABLE - PARCEL DELIVERED       | Completed  | Completed          |
      | order_outcome = NV LIABLE - PARCEL DISPOSED            | NV LIABLE - PARCEL DISPOSED            | Cancelled  | Cancelled          |
      | order_outcome = NV LIABLE - FULL - PARCEL DELIVERED    | NV LIABLE - FULL - PARCEL DELIVERED    | Completed  | Completed          |
      | order_outcome = NV LIABLE - PARTIAL - PARCEL DELIVERED | NV LIABLE - PARTIAL - PARCEL DELIVERED | Completed  | Completed          |

  Scenario Outline: Resolve Ticket - ticket_type = DAMAGED -RTS- <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | DAMAGED                               |
      | orderOutcomeDamaged     | <orderOutcome>                        |
      | damageDescription       | GENERATED                             |
      | rtsReason               | Dangerous Goods                       |
      | parcelLocation          | DAMAGED RACK                          |
      | liability               | Fleet (First Mile)                    |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "<postStatus>" on Edit Order V2 page
    And Operator verify order granular status is "<postGranularStatus>" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

    Examples:
      | Dataset Name                                  | orderOutcome                  | postStatus | postGranularStatus     |
      | order_outcome = NV NOT LIABLE - RETURN PARCEL | NV NOT LIABLE - RETURN PARCEL | Transit    | Arrived at Sorting Hub |
      | order_outcome = NV LIABLE - RETURN PARCEL     | NV LIABLE - RETURN PARCEL     | Cancelled  | Cancelled              |

  Scenario Outline: Operator Resolve Ticket - ticket_type = MISSING - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | MISSING                               |
      | orderOutcomeMissing     | <orderOutcome>                        |
      | parcelDescription       | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "<postStatus>" on Edit Order V2 page
    And Operator verify order granular status is "<postGranularStatus>" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

    Examples:
      | Dataset Name                                      | orderOutcome                    | postStatus | postGranularStatus      |
      | order_outcome = CUSTOMER RECEIVED                 | CUSTOMER RECEIVED               | Completed  | Completed               |
      | order_outcome = LOST - NO RESPONSE - UNDECLARED   | LOST - NO RESPONSE - UNDECLARED | Transit    | Arrived at Sorting Hub  |
      | order_outcome = LOST - NO RESPONSE - DECLARED     | LOST - NO RESPONSE - DECLARED   | Cancelled  | Cancelled               |
      | order_outcome = FOUND - INBOUND (Parcel Transfer) | FOUND - INBOUND                 | Transit    | On Vehicle for Delivery |


  Scenario Outline: Operator Resolve Ticket - ticket_type = SELF COLLECTION - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                 | DRIVER TURN                           |
      | investigatingDepartment     | Fleet (First Mile)                    |
      | investigatingHub            | {hub-name}                            |
      | ticketType                  | SELF COLLECTION                       |
      | orderOutcomeDuplicateParcel | <orderOutcome>                        |
      | custZendeskId               | 1                                     |
      | shipperZendeskId            | 1                                     |
      | ticketNotes                 | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "<postStatus>" on Edit Order V2 page
    And Operator verify order granular status is "<postGranularStatus>" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

    Examples:
      | Dataset Name                           | orderOutcome           | postStatus | postGranularStatus     |
      | order_outcome = COLLECTED BY CONSIGNEE | COLLECTED BY CONSIGNEE | Completed  | Completed              |
      | order_outcome = RE-DELIVER             | RE-DELIVER             | Transit    | Arrived at Sorting Hub |

  Scenario: Operator Resolve Ticket - ticket_type = SELF COLLECTION - RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                 | DRIVER TURN                           |
      | investigatingDepartment     | Fleet (First Mile)                    |
      | investigatingHub            | {hub-name}                            |
      | ticketType                  | SELF COLLECTION                       |
      | orderOutcomeDuplicateParcel | RTS                                   |
      | rtsReason                   | Unable to find address                |
      | custZendeskId               | 1                                     |
      | shipperZendeskId            | 1                                     |
      | ticketNotes                 | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

  Scenario Outline: Operator Resolve Ticket - ticket_type = PARCEL EXCEPTION - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                   | ROUTE INBOUNDING                      |
      | investigatingDepartment       | Fleet (First Mile)                    |
      | investigatingHub              | {hub-name}                            |
      | ticketType                    | PARCEL EXCEPTION                      |
      | ticketSubType                 | <ticketSubtype>                       |
      | orderOutcomeInaccurateAddress | <orderOutcome>                        |
      | exceptionReason               | GENERATED                             |
      | custZendeskId                 | 1                                     |
      | shipperZendeskId              | 1                                     |
      | ticketNotes                   | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "<postStatus>" on Edit Order V2 page
    And Operator verify order granular status is "<postGranularStatus>" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

    Examples:
      | Dataset Name                                                                   | ticketSubtype               | orderOutcome       | postStatus | postGranularStatus     |
      | ticket_subtype = CANCELLED ORDER - order_outcome = XMAS CAGE                   | CANCELLED ORDER             | XMAS CAGE          | Cancelled  | Cancelled              |
      | ticket_subtype = CUSTOMER REJECTED - order_outcome = RESUME DELIVERY           | CUSTOMER REJECTED           | RESUME DELIVERY    | Transit    | Arrived at Sorting Hub |
      | ticket_subtype = DP OVERSIZED - order_outcome = RESUME DELIVERY                | DP OVERSIZED                | RESUME DELIVERY    | Transit    | Arrived at Sorting Hub |
      | ticket_subtype = INACCURATE ADDRESS - order_outcome = RESUME PICKUP            | INACCURATE ADDRESS          | RESUME PICKUP      | Pending    | Pending Pickup         |
      | ticket_subtype = MAXIMUM ATTEMPTS (DELIVERY) - order_outcome = RESUME DELIVERY | MAXIMUM ATTEMPTS (DELIVERY) | RESUME DELIVERY    | Transit    | Arrived at Sorting Hub |
      | ticket_subtype = MAXIMUM ATTEMPTS (RTS) - order_outcome = RELABELLED TO SEND   | MAXIMUM ATTEMPTS (RTS)      | RELABELLED TO SEND | Completed  | Completed              |
      | ticket_subtype = RESTRICTED ZONES - order_outcome = RESUME DELIVERY            | RESTRICTED ZONES            | RESUME DELIVERY    | Transit    | Arrived at Sorting Hub |
      | ticket_subtype = WRONG AV/RACK/HUB - order_outcome = FIXED AV                  | WRONG AV/RACK/HUB           | FIXED AV           | Transit    | Arrived at Sorting Hub |

  Scenario Outline: Operator Resolve Ticket - ticket_type = PARCEL EXCEPTION -RTS- <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                   | ROUTE INBOUNDING                      |
      | investigatingDepartment       | Fleet (First Mile)                    |
      | investigatingHub              | {hub-name}                            |
      | ticketType                    | PARCEL EXCEPTION                      |
      | ticketSubType                 | <ticketSubtype>                       |
      | orderOutcomeInaccurateAddress | <orderOutcome>                        |
      | rtsReason                     | Nobody at address                     |
      | exceptionReason               | GENERATED                             |
      | custZendeskId                 | 1                                     |
      | shipperZendeskId              | 1                                     |
      | ticketNotes                   | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks Update Ticket button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "<postStatus>" on Edit Order V2 page
    And Operator verify order granular status is "<postGranularStatus>" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

    Examples:
      | Dataset Name                                               | ticketSubtype       | orderOutcome | postStatus | postGranularStatus     |
      | ticket_subtype = COMPLETED ORDER - order_outcome = RTS     | COMPLETED ORDER     | RTS          | Transit    | Arrived at Sorting Hub |
      | ticket_subtype = DISPUTED ORDER INFO - order_outcome = RTS | DISPUTED ORDER INFO | RTS          | Transit    | Arrived at Sorting Hub |

  Scenario Outline: Operator Resolve Ticket - ticket_type = SHIPPER ISSUE - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                 | ROUTE INBOUNDING                      |
      | investigatingDepartment     | Fleet (First Mile)                    |
      | investigatingHub            | {hub-name}                            |
      | ticketType                  | SHIPPER ISSUE                         |
      | ticketSubType               | <ticketSubtype>                       |
      | orderOutcomeDuplicateParcel | <orderOutcome>                        |
      | issueDescription            | GENERATED                             |
      | custZendeskId               | 1                                     |
      | shipperZendeskId            | 1                                     |
      | ticketNotes                 | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "<postStatus>" on Edit Order V2 page
    And Operator verify order granular status is "<postGranularStatus>" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

    Examples:
      | Dataset Name                                                                        | ticketSubtype     | orderOutcome                    | postStatus | postGranularStatus     |
      | ticket_subtype = DUPLICATE PARCEL - order_outcome = REPACKED/RELABELLED TO SEND     | DUPLICATE PARCEL  | REPACKED/RELABELLED TO SEND     | Transit    | Arrived at Sorting Hub |
      | ticket_subtype = NO LABEL - order_outcome = XMAS CAGE                               | NO LABEL          | XMAS CAGE                       | Cancelled  | Cancelled              |
      | ticket_subtype = NO ORDER - order_outcome = ORDERS CREATED                          | NO ORDER          | ORDERS CREATED                  | Transit    | Arrived at Sorting Hub |
      | ticket_subtype = REJECTED RETURN - order_outcome = DAMAGED - NV LIABLE              | REJECTED RETURN   | DAMAGED - NV LIABLE             | Cancelled  | Cancelled              |
      | ticket_subtype = RESTRICTED GOODS - order_outcome = NV Not Liable - PARCEL SCRAPPED | RESTRICTED GOODS  | NV NOT LIABLE - PARCEL SCRAPPED | Completed  | Completed              |
      | ticket_subtype = REQUEST RECEIPT - order_outcome = SENT RECEIPT                     | REQUEST RECEIPT   | SENT RECEIPT                    | Completed  | Completed              |
      | ticket_subtype = POOR LABELLING - order_outcome = RESUME PICKUP                     | POOR LABELLING    | RESUME PICKUP                   | Pending    | Pending Pickup         |
      | ticket_subtype = POOR PACKAGING - order_outcome = NV to Repack and Ship             | POOR PACKAGING    | NV TO REPACK AND SHIP           | Transit    | Arrived at Sorting Hub |
      | ticket_subtype = SUSPICIOUS PARCEL - order_outcome = Parcel Scrapped                | SUSPICIOUS PARCEL | PARCEL SCRAPPED                 | Completed  | Completed              |

  Scenario: Operator Resolve Ticket - ticket_type = SHIPPER ISSUE -RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                 | ROUTE INBOUNDING                      |
      | investigatingDepartment     | Fleet (First Mile)                    |
      | investigatingHub            | {hub-name}                            |
      | ticketType                  | SHIPPER ISSUE                         |
      | ticketSubType               | OVERWEIGHT/OVERSIZED                  |
      | orderOutcomeDuplicateParcel | RTS                                   |
      | rtsReason                   | Nobody at address                     |
      | issueDescription            | GENERATED                             |
      | custZendeskId               | 1                                     |
      | shipperZendeskId            | 1                                     |
      | ticketNotes                 | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

  Scenario Outline:Operator Resolve Ticket - ticket_type = PARCEL ON HOLD - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | ROUTE INBOUNDING                      |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL ON HOLD                        |
      | ticketSubType           | <ticketSubtype>                       |
      | orderOutcome            | <orderOutcome>                        |
      | exceptionReason         | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "<postStatus>" on Edit Order V2 page
    And Operator verify order granular status is "<postGranularStatus>" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

    Examples:
      | Dataset Name                                                                | ticketSubtype                  | orderOutcome    | postStatus | postGranularStatus     |
      | ticket_subtype = SHIPPER REQUEST - order_outcome = RESUME DELIVERY          | SHIPPER REQUEST                | RESUME DELIVERY | Transit    | Arrived at Sorting Hub |
      | ticket_subtype = PAYMENT PENDING (NINJA DIRECT) - order_outcome = XMAS CAGE | PAYMENT PENDING (NINJA DIRECT) | XMAS CAGE       | Cancelled  | Cancelled              |

  Scenario:Operator Resolve Ticket - ticket_type = PARCEL ON HOLD - RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | ROUTE INBOUNDING                      |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL ON HOLD                        |
      | ticketSubType           | CUSTOMER REQUEST                      |
      | orderOutcome            | RTS                                   |
      | rtsReason               | Nobody at address                     |
      | exceptionReason         | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

  Scenario Outline: Operator Resolve Ticket - ticket_type = SLA BREACH - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | DRIVER TURN                           |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | SLA BREACH                            |
      | orderOutcome            | <orderOutcome>                        |
      | breachReason            | Auto breach reason                    |
      | breachLeg               | Forward                               |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator selects "RESOLVED" from ticket status in Edit Ticket dialog
    And Operator clicks "Update Ticket" button in Edit Ticket dialog
    Then Operator verifies ticket is updates to "RESOLVED" status
    And Operator verify the status update event from "PENDING" to "RESOLVED" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "<postStatus>" on Edit Order V2 page
    And Operator verify order granular status is "<postGranularStatus>" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |

    Examples:
      | Dataset Name                          | orderOutcome          | postStatus | postGranularStatus     |
      | order_outcome = NV Liable - XMAS CAGE | NV LIABLE - XMAS CAGE | Cancelled  | Cancelled              |
      | order_outcome = NV Liable - Delivered | NV LIABLE - DELIVERED | Completed  | Completed              |
      | order_outcome = Resume delivery       | RESUME DELIVERY       | Transit    | Arrived at Sorting Hub |

  Scenario Outline: Operator Update Single Ticket - Recovery Ticket - Parcel Exception - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                   | ROUTE INBOUNDING                      |
      | investigatingDepartment       | Fleet (First Mile)                    |
      | investigatingHub              | {hub-name}                            |
      | ticketType                    | PARCEL EXCEPTION                      |
      | ticketSubType                 | COMPLETED ORDER                       |
      | orderOutcomeInaccurateAddress | RELABELLED TO SEND                    |
      | exceptionReason               | GENERATED                             |
      | custZendeskId                 | 1                                     |
      | shipperZendeskId              | 1                                     |
      | ticketNotes                   | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator edit the ticket with the following and verifies it:
      | ticketStatus        | <newTicketStatus>         |
      | orderOutcome        | RELABELLED TO SEND        |
      | assignTo            | Batoul samoudi            |
      | enterNewInstruction | GENERATED                 |
      | investigatingDept   | Recovery                  |
      | investigatingHub    | SORT-2623 up              |
      | customerZendeskID   | RANDOM                    |
      | shipperZendeskID    | RANDOM                    |
      | ticketComments      | Update Ticket For Testing |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Single Ticket - Recovery Ticket - Parcel On Hold - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | ROUTE INBOUNDING                      |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | PARCEL ON HOLD                        |
      | ticketSubType           | PAYMENT PENDING (NINJA DIRECT)        |
      | orderOutcome            | RESUME DELIVERY                       |
      | exceptionReason         | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator edit the ticket with the following and verifies it:
      | ticketStatus        | <newTicketStatus>         |
      | orderOutcome        | XMAS CAGE                 |
      | assignTo            | Batoul samoudi            |
      | enterNewInstruction | GENERATED                 |
      | investigatingDept   | Recovery                  |
      | investigatingHub    | SORT-2623 up              |
      | customerZendeskID   | RANDOM                    |
      | shipperZendeskID    | RANDOM                    |
      | ticketComments      | Update Ticket For Testing |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Single Ticket - Recovery Ticket - Shipper Issue  - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                 | ROUTE INBOUNDING                      |
      | investigatingDepartment     | Fleet (First Mile)                    |
      | investigatingHub            | {hub-name}                            |
      | ticketType                  | SHIPPER ISSUE                         |
      | ticketSubType               | POOR PACKAGING                        |
      | orderOutcomeDuplicateParcel | NV TO REPACK AND SHIP                 |
      | issueDescription            | GENERATED                             |
      | custZendeskId               | 1                                     |
      | shipperZendeskId            | 1                                     |
      | ticketNotes                 | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator edit the ticket with the following and verifies it:
      | ticketStatus        | <newTicketStatus>         |
      | orderOutcome        | CONFISCATED BY CUSTOMS    |
      | assignTo            | Batoul samoudi            |
      | enterNewInstruction | GENERATED                 |
      | investigatingDept   | Recovery                  |
      | investigatingHub    | SORT-2623 up              |
      | customerZendeskID   | RANDOM                    |
      | shipperZendeskID    | RANDOM                    |
      | ticketComments      | Update Ticket For Testing |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Single Ticket - Recovery Ticket - Missing - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | MISSING                               |
      | orderOutcomeMissing     | FOUND - INBOUND                       |
      | parcelDescription       | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator edit the ticket with the following and verifies it:
      | ticketStatus        | <newTicketStatus>         |
      | orderOutcome        | CUSTOMER RECEIVED         |
      | assignTo            | Batoul samoudi            |
      | enterNewInstruction | GENERATED                 |
      | investigatingDept   | Recovery                  |
      | investigatingHub    | SORT-2623 up              |
      | customerZendeskID   | RANDOM                    |
      | shipperZendeskID    | RANDOM                    |
      | ticketComments      | Update Ticket For Testing |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Single Ticket - Recovery Ticket - Damaged - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | CUSTOMER COMPLAINT                    |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | DAMAGED                               |
      | orderOutcomeDamaged     | NV LIABLE - FULL - PARCEL DELIVERED   |
      | parcelLocation          | DAMAGED RACK                          |
      | liability               | Fleet (First Mile)                    |
      | damageDescription       | GENERATED                             |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator edit the ticket with the following and verifies it:
      | ticketStatus        | <newTicketStatus>           |
      | orderOutcome        | NV LIABLE - PARCEL DISPOSED |
      | assignTo            | Batoul samoudi              |
      | enterNewInstruction | GENERATED                   |
      | investigatingDept   | Recovery                    |
      | investigatingHub    | SORT-2623 up                |
      | customerZendeskID   | RANDOM                      |
      | shipperZendeskID    | RANDOM                      |
      | ticketComments      | Update Ticket For Testing   |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Single Ticket - Recovery Ticket - Self Collection - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                 | DRIVER TURN                           |
      | investigatingDepartment     | Fleet (First Mile)                    |
      | investigatingHub            | {hub-name}                            |
      | ticketType                  | SELF COLLECTION                       |
      | orderOutcomeDuplicateParcel | COLLECTED BY CONSIGNEE                |
      | custZendeskId               | 1                                     |
      | shipperZendeskId            | 1                                     |
      | ticketNotes                 | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator edit the ticket with the following and verifies it:
      | ticketStatus        | <newTicketStatus>         |
      | orderOutcome        | COLLECTED BY SHIPPER      |
      | assignTo            | Batoul samoudi            |
      | enterNewInstruction | GENERATED                 |
      | investigatingDept   | Recovery                  |
      | investigatingHub    | SORT-2623 up              |
      | customerZendeskID   | RANDOM                    |
      | shipperZendeskID    | RANDOM                    |
      | ticketComments      | Update Ticket For Testing |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Single Ticket - Recovery Ticket - SLA BREACH - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource             | DRIVER TURN                           |
      | investigatingDepartment | Fleet (First Mile)                    |
      | investigatingHub        | {hub-name}                            |
      | ticketType              | SLA BREACH                            |
      | orderOutcome            | NV LIABLE - DELIVERED                 |
      | breachReason            | Auto breach reason                    |
      | breachLeg               | Forward                               |
      | custZendeskId           | 1                                     |
      | shipperZendeskId        | 1                                     |
      | ticketNotes             | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator edit the ticket with the following and verifies it:
      | ticketStatus        | <newTicketStatus>         |
      | orderOutcome        | RESUME DELIVERY           |
      | assignTo            | Batoul samoudi            |
      | enterNewInstruction | GENERATED                 |
      | investigatingDept   | Recovery                  |
      | investigatingHub    | SORT-2623 up              |
      | customerZendeskID   | RANDOM                    |
      | shipperZendeskID    | RANDOM                    |
      | ticketComments      | Update Ticket For Testing |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Resolve Bulk Ticket - ticket_type = PARCEL ON HOLD - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | PARCEL ON HOLD                        |
      | subTicketType      | <ticketSubtype>                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (<ticketSubtype>)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | PARCEL ON HOLD                        |
      | subTicketType      | <ticketSubtype>                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (<ticketSubtype>)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | RESOLVED          |
      | orderOutcome            | <orderOutcome>    |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    And Operator Add "Created At" filter
    And Operator search created ticket by "Ticket Status" filter with values:
      | RESOLVED |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType/subType  | PARCEL ON HOLD : <ticketSubtype>      |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType/subType  | PARCEL ON HOLD : <ticketSubtype>      |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |

    Examples:
      | Dataset Name                                                                | ticketSubtype                  | orderOutcome    | postGranularStatus     |
      | ticket_subtype = CUSTOMER REQUEST - order_outcome = RTS                     | CUSTOMER REQUEST               | RTS             | Arrived at Sorting Hub |
      | ticket_subtype = SHIPPER REQUEST - order_outcome = RESUME DELIVERY          | SHIPPER REQUEST                | RESUME DELIVERY | Arrived at Sorting Hub |
      | ticket_subtype = PAYMENT PENDING (NINJA DIRECT) - order_outcome = XMAS CAGE | PAYMENT PENDING (NINJA DIRECT) | XMAS CAGE       | Cancelled              |

  Scenario Outline: Operator Resolve Bulk Ticket - ticket_type = SLA BREACH - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | SLA BREACH                            |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (SLA BREACH)            |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | SLA BREACH                            |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (SLA BREACH)            |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | RESOLVED          |
      | orderOutcome            | <orderOutcome>    |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    And Operator Add "Created At" filter
    And Operator search created ticket by "Ticket Status" filter with values:
      | RESOLVED |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType/subType  | SLA BREACH                            |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType/subType  | SLA BREACH                            |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |

    Examples:
      | Dataset Name                                   | orderOutcome                   | postGranularStatus     |
      | order_outcome = NV Liable - XMAS CAGE          | NV LIABLE - XMAS CAGE          | Cancelled              |
      | order_outcome = Resume delivery                | RESUME DELIVERY                | Arrived at Sorting Hub |
      | order_outcome = NV Liable - Delivered          | NV LIABLE - DELIVERED          | Completed              |
      | order_outcome = NV Liable - XMAS CAGE (Tiktok) | NV LIABLE - XMAS CAGE (TIKTOK) | Cancelled              |

  Scenario Outline: Operator Resolve Bulk Ticket - ticket_type = DAMAGED - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | DAMAGED                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (DAMAGED)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | DAMAGED                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (DAMAGED)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | RESOLVED          |
      | orderOutcome            | <orderOutcome>    |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    And Operator Add "Created At" filter
    And Operator search created ticket by "Ticket Status" filter with values:
      | RESOLVED |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType/subType  | DAMAGED                               |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType/subType  | DAMAGED                               |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |

    Examples:
      | Dataset Name                                              | orderOutcome                              | postGranularStatus     |
      | order_outcome = NV Liable - PARCEL DISPOSED               | NV LIABLE - PARCEL DISPOSED               | Cancelled              |
      | order_outcome = NV LIABLE - RETURN PARCEL                 | NV LIABLE - RETURN PARCEL                 | Arrived at Sorting Hub |
      | order_outcome = NV LIABLE - FULL - PARCEL DELIVERED       | NV LIABLE - FULL - PARCEL DELIVERED       | Completed              |
      | order_outcome = NV LIABLE - PARTIAL - PARCEL DELIVERED    | NV LIABLE - PARTIAL - PARCEL DELIVERED    | Completed              |
      | order_outcome = NV LIABLE - PARTIAL - RESUME DELIVERY     | NV LIABLE - PARTIAL - RESUME DELIVERY     | Arrived at Sorting Hub |
      | order_outcome = NV NOT LIABLE - PARTIAL - RESUME DELIVERY | NV NOT LIABLE - PARTIAL - RESUME DELIVERY | Arrived at Sorting Hub |

  Scenario Outline: Operator Resolve Bulk Ticket - ticket_type = MISSING - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | MISSING                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | MISSING                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | RESOLVED          |
      | orderOutcome            | <orderOutcome>    |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    And Operator Add "Created At" filter
    And Operator search created ticket by "Ticket Status" filter with values:
      | RESOLVED |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType/subType  | MISSING                               |
      | orderGranularStatus | Cancelled                             |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType/subType  | MISSING                               |
      | orderGranularStatus | Cancelled                             |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |

    Examples:
      | Dataset Name                                  | orderOutcome                  |
      | order_outcome = LOST - DECLARED               | LOST - DECLARED               |
      | order_outcome = LOST - NO RESPONSE - DECLARED | LOST - NO RESPONSE - DECLARED |

  Scenario Outline: Operator Resolve Bulk Ticket - ticket_type = SELF COLLECTION - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | SELF COLLECTION                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (SELF COLLECTION)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | SELF COLLECTION                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (SELF COLLECTION)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | RESOLVED          |
      | orderOutcome            | <orderOutcome>    |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    And Operator Add "Created At" filter
    And Operator search created ticket by "Ticket Status" filter with values:
      | RESOLVED |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType/subType  | SELF COLLECTION                       |
      | orderGranularStatus | Completed                             |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType/subType  | SELF COLLECTION                       |
      | orderGranularStatus | Completed                             |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |

    Examples:
      | Dataset Name                           | orderOutcome           |
      | order_outcome = PARCEL SCRAPPED        | PARCEL SCRAPPED        |
      | order_outcome = COLLECTED BY SHIPPER   | COLLECTED BY SHIPPER   |
      | order_outcome = COLLECTED BY CONSIGNEE | COLLECTED BY CONSIGNEE |

  Scenario Outline: Operator Resolve Bulk Ticket - ticket_type = PARCEL EXCEPTION - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | PARCEL EXCEPTION                      |
      | subTicketType      | INACCURATE ADDRESS                    |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (INACCURATE ADDRESS)    |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | PARCEL EXCEPTION                      |
      | subTicketType      | INACCURATE ADDRESS                    |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (INACCURATE ADDRESS)    |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | RESOLVED          |
      | orderOutcome            | <orderOutcome>    |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    And Operator Add "Created At" filter
    And Operator search created ticket by "Ticket Status" filter with values:
      | RESOLVED |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType/subType  | PARCEL EXCEPTION : INACCURATE ADDRESS |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType/subType  | PARCEL EXCEPTION : INACCURATE ADDRESS |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |

    Examples:
      | Dataset Name                    | orderOutcome    | postGranularStatus     |
      | order_outcome = RESUME DELIVERY | RESUME DELIVERY | Arrived at Sorting Hub |
      | order_outcome = RTS             | RTS             | Arrived at Sorting Hub |
      | order_outcome = RESUME PICKUP   | RESUME PICKUP   | Pending Pickup         |

  Scenario Outline: Operator Resolve Bulk Ticket - ticket_type = SHIPPER ISSUE - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | SHIPPER ISSUE                         |
      | subTicketType      | <ticketSubtype>                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (<ticketSubtype>)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | SHIPPER ISSUE                         |
      | subTicketType      | <ticketSubtype>                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (<ticketSubtype>)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | RESOLVED          |
      | orderOutcome            | <orderOutcome>    |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    And Operator Add "Created At" filter
    And Operator search created ticket by "Ticket Status" filter with values:
      | RESOLVED |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType/subType  | SHIPPER ISSUE : <ticketSubtype>       |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |
    When Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Then Operator verifies correct ticket details as following:
      | trackingId          | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType/subType  | SHIPPER ISSUE : <ticketSubtype>       |
      | orderGranularStatus | <postGranularStatus>                  |
      | investigatingDept   | Recovery                              |
      | investigatingHub    | {hub-name}                            |
      | status              | RESOLVED                              |
      | assignee            | AUTOMATION EDITED                     |

    Examples:
      | Dataset Name                                                           | ticketSubtype     | orderOutcome        | postGranularStatus     |
      | ticket_subtype = REJECTED RETURN - order_outcome = DAMAGED - NV LIABLE | REJECTED RETURN   | DAMAGED - NV LIABLE | Cancelled              |
      | ticket_subtype = REJECTED RETURN - order_outcome = MISSING - NV LIABLE | REJECTED RETURN   | MISSING - NV LIABLE | Cancelled              |
      | ticket_subtype = SUSPICIOUS PARCEL - order_outcome = RESUME DELIVERY   | SUSPICIOUS PARCEL | RESUME DELIVERY     | Arrived at Sorting Hub |
      | ticket_subtype = SUSPICIOUS PARCEL - order_outcome = PARCEL SCRAPPED   | SUSPICIOUS PARCEL | PARCEL SCRAPPED     | Completed              |

  Scenario Outline: Operator Update Bulk Ticket - Recovery Ticket - Parcel Exception - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | PARCEL EXCEPTION                      |
      | subTicketType      | COMPLETED ORDER                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (COMPLETED ORDER)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | PARCEL EXCEPTION                      |
      | subTicketType      | COMPLETED ORDER                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (COMPLETED ORDER)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | <newTicketStatus>  |
      | orderOutcome            | RELABELLED TO SEND |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | assignee                | AUTOMATION EDITED  |
      | ticketComment           | GENERATED          |
      | newInstruction          | GENERATED          |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus>  |
      | orderOutcome      | RELABELLED TO SEND |
      | investigatingDept | Recovery           |
      | investigatingHub  | {hub-name}         |
      | assignTo          | AUTOMATION EDITED  |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal
    And Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus>  |
      | orderOutcome      | RELABELLED TO SEND |
      | investigatingDept | Recovery           |
      | investigatingHub  | {hub-name}         |
      | assignTo          | AUTOMATION EDITED  |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending         | PENDING         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Bulk Ticket - Recovery Ticket - Parcel On Hold - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}          |
      | ticketType         | PARCEL ON HOLD                                 |
      | subTicketType      | PAYMENT PENDING (NINJA DIRECT)                 |
      | entrySource        | RECOVERY SCANNING                              |
      | orderOutcomeName   | ORDER OUTCOME (PAYMENT PENDING (NINJA DIRECT)) |
      | investigatingParty | 456                                            |
      | investigatingHubId | {hub-id}                                       |
      | creatorUserId      | 117472837373252971898                          |
      | creatorUserName    | Ekki Syam                                      |
      | creatorUserEmail   | ekki.syam@ninjavan.co                          |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}          |
      | ticketType         | PARCEL ON HOLD                                 |
      | subTicketType      | PAYMENT PENDING (NINJA DIRECT)                 |
      | entrySource        | RECOVERY SCANNING                              |
      | orderOutcomeName   | ORDER OUTCOME (PAYMENT PENDING (NINJA DIRECT)) |
      | investigatingParty | 456                                            |
      | investigatingHubId | {hub-id}                                       |
      | creatorUserId      | 117472837373252971898                          |
      | creatorUserName    | Ekki Syam                                      |
      | creatorUserEmail   | ekki.syam@ninjavan.co                          |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | <newTicketStatus> |
      | orderOutcome            | XMAS CAGE         |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus> |
      | orderOutcome      | XMAS CAGE         |
      | investigatingDept | Recovery          |
      | investigatingHub  | {hub-name}        |
      | assignTo          | AUTOMATION EDITED |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal
    And Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus>  |
      | orderOutcome      | RELABELLED TO SEND |
      | investigatingDept | Recovery           |
      | investigatingHub  | {hub-name}         |
      | assignTo          | AUTOMATION EDITED  |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending         | PENDING         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Bulk Ticket - Recovery Ticket - Shipper Issue - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | SHIPPER ISSUE                         |
      | subTicketType      | REJECTED RETURN                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (REJECTED RETURN)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | SHIPPER ISSUE                         |
      | subTicketType      | REJECTED RETURN                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (REJECTED RETURN)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | <newTicketStatus> |
      | orderOutcome            | RTS               |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus> |
      | orderOutcome      | RTS               |
      | investigatingDept | Recovery          |
      | investigatingHub  | {hub-name}        |
      | assignTo          | AUTOMATION EDITED |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal
    And Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus> |
      | orderOutcome      | RTS               |
      | investigatingDept | Recovery          |
      | investigatingHub  | {hub-name}        |
      | assignTo          | AUTOMATION EDITED |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending         | PENDING         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Bulk Ticket - Recovery Ticket - Missing - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | MISSING                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | MISSING                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | <newTicketStatus> |
      | orderOutcome            | CUSTOMER RECEIVED |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus> |
      | orderOutcome      | CUSTOMER RECEIVED |
      | investigatingDept | Recovery          |
      | investigatingHub  | {hub-name}        |
      | assignTo          | AUTOMATION EDITED |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal
    And Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus> |
      | orderOutcome      | CUSTOMER RECEIVED |
      | investigatingDept | Recovery          |
      | investigatingHub  | {hub-name}        |
      | assignTo          | AUTOMATION EDITED |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending         | PENDING         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Bulk Ticket - Recovery Ticket - Damaged - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | DAMAGED                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (DAMAGED)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | DAMAGED                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (DAMAGED)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | <newTicketStatus>           |
      | orderOutcome            | NV LIABLE - PARCEL DISPOSED |
      | investigatingDepartment | Recovery                    |
      | investigatingHub        | {hub-name}                  |
      | assignee                | AUTOMATION EDITED           |
      | ticketComment           | GENERATED                   |
      | newInstruction          | GENERATED                   |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus>           |
      | orderOutcome      | NV LIABLE - PARCEL DISPOSED |
      | investigatingDept | Recovery                    |
      | investigatingHub  | {hub-name}                  |
      | assignTo          | AUTOMATION EDITED           |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal
    And Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus>           |
      | orderOutcome      | NV LIABLE - PARCEL DISPOSED |
      | investigatingDept | Recovery                    |
      | investigatingHub  | {hub-name}                  |
      | assignTo          | AUTOMATION EDITED           |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending         | PENDING         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Bulk Ticket - Recovery Ticket - Damaged - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | DAMAGED                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (DAMAGED)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | DAMAGED                               |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (DAMAGED)               |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | <newTicketStatus>           |
      | orderOutcome            | NV LIABLE - PARCEL DISPOSED |
      | investigatingDepartment | Recovery                    |
      | investigatingHub        | {hub-name}                  |
      | assignee                | AUTOMATION EDITED           |
      | ticketComment           | GENERATED                   |
      | newInstruction          | GENERATED                   |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus>           |
      | orderOutcome      | NV LIABLE - PARCEL DISPOSED |
      | investigatingDept | Recovery                    |
      | investigatingHub  | {hub-name}                  |
      | assignTo          | AUTOMATION EDITED           |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal
    And Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus>           |
      | orderOutcome      | NV LIABLE - PARCEL DISPOSED |
      | investigatingDept | Recovery                    |
      | investigatingHub  | {hub-name}                  |
      | assignTo          | AUTOMATION EDITED           |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending         | PENDING         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Bulk Ticket - Recovery Ticket - Self Collection - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | SELF COLLECTION                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (SELF COLLECTION)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | SELF COLLECTION                       |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (SELF COLLECTION)       |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | <newTicketStatus> |
      | orderOutcome            | COLLECTED         |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus> |
      | orderOutcome      | COLLECTED         |
      | investigatingDept | Recovery          |
      | investigatingHub  | {hub-name}        |
      | assignTo          | AUTOMATION EDITED |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal
    And Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus> |
      | orderOutcome      | COLLECTED         |
      | investigatingDept | Recovery          |
      | investigatingHub  | {hub-name}        |
      | assignTo          | AUTOMATION EDITED |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending         | PENDING         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario Outline: Operator Update Bulk Ticket - Recovery Ticket - SLA BREACH - <Dataset Name>
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | ticketType         | SLA BREACH                            |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (SLA BREACH)            |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | ticketType         | SLA BREACH                            |
      | entrySource        | RECOVERY SCANNING                     |
      | orderOutcomeName   | ORDER OUTCOME (SLA BREACH)            |
      | investigatingParty | 456                                   |
      | investigatingHubId | {hub-id}                              |
      | creatorUserId      | 117472837373252971898                 |
      | creatorUserName    | Ekki Syam                             |
      | creatorUserEmail   | ekki.syam@ninjavan.co                 |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator clicks "Clear all selections" button on Recovery Tickets Page
    And Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator clicks "Select All Shown" button on Recovery Tickets Page
    And Operator clicks "Bulk Update" button on Recovery Tickets Page
    When Operator bulk update tickets on new page Recovery Tickets using data below:
      | ticketStatus            | <newTicketStatus> |
      | orderOutcome            | RESUME DELIVERY   |
      | investigatingDepartment | Recovery          |
      | investigatingHub        | {hub-name}        |
      | assignee                | AUTOMATION EDITED |
      | ticketComment           | GENERATED         |
      | newInstruction          | GENERATED         |
    And Operator clicks "Edit Filter" button on Recovery Tickets Page
    When Operator click Find Tickets By CSV on Recovery Tickets Page
    And Operator upload a csv on Find Tickets By CSV dialog
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus> |
      | orderOutcome      | RESUME DELIVERY   |
      | investigatingDept | Recovery          |
      | investigatingHub  | {hub-name}        |
      | assignTo          | AUTOMATION EDITED |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal
    And Operator clear the filter search
    And Operator filter search result by field "Tracking ID" with value "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And Operator click ticket's action button
    Then Operator verifies updated recovery ticket
      | ticketStatus      | <newTicketStatus> |
      | orderOutcome      | RESUME DELIVERY   |
      | investigatingDept | Recovery          |
      | investigatingHub  | {hub-name}        |
      | assignTo          | AUTOMATION EDITED |
    And Operator verify the status update event from "PENDING" to "<newTicketStatus>" by "QA Ninja" is recorded correctly
    When Operator close Edit Ticket Modal

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET UPDATED |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                            |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: <newTicketStatus> |

    Examples:
      | Dataset Name                        | newTicketStatus |
      | New Ticket Status = In Progress     | IN PROGRESS     |
      | New Ticket Status = On Hold         | ON HOLD         |
      | New Ticket Status = Pending         | PENDING         |
      | New Ticket Status = Pending Shipper | PENDING SHIPPER |

  Scenario: Operator Update Single Ticket - Recovery Ticket - Cancel Ticket
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on new page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                   | ROUTE INBOUNDING                      |
      | investigatingDepartment       | Fleet (First Mile)                    |
      | investigatingHub              | {hub-name}                            |
      | ticketType                    | PARCEL EXCEPTION                      |
      | ticketSubType                 | COMPLETED ORDER                       |
      | orderOutcomeInaccurateAddress | RELABELLED TO SEND                    |
      | exceptionReason               | GENERATED                             |
      | custZendeskId                 | 1                                     |
      | shipperZendeskId              | 1                                     |
      | ticketNotes                   | GENERATED                             |
    When Operator search created ticket by "Tracking ID" filter with values:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator click ticket's action button
    And Operator clicks "Cancel Ticket" button in Edit Ticket dialog
    Then Operator verifies Cancel Ticket dialog
    When Operator clicks Delete button in Cancel Ticket dialog
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order events on Edit Order V2 page using data below:
      | name            |
      | TICKET RESOLVED |
      | TICKET UPDATED  |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"]} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           | description                                                                    |
      | MANUAL ACTION | TICKET UPDATED | Ticket ID: {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}\nTicket status: CANCELLED |
