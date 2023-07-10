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
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op

