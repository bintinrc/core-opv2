@StationManagement @RecoveryTickets @ExceptionCases
Feature: Number of Parcels with Exception Cases

  @LaunchBrowser @ShouldAlwaysRun @Test
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: View Pending Shipper Issue Ticket Type (uid:e4bc5e11-0ce4-4b9a-837c-557ab529319a)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | XMAS CAGE          |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | CREATED      |

    Examples:
      | HubName      | TicketType    | TicketSubType    | TileName                               | ModalName                    |
      | {hub-name-3} | SHIPPER ISSUE | DUPLICATE PARCEL | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View Pending Parcel on Hold Ticket Type (uid:eb9b1948-329f-45e4-94ac-ce69dfdaacaf)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE CLEANING     |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | ticketSubType           | <TicketSubType>    |
      | orderOutcome            | RESUME DELIVERY    |
      | exceptionReason         | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | CREATED      |

    Examples:
      | HubName      | TicketType     | TicketSubType   | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL ON HOLD | SHIPPER REQUEST | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View Pending Parcel Exception Ticket Type (uid:bd998ebc-4a85-4604-aca0-58f6ea49d81c)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                   | ROUTE CLEANING     |
      | investigatingDepartment       | Fleet (First Mile) |
      | investigatingHub              | <HubName>          |
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
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | CREATED      |

    Examples:
      | HubName      | TicketType       | TicketSubType      | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL EXCEPTION | INACCURATE ADDRESS | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View In-progress Shipper Issue Ticket Type (uid:06bcacaa-588f-464f-95f8-2ee71c5a40a0)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | Status          | TileName                               | ModalName                    |
      | {hub-name-3} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | IN PROGRESS     | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View on Hold Shipper Issue Ticket Type (uid:a5af556b-3c65-469a-abe3-ed478990b0e7)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | Status          | TileName                               | ModalName                    |
      | {hub-name-3} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | ON HOLD         | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View Pending Shipper of  Shipper Issue Ticket Type (uid:ae7d775e-4a1b-4df1-85b6-2a3c1d75780b)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | Status          | TileName                               | ModalName                    |
      | {hub-name-3} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | PENDING SHIPPER | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View In-progress Parcel on Hold Ticket Type (uid:4e3e1b3f-679e-453e-9ff8-8cadb4fd21f3)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE CLEANING     |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | ticketSubType           | <TicketSubType>    |
      | orderOutcome            | <OrderOutcome>     |
      | exceptionReason         | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |

    Examples:
      | HubName      | TicketType     | TicketSubType   | OrderOutcome    | Status          | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | IN PROGRESS     | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View on Hold Parcel on Hold Ticket Type (uid:378e02ba-3196-4a6d-b924-4f61c93bed8b)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE CLEANING     |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | ticketSubType           | <TicketSubType>    |
      | orderOutcome            | <OrderOutcome>     |
      | exceptionReason         | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |

    Examples:
      | HubName      | TicketType     | TicketSubType   | OrderOutcome    | Status          | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | ON HOLD         | Number of parcels with exception cases | Parcels with Exception Cases |


  Scenario Outline: View Pending Shipper Parcel on Hold Ticket Type (uid:f06876ed-3c73-443d-9266-0c96381ec64a)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE CLEANING     |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | ticketSubType           | <TicketSubType>    |
      | orderOutcome            | <OrderOutcome>     |
      | exceptionReason         | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |

    Examples:
      | HubName      | TicketType     | TicketSubType   | OrderOutcome    | Status          | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | PENDING SHIPPER | Number of parcels with exception cases | Parcels with Exception Cases |


  Scenario Outline: View In-progress Parcel Exception Ticket Type (uid:b9e2d218-a25e-4a79-9ca5-82f086e7a2cd)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                   | ROUTE CLEANING     |
      | investigatingDepartment       | Fleet (First Mile) |
      | investigatingHub              | <HubName>          |
      | ticketType                    | <TicketType>       |
      | ticketSubType                 | <TicketSubType>    |
      | orderOutcomeInaccurateAddress | <OrderOutcome>     |
      | rtsReason                     | Nobody at address  |
      | exceptionReason               | GENERATED          |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |

    Examples:
      | HubName      | TicketType       | TicketSubType      | OrderOutcome | Status          | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL EXCEPTION | INACCURATE ADDRESS | RTS          | IN PROGRESS     | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View on Hold Parcel Exception Ticket Type (uid:c550f630-678c-442e-8c87-a4db9adb3b02)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                   | ROUTE CLEANING     |
      | investigatingDepartment       | Fleet (First Mile) |
      | investigatingHub              | <HubName>          |
      | ticketType                    | <TicketType>       |
      | ticketSubType                 | <TicketSubType>    |
      | orderOutcomeInaccurateAddress | <OrderOutcome>     |
      | rtsReason                     | Nobody at address  |
      | exceptionReason               | GENERATED          |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |

    Examples:
      | HubName      | TicketType       | TicketSubType      | OrderOutcome | Status          | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL EXCEPTION | INACCURATE ADDRESS | RTS          | ON HOLD         | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View Pending Shipper Parcel Exception Ticket Type (uid:36ba42b6-ea60-4983-a890-313c1679fe57)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                   | ROUTE CLEANING     |
      | investigatingDepartment       | Fleet (First Mile) |
      | investigatingHub              | <HubName>          |
      | ticketType                    | <TicketType>       |
      | ticketSubType                 | <TicketSubType>    |
      | orderOutcomeInaccurateAddress | <OrderOutcome>     |
      | rtsReason                     | Nobody at address  |
      | exceptionReason               | GENERATED          |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Type   | <TicketType> |
      | Ticket Status | <Status>     |

    Examples:
      | HubName      | TicketType       | TicketSubType      | OrderOutcome | Status          | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL EXCEPTION | INACCURATE ADDRESS | RTS          | PENDING SHIPPER | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: Resolved Ticket of Shipper Issue Type Disappear (uid:ab9b8b45-4b3a-4f61-9fb2-d78abde35d5f)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | outcome                 | <OrderOutcome>            |
      | assignTo                | NikoSusanto               |
      | newInstructions         | GENERATED                 |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | KeepCurrentOrderOutcome | Status   | TileName                               | ModalName                    |
      | {hub-name-3} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | No                      | RESOLVED | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: Resolved Ticket of Parcel Exception Type Disappear (uid:fc916a62-b9fe-4fb8-be97-915e29cc5b88)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                   | ROUTE CLEANING     |
      | investigatingDepartment       | Fleet (First Mile) |
      | investigatingHub              | <HubName>          |
      | ticketType                    | <TicketType>       |
      | ticketSubType                 | <TicketSubType>    |
      | orderOutcomeInaccurateAddress | <OrderOutcome>     |
      | rtsReason                     | Nobody at address  |
      | exceptionReason               | GENERATED          |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | outcome                 | <OrderOutcome>            |
      | assignTo                | NikoSusanto               |
      | newInstructions         | GENERATED                 |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName      | TicketType       | TicketSubType      | OrderOutcome | KeepCurrentOrderOutcome | Status   | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL EXCEPTION | INACCURATE ADDRESS | RTS          | No                      | RESOLVED | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: Resolved Ticket of on Hold Type Disappear (uid:1df65d62-727a-4531-9368-a9f2079cb0f5)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | ROUTE CLEANING     |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | ticketSubType           | <TicketSubType>    |
      | orderOutcome            | <OrderOutcome>     |
      | exceptionReason         | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | outcome                 | <OrderOutcome>            |
      | assignTo                | NikoSusanto               |
      | newInstructions         | GENERATED                 |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName      | TicketType     | TicketSubType   | OrderOutcome    | KeepCurrentOrderOutcome | Status   | TileName                               | ModalName                    |
      | {hub-name-3} | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | No                      | RESOLVED | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: View Recovery Ticket  of Exception Cases Parcels (uid:ff67196f-4020-4a36-abf8-5e33420ca106)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that recovery tickets page is opened on clicking arrow button
    And Operator verifies that the url for recovery tickets page is loaded with tracking id

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | TileName                               | ModalName                    |
      | {hub-name-3} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | Number of parcels with exception cases | Parcels with Exception Cases |
  @Test
  Scenario Outline: View Order Details of Exception Cases Parcels (uid:36f6ec17-4e1d-4bcb-b99a-fd754118bf06)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID   |
      | Ticket Type   |
      | Ticket Status |
      | Order Tags    |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that Edit Order page is opened on clicking tracking id
    And Operator verifies that the url for edit order page is loaded with order id

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | TileName                               | ModalName                    |
      | {hub-name-3} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: Missing Ticket Not Appears in Exception Cases (uid:0af9d116-d7ec-449d-87ca-65e8697e294e)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    Then Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName      | TicketType | TileName                               | ModalName                    |
      | {hub-name-3} | MISSING    | Number of parcels with exception cases | Parcels with Exception Cases |

  Scenario Outline: Damaged Ticket Not Appears in Exception Cases (uid:e03bc400-4f70-4192-b520-4621c9288617)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-3}" and proceed
    Then Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName      | TicketType | TileName                               | ModalName                    |
      | {hub-name-3} | DAMAGED    | Number of parcels with exception cases | Parcels with Exception Cases |

  @KillBrowser @ShouldAlwaysRun @Test
  Scenario: Kill Browser
    Given no-op