@OperatorV2 @OperatorV2Part1 @RecoveryTickets @Saas
Feature: Recovery Tickets

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create damage ticket on Recovery Tickets menu (uid:43d733f5-61e2-4877-82c2-ae1ac3220a2b)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | DAMAGED            |
      | ticketSubType           | IMPROPER PACKAGING |
      | parcelLocation          | DAMAGED RACK       |
      | liability               | NV DRIVER          |
      | damageDescription       | GENERATED          |
      | orderOutcomeDamaged     | NV LIABLE - FULL   |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    Then Operator verify ticket is created successfully on page Recovery Tickets

  Scenario: Create missing ticket on Recovery Tickets menu (uid:dc66d575-0700-44c8-a4bc-2787a5616e64)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    Then Operator verify ticket is created successfully on page Recovery Tickets

  Scenario: Create parcel exception ticket on Recovery Tickets menu
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                    | ROUTE CLEANING     |
      | investigatingDepartment        | Fleet (First Mile) |
      | investigatingHub               | {hub-name}         |
      | ticketType                     | PARCEL EXCEPTION   |
      | ticketSubType                  | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress  | RTS                |
      | exceptionReason                | GENERATED          |
      | custZendeskId                  | 1                  |
      | shipperZendeskId               | 1                  |
      | ticketNotes                    | GENERATED          |
    Then Operator verify ticket is created successfully on page Recovery Tickets

  Scenario: Create shipper issue ticket on Recovery Tickets menu
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                    | DRIVER TURN        |
      | investigatingDepartment        | Fleet (First Mile) |
      | investigatingHub               | {hub-name}         |
      | ticketType                     | SHIPPER ISSUE      |
      | ticketSubType                  | DUPLICATE PARCEL   |
      | orderOutcomeDuplicateParcel    | RTS                |
      | issueDescription               | GENERATED          |
      | custZendeskId                  | 1                  |
      | shipperZendeskId               | 1                  |
      | ticketNotes                    | GENERATED          |
    Then Operator verify ticket is created successfully on page Recovery Tickets

  Scenario: Delete damaged recovery ticket
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | DAMAGED            |
      | ticketSubType           | IMPROPER PACKAGING |
      | parcelLocation          | DAMAGED RACK       |
      | liability               | NV DRIVER          |
      | damageDescription       | GENERATED          |
      | orderOutcomeDamaged     | NV LIABLE - FULL   |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    And Operator clicks on Cancel Ticket
    And Operator clicks on Delete on pop up
    Then Operator verifies that the status of ticket is "Cancelled"

  Scenario: Edit all field and additional setting for recovery ticket type --> Damaged
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | DAMAGED            |
      | ticketSubType           | IMPROPER PACKAGING |
      | parcelLocation          | DAMAGED RACK       |
      | liability               | NV DRIVER          |
      | damageDescription       | GENERATED          |
      | orderOutcomeDamaged     | NV LIABLE - FULL   |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator edits the ticket settings with below data and verifies it:
      | ticketStatus            | IN PROGRESS        |
      | orderOutcome            | NV LIABLE - FULL   |
      | assignTo                | NikoSusanto        |
      | enterNewInstruction     | GENERATED          |
    Then Operator edits the Additional settings with below data and verifies it:
      | customerZendeskId       | RANDOM             |
      | shipperZendeskId        | RANDOM             |
      | ticketComments          | GENERATED          |

  Scenario: Edit all field and additional setting for recovery ticket type --> Missing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator edits the ticket settings with below data and verifies it:
      | ticketStatus            | IN PROGRESS        |
      | orderOutcome            | FOUND - INBOUND    |
      | assignTo                | NikoSusanto        |
      | enterNewInstruction     | GENERATED          |
    Then Operator edits the Additional settings with below data and verifies it:
      | customerZendeskId       | RANDOM             |
      | shipperZendeskId        | RANDOM             |
      | ticketComments          | GENERATED          |

  Scenario: Edit all field and additional setting for recovery ticket type --> Parcel Exception
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                    | ROUTE CLEANING     |
      | investigatingDepartment        | Fleet (First Mile) |
      | investigatingHub               | {hub-name}         |
      | ticketType                     | PARCEL EXCEPTION   |
      | ticketSubType                  | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress  | RTS                |
      | exceptionReason                | GENERATED          |
      | custZendeskId                  | 1                  |
      | shipperZendeskId               | 1                  |
      | ticketNotes                    | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator edits the ticket settings with below data and verifies it:
      | ticketStatus            | IN PROGRESS        |
      | orderOutcome            | RESUME DELIVERY    |
      | assignTo                | NikoSusanto        |
      | enterNewInstruction     | GENERATED          |
    Then Operator edits the Additional settings with below data and verifies it:
      | customerZendeskId       | RANDOM             |
      | shipperZendeskId        | RANDOM             |
      | ticketComments          | GENERATED          |

  Scenario: Edit all field and additional setting for recovery ticket type --> Shipper Issue
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                    | DRIVER TURN        |
      | investigatingDepartment        | Fleet (First Mile) |
      | investigatingHub               | {hub-name}         |
      | ticketType                     | SHIPPER ISSUE      |
      | ticketSubType                  | DUPLICATE PARCEL   |
      | orderOutcomeDuplicateParcel    | RTS                |
      | issueDescription               | GENERATED          |
      | custZendeskId                  | 1                  |
      | shipperZendeskId               | 1                  |
      | ticketNotes                    | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator edits the ticket settings with below data and verifies it:
      | ticketStatus            | IN PROGRESS        |
      | orderOutcome            | RTS                |
      | assignTo                | NikoSusanto        |
      | enterNewInstruction     | GENERATED          |
    Then Operator edits the Additional settings with below data and verifies it:
      | customerZendeskId       | RANDOM             |
      | shipperZendeskId        | RANDOM             |
      | ticketComments          | GENERATED          |

  Scenario: Update ticket status to Resolved --> Damaged
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | DAMAGED            |
      | ticketSubType           | IMPROPER PACKAGING |
      | parcelLocation          | DAMAGED RACK       |
      | liability               | NV DRIVER          |
      | damageDescription       | GENERATED          |
      | orderOutcomeDamaged     | NV LIABLE - FULL   |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator changes the ticket status to "RESOLVED"
    And Operator updates the ticket
    Then Operator verifies that the status of ticket is "Resolved"

  Scenario: Update ticket status to Resolved --> Missing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator changes the ticket status to "RESOLVED"
    And Operator updates the ticket
    Then Operator verifies that the status of ticket is "Resolved"

  Scenario: Update ticket status to Resolved --> Parcel Exception
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                    | ROUTE CLEANING     |
      | investigatingDepartment        | Fleet (First Mile) |
      | investigatingHub               | {hub-name}         |
      | ticketType                     | PARCEL EXCEPTION   |
      | ticketSubType                  | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress  | RTS                |
      | exceptionReason                | GENERATED          |
      | custZendeskId                  | 1                  |
      | shipperZendeskId               | 1                  |
      | ticketNotes                    | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator changes the ticket status to "RESOLVED"
    And Operator updates the ticket
    Then Operator verifies that the status of ticket is "Resolved"

  Scenario: Update ticket status to Resolved --> Shipper Issue
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                    | DRIVER TURN        |
      | investigatingDepartment        | Fleet (First Mile) |
      | investigatingHub               | {hub-name}         |
      | ticketType                     | SHIPPER ISSUE      |
      | ticketSubType                  | DUPLICATE PARCEL   |
      | orderOutcomeDuplicateParcel    | RTS                |
      | issueDescription               | GENERATED          |
      | custZendeskId                  | 1                  |
      | shipperZendeskId               | 1                  |
      | ticketNotes                    | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator changes the ticket status to "RESOLVED"
    And Operator updates the ticket
    Then Operator verifies that the status of ticket is "Resolved"


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op



