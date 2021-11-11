@StationManagement @RecoveryTickets
Feature: Number of Missing or Damaged Parcels

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: View Pending Damage Ticket Type (uid:c233aa39-f51d-410f-a833-944086363dd8)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | ticketSubType           | IMPROPER PACKAGING |
      | parcelLocation          | DAMAGED RACK       |
      | liability               | Recovery           |
      | damageDescription       | GENERATED          |
      | orderOutcomeDamaged     | NV LIABLE - FULL   |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID   |
      | Ticket Status |
      | Order Tags    |
    And searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal under the table:"<TableName>"
      | Ticket Status | CREATED |

    Examples:
      | HubName      | TicketType | TileName                             | ModalName                   | TableName       |
      | {hub-name-3} | DAMAGED    | Number of missing or damaged parcels | Missing and Damaged Parcels | Damaged Parcels |

  Scenario Outline: View Pending Missing Ticket Type (uid:1b0879dc-9af9-428b-9d30-c27f3d772f81)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID   |
      | Ticket Status |
      | Order Tags    |
    And searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal under the table:"<TableName>"
      | Ticket Status | CREATED |

    Examples:
      | HubName      | TicketType | TileName                             | ModalName                   | TableName       |
      | {hub-name-3} | MISSING    | Number of missing or damaged parcels | Missing and Damaged Parcels | Missing Parcels |

  Scenario Outline: View <Status> Damage Ticket Type (<hiptest-uid>)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | ticketSubType           | IMPROPER PACKAGING |
      | parcelLocation          | DAMAGED RACK       |
      | liability               | Recovery           |
      | damageDescription       | GENERATED          |
      | orderOutcomeDamaged     | NV LIABLE - FULL   |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | rtsReason       | <RtsReason>    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID   |
      | Ticket Status |
      | Order Tags    |
    And searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal under the table:"<TableName>"
      | Ticket Status | <Status> |

    Examples:
      | HubName      | TicketType | Status          | OrderOutcome              | RtsReason         | TileName                             | ModalName                   | TableName       |hiptest-uid                              |
      | {hub-name-3} | DAMAGED    | IN PROGRESS     | NV LIABLE - RETURN PARCEL | Nobody at address | Number of missing or damaged parcels | Missing and Damaged Parcels | Damaged Parcels |uid:aaa0d5b4-ce79-44f3-86aa-01c902c0f34e |
      | {hub-name-3} | DAMAGED    | ON HOLD         | NV LIABLE - RETURN PARCEL | Nobody at address | Number of missing or damaged parcels | Missing and Damaged Parcels | Damaged Parcels |uid:88925961-4327-4688-9d3e-dd5e304baca3 |

  Scenario Outline: View <Status> Missing Ticket Type (<hiptest-uid>)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | orderOutcomeMissing     | <OrderOutcome>     |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID   |
      | Ticket Status |
      | Order Tags    |
    And searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And verifies that the following details are displayed on the modal under the table:"<TableName>"
      | Ticket Status | <Status> |

    Examples:
      | HubName      | TicketType | Status          | OrderOutcome    | TileName                             | ModalName                   | TableName       |hiptest-uid                              |
      | {hub-name-3} | MISSING    | IN PROGRESS     | LOST - DECLARED | Number of missing or damaged parcels | Missing and Damaged Parcels | Missing Parcels |uid:ad02e20f-0bf6-4408-a1b1-afb851693d30 |
      | {hub-name-3} | MISSING    | ON HOLD         | LOST - DECLARED | Number of missing or damaged parcels | Missing and Damaged Parcels | Missing Parcels |uid:32ed909f-4b6e-437a-959b-fc40d047606c |

  Scenario Outline: Resolved Ticket of Damage Type Disappear (uid:ae510579-e438-4a1f-b609-160c93c96a8c)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | ticketSubType           | IMPROPER PACKAGING |
      | parcelLocation          | DAMAGED RACK       |
      | liability               | Recovery           |
      | damageDescription       | GENERATED          |
      | orderOutcomeDamaged     | NV LIABLE - FULL   |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And get the count from the tile: "<TileName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | outcome                 | <OrderOutcome>            |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | assignTo                | NikoSusanto               |
      | rtsReason               | <RtsReason>               |
      | newInstructions         | GENERATED                 |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the count in tile: "<TileName>" has decreased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID   |
      | Ticket Status |
      | Order Tags    |
    And expects no results in the modal under the table:"<TableName>" when applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName      | TicketType | Status   | OrderOutcome              | KeepCurrentOrderOutcome | RtsReason         | TileName                             | ModalName                   | TableName       |
      | {hub-name-3} | DAMAGED    | RESOLVED | NV LIABLE - RETURN PARCEL | No                      | Nobody at address | Number of missing or damaged parcels | Missing and Damaged Parcels | Damaged Parcels |

  Scenario Outline: Resolved Ticket of Missing Type Disappear (uid:9366a5d9-5245-4651-a799-146fbcdac30b)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | orderOutcomeMissing     | <OrderOutcome>     |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And get the count from the tile: "<TileName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | outcome                 | <OrderOutcome>            |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | assignTo                | NikoSusanto               |
      | newInstructions         | GENERATED                 |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the count in tile: "<TileName>" has decreased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID   |
      | Ticket Status |
      | Order Tags    |
    And expects no results in the modal under the table:"<TableName>" when applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName      | TicketType | Status   | OrderOutcome    | KeepCurrentOrderOutcome | TileName                             | ModalName                   | TableName       |
      | {hub-name-3} | MISSING    | RESOLVED | LOST - DECLARED | No                      | Number of missing or damaged parcels | Missing and Damaged Parcels | Missing Parcels |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op