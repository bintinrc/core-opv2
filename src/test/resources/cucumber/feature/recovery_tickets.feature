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

  Scenario: Create parcel exception ticket on Recovery Tickets menu (uid:22fe023b-3db9-4572-9ea2-11fc6d4bc8dc)
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

  Scenario: Create shipper issue ticket on Recovery Tickets menu (uid:5571d314-7b79-4376-9f7a-bab503424680)
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

  Scenario: Delete damaged recovery ticket (uid:700caae8-5879-49a8-b94d-32fa97ecfc7b)
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

  Scenario: Edit all field and additional setting for recovery ticket type --> Damaged (uid:2799adb1-5d83-45d3-b0f7-3230b851a25c)
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

  Scenario: Edit all field and additional setting for recovery ticket type --> Missing (uid:883d157a-2edd-4ae9-aa87-c3a006786746)
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

  Scenario: Edit all field and additional setting for recovery ticket type --> Parcel Exception (uid:19e4f152-9201-4a16-85a5-3c328d9f6638)
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

  Scenario: Edit all field and additional setting for recovery ticket type --> Shipper Issue (uid:c1ad3626-da33-416e-9e67-4fede917fa5d)
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

  Scenario: Update ticket status to Resolved --> Damaged (uid:922222d2-b127-438c-bd64-512a32725364)
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
    Then Operator changes the ticket status to Resloved
    And Operator updates the ticket
    Then Operator verifies that the status of ticket is "Resolved"

  Scenario: Update ticket status to Resolved --> Missing (uid:da860206-73e3-4f47-8e69-11f3a9f6c75a)
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
    Then Operator changes the ticket status to Resloved
    And Operator updates the ticket
    Then Operator verifies that the status of ticket is "Resolved"

  Scenario: Update ticket status to Resolved --> Parcel Exception (uid:3dce292d-647d-40ee-974b-613c0ddfe960)
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
    Then Operator changes the ticket status to Resloved
    And Operator updates the ticket
    Then Operator verifies that the status of ticket is "Resolved"

  Scenario: Update ticket status to Resolved --> Shipper Issue (uid:25620406-8d3b-40c9-87b5-e373530d2144)
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
    Then Operator changes the ticket status to Resloved
    And Operator updates the ticket
    Then Operator verifies that the status of ticket is "Resolved"

  Scenario: Filter ticket status - Ticket status using Cancelled (uid:a6a23faa-1dc2-4dc9-9b34-839c70b51069)
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
    And Operator clicks on Edit Filters button
    When Operator removes all ticket status filters
    Then Operator chooses the ticket status as "CANCELLED"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter ticket status - Ticket status using In Progress (uid:8e9bca26-06f1-4582-a10a-b1d6c52cc553)
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
    And Operator changes the ticket status to "IN PROGRESS"
    And Operator clicks on Edit Filters button
    When Operator removes all ticket status filters
    Then Operator chooses the ticket status as "IN PROGRESS"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter ticket status - Ticket status using On Hold (uid:fddf9885-d797-40ce-a3d9-306cc06c8e21)
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
    And Operator changes the ticket status to "ON HOLD"
    And Operator clicks on Edit Filters button
    When Operator removes all ticket status filters
    Then Operator chooses the ticket status as "ON HOLD"
    And Operator enters the tracking id and verifies that is exists

 # Scenario: Filter ticket status - Ticket status using Pending (uid:b92e97ae-1bfd-4c8c-859c-d51cb3e8bbba)
  #  Given API Shipper create V4 order using data below:
  #   | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
  #    | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
  #  Given Operator go to menu Shipper Support -> Blocked Dates
  #  Given Operator go to menu Recovery -> Recovery Tickets
  #  When Operator create new ticket on page Recovery Tickets using data below:
  #    | entrySource             | CUSTOMER COMPLAINT |
  #    | investigatingDepartment | Fleet (First Mile) |
  #    | investigatingHub        | {hub-name}         |
  #    | ticketType              | MISSING            |
  #    | orderOutcomeMissing     | LOST - DECLARED    |
  #    | parcelDescription       | GENERATED          |
  #    | custZendeskId           | 1                  |
  #    | shipperZendeskId        | 1                  |
  #    | ticketNotes             | GENERATED          |
  #  When Operator removes all ticket status filters
  #  Then Operator chooses the ticket status as "PENDING"
  #  And Operator enters the tracking id and verifies that is exists

  Scenario: Filter ticket status - Ticket status using Pending Shipper (uid:f3936002-7bd9-4d23-b1fc-33b6df1978d5)
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
    And Operator changes the ticket status to "PENDING SHIPPER"
    And Operator clicks on Edit Filters button
    When Operator removes all ticket status filters
    Then Operator chooses the ticket status as "PENDING SHIPPER"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter ticket status - Ticket status using Resolved (uid:69adae83-2738-4dbd-83a1-93c0d910f546)
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
      And Operator changes the ticket status to Resloved
      And Operator updates the ticket
      And Operator clicks on Edit Filters button
      When Operator removes all ticket status filters
      Then Operator chooses the ticket status as "RESOLVED"
      And Operator enters the tracking id and verifies that is exists

  Scenario: Filter ticket status - Ticket status using All Parameter filter (uid:83096c63-1e9c-45a5-a390-89f0a4f90833)
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
      When Operator removes all ticket status filters
      Then Operator chooses all the ticket status filters
      And Operator enters the tracking id and verifies that is exists

  Scenario: Filter Entry Source - Customer Complaint (uid:79dc5341-9d29-41f9-b7cd-4a675c5c10f7)
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
    Then Operator chooses Entry Source Filter as "CUSTOMER COMPLAINT"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter Entry Source - Driver Turn (uid:8f3d2081-815f-4ea6-9bb2-d680272c9628)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | DRIVER TURN        |
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
    Then Operator chooses Entry Source Filter as "DRIVER TURN"
    And Operator enters the tracking id and verifies that is exists

 # Scenario: Filter Entry Source - General (uid:1ffb4e78-f37a-4a59-a0c4-25e1ef55bdcc)
  #  Given API Shipper create V4 order using data below:
  #    | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
  #    | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
  #  Given Operator go to menu Shipper Support -> Blocked Dates
  #  Given Operator go to menu Recovery -> Recovery Tickets
  #  When Operator create new ticket on page Recovery Tickets using data below:
  #    | entrySource             | GENERAL            |
  #    | investigatingDepartment | Fleet (First Mile) |
  #    | investigatingHub        | {hub-name}         |
  #    | ticketType              | DAMAGED            |
  #    | ticketSubType           | IMPROPER PACKAGING |
  #    | parcelLocation          | DAMAGED RACK       |
  #    | liability               | NV DRIVER          |
  #    | damageDescription       | GENERATED          |
  #    | orderOutcomeDamaged     | NV LIABLE - FULL   |
  #    | custZendeskId           | 1                  |
  #    | shipperZendeskId        | 1                  |
  #    | ticketNotes             | GENERATED          |
  #  Then Operator chooses Entry Source Filter as "GENERAL"
  #  And Operator enters the tracking id and verifies that is exists

  Scenario: Filter Entry Source - Missing Inbound Content (uid:910cc360-52f8-4358-92ca-104b237ef2c8)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | MISSING INBOUND CONTEST   |
      | investigatingDepartment | Fleet (First Mile)        |
      | investigatingHub        | {hub-name}                |
      | ticketType              | DAMAGED                   |
      | ticketSubType           | IMPROPER PACKAGING        |
      | parcelLocation          | DAMAGED RACK              |
      | liability               | NV DRIVER                 |
      | damageDescription       | GENERATED                 |
      | orderOutcomeDamaged     | NV LIABLE - FULL          |
      | custZendeskId           | 1                         |
      | shipperZendeskId        | 1                         |
      | ticketNotes             | GENERATED                 |
    Then Operator chooses Entry Source Filter as "MISSING INBOUND CONTEST"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter Entry Source - Outbound Clean (uid:9a319d97-23b5-4cda-91fb-23f9f6f62b38)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | OUTBOUND CLEAN     |
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
    Then Operator chooses Entry Source Filter as "OUTBOUND CLEAN"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter Entry Source - Recovery Scanning (uid:eed28e52-d4d9-441d-a49f-0ca0127f4a34)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | RECOVERY SCANNING  |
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
    Then Operator chooses Entry Source Filter as "RECOVERY SCANNING"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter Entry Source - Route Cleaning (uid:61569a5c-8d38-4c2d-b59e-967bb20002c7)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE CLEANING     |
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
    Then Operator chooses Entry Source Filter as "ROUTE CLEANING"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter Entry Source - Route Inbounding (uid:25fa96e2-6a73-410d-a10e-4bc58488190a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE INBOUNDING   |
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
    Then Operator chooses Entry Source Filter as "ROUTE INBOUNDING"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter Entry Source - Shipper Complaint (uid:10323bf2-3239-4185-94db-70007271f90c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | SHIPPER COMPLAINT  |
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
    Then Operator chooses Entry Source Filter as "SHIPPER COMPLAINT"
    And Operator enters the tracking id and verifies that is exists

  Scenario: Filter Tracking IDs - Tracking ID Correct (uid:b3d8544e-5808-447d-b7d7-c7c800937f8d)
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

  Scenario: Filter Tracking IDs - Tracking ID Wrong (uid:44200a8f-f811-4d0f-b0d8-56261db78603)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator enters the wrong Tracking Id
    Then No Results should be displayed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op



