@RecoveryTickets @selenium
Feature: Recovery Tickets

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Create damage ticket on Recovery Tickets menu
    Given op click navigation Recovery Tickets in Recovery
    When op create new ticket on Recovery Tickets menu with this property below:
      | entrySource        | CUSTOMER COMPLAINT        |
      | investigatingParty | DISTRIBUTION POINTS       |
      | ticketType         | DAMAGED                   |
      | ticketSubType      | IMPROPER PACKAGING        |
      | parcelLocation     | DAMAGED RACK              |
      | liability          | NV DRIVER                 |
      | damageDescription  | Dummy damage description. |
      | ticketNotes        | Dummy ticket notes.       |
      | custZendeskId      | 1                         |
      | shipperZendeskId   | 1                         |
      | orderOutcome       | PENDING                   |
      | comments           | Dummy damage ticket.      |
    Then verify ticket is created successfully

  Scenario: Create missing ticket on Recovery Tickets menu
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Recovery Tickets in Recovery
    When op create new ticket on Recovery Tickets menu with this property below:
      | entrySource        | CUSTOMER COMPLAINT        |
      | investigatingParty | DISTRIBUTION POINTS       |
      | ticketType         | MISSING                   |
      | parcelDescription  | Dummy parcel description. |
      | ticketNotes        | Dummy ticket notes.       |
      | custZendeskId      | 1                         |
      | shipperZendeskId   | 1                         |
      | comments           | Dummy missing ticket.     |
    Then verify ticket is created successfully

  @KillBrowser
  Scenario: Kill Browser
