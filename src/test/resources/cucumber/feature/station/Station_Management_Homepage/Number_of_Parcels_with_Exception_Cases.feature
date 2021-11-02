@StationManagement @RecoveryTickets
Feature: Number of Parcels with Exception Cases

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Detail of Pending Ticket Status (uid:5fa7ce50-3f6d-470b-a707-46c3aec317ca)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | {hub-name-3}       |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | XMAS CAGE          |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | CREATED      |
    And reloads operator portal to reset the test state

    Examples:
      | TicketType    | TicketSubType    | TileName                               | ModalName                    |
      | SHIPPER ISSUE | DUPLICATE PARCEL | Number of parcels with exception cases | Parcels with Exception Cases |


  Scenario Outline: Detail of Pending Ticket Status (uid:3c439b3b-2e3a-43b8-8b49-3b17f221de9d)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE CLEANING     |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name-3}       |
      | ticketType              | <TicketType>       |
      | ticketSubType           | <TicketSubType>    |
      | orderOutcome            | RESUME DELIVERY    |
      | exceptionReason         | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | CREATED      |
    And reloads operator portal to reset the test state

    Examples:
      | TicketType     | TicketSubType   | TileName                               | ModalName                    |
      | PARCEL ON HOLD | SHIPPER REQUEST | Number of parcels with exception cases | Parcels with Exception Cases |


  Scenario Outline: Detail of Pending Ticket Status (uid:a4e30417-acb7-4fbb-ae98-d80fee952283)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                   | ROUTE CLEANING     |
      | investigatingDepartment       | Fleet (First Mile) |
      | investigatingHub              | {hub-name-3}       |
      | ticketType                    | <TicketType>       |
      | ticketSubType                 | <TicketSubType>    |
      | orderOutcomeInaccurateAddress | RTS                |
      | rtsReason                     | Nobody at address  |
      | exceptionReason               | GENERATED          |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | CREATED      |
    And reloads operator portal to reset the test state

    Examples:
      | TicketType       | TicketSubType      | TileName                               | ModalName                    |
      | PARCEL EXCEPTION | INACCURATE ADDRESS | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: Detail of <Status> Ticket Status (<hiptest-uid>)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | {hub-name-1}       |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator updates the ticket settings with the following details:
      | ticketStatus        | <Status>       |
      | orderOutcome        | <OrderOutcome> |
      | assignTo            | NikoSusanto    |
      | enterNewInstruction | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |
    And reloads operator portal to reset the test state

    Examples:
      | TicketType    | TicketSubType    | OrderOutcome | Status      | TileName                               | ModalName                    | hiptest-uid                              |
      | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | IN PROGRESS | Number of parcels with exception cases | Parcels with Exception Cases | uid:f0862cee-84ba-4592-9855-517e1668098d |
      | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | ON HOLD     | Number of parcels with exception cases | Parcels with Exception Cases | uid:87a1bdd6-61b1-44f3-83b0-e29760cfd5d6 |

  Scenario Outline: Detail of <Status> Ticket Status (<hiptest-uid>)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE CLEANING     |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name-1}       |
      | ticketType              | <TicketType>       |
      | ticketSubType           | <TicketSubType>    |
      | orderOutcome            | <OrderOutcome>     |
      | exceptionReason         | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator updates the ticket settings with the following details:
      | ticketStatus        | <Status>       |
      | orderOutcome        | <OrderOutcome> |
      | assignTo            | NikoSusanto    |
      | enterNewInstruction | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |
    And reloads operator portal to reset the test state

    Examples:
      | TicketType     | TicketSubType   | OrderOutcome    | Status      | TileName                               | ModalName                    | hiptest-uid                              |
      | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | IN PROGRESS | Number of parcels with exception cases | Parcels with Exception Cases | uid:b0d60cea-bac7-4052-803c-b922bebf02b8 |
      | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | ON HOLD     | Number of parcels with exception cases | Parcels with Exception Cases | uid:15615f65-3510-41d9-9056-d6e00512f493 |

  Scenario Outline: Detail of <Status> Ticket Status (<hiptest-uid>)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                   | ROUTE CLEANING     |
      | investigatingDepartment       | Fleet (First Mile) |
      | investigatingHub              | {hub-name-1}       |
      | ticketType                    | <TicketType>       |
      | ticketSubType                 | <TicketSubType>    |
      | orderOutcomeInaccurateAddress | <OrderOutcome>     |
      | rtsReason                     | Nobody at address  |
      | exceptionReason               | GENERATED          |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And Operator searches the created ticket and clicks on Edit button
    Then Operator updates the ticket settings with the following details:
      | ticketStatus        | <Status>       |
      | orderOutcome        | <OrderOutcome> |
      | assignTo            | NikoSusanto    |
      | enterNewInstruction | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |
    And reloads operator portal to reset the test state

    Examples:
      | TicketType       | TicketSubType      | OrderOutcome | Status      | TileName                               | ModalName                    | hiptest-uid                              |
      | PARCEL EXCEPTION | INACCURATE ADDRESS | RTS          | IN PROGRESS | Number of parcels with exception cases | Parcels with Exception Cases | uid:2532f73d-7eeb-44b8-8478-f5edf53ba59f |
      | PARCEL EXCEPTION | INACCURATE ADDRESS | RTS          | ON HOLD     | Number of parcels with exception cases | Parcels with Exception Cases | uid:a39af543-e1fb-4304-a37c-7e30a4915371 |

  Scenario Outline: SHIPPER ISSUE Ticket Type and Order Outcome Is RESOLVED (<hiptest-uid>)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | {hub-name-1}       |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | outcome                 | <OrderOutcome>            |
      | assignTo                | NikoSusanto               |
      | newInstructions         | GENERATED                 |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has decreased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | TicketType    | TicketSubType    | OrderOutcome | KeepCurrentOrderOutcome | Status   | TileName                               | ModalName                    | hiptest-uid                              |
      | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | No                      | RESOLVED | Number of parcels with exception cases | Parcels with Exception Cases | uid:ab9b8b45-4b3a-4f61-9fb2-d78abde35d5f |

  Scenario Outline: PARCEL EXCEPTION  Ticket Type and Order Outcome Is RESOLVED (<hiptest-uid>)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                   | ROUTE CLEANING     |
      | investigatingDepartment       | Fleet (First Mile) |
      | investigatingHub              | {hub-name-1}       |
      | ticketType                    | <TicketType>       |
      | ticketSubType                 | <TicketSubType>    |
      | orderOutcomeInaccurateAddress | <OrderOutcome>     |
      | rtsReason                     | Nobody at address  |
      | exceptionReason               | GENERATED          |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | outcome                 | <OrderOutcome>            |
      | assignTo                | NikoSusanto               |
      | newInstructions         | GENERATED                 |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has decreased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | TicketType       | TicketSubType      | OrderOutcome | KeepCurrentOrderOutcome | Status   | TileName                               | ModalName                    | hiptest-uid                              |
      | PARCEL EXCEPTION | INACCURATE ADDRESS | RTS          | No                      | RESOLVED | Number of parcels with exception cases | Parcels with Exception Cases | uid:fc916a62-b9fe-4fb8-be97-915e29cc5b88 |

  Scenario Outline: PARCEL ON HOLD Ticket Type and Order Outcome Is RESOLVED (<hiptest-uid>)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE CLEANING     |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name-1}       |
      | ticketType              | <TicketType>       |
      | ticketSubType           | <TicketSubType>    |
      | orderOutcome            | <OrderOutcome>     |
      | exceptionReason         | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | outcome                 | <OrderOutcome>            |
      | assignTo                | NikoSusanto               |
      | newInstructions         | GENERATED                 |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has decreased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | TicketType     | TicketSubType   | OrderOutcome    | KeepCurrentOrderOutcome | Status   | TileName                               | ModalName                    | hiptest-uid                              |
      | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | No                      | RESOLVED | Number of parcels with exception cases | Parcels with Exception Cases | uid:1df65d62-727a-4531-9368-a9f2079cb0f5 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op