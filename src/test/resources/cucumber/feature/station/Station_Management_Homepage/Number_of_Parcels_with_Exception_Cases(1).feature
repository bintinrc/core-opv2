@StationManagement @RecoveryTickets @ExceptionCasesPart1
Feature: Number of Parcels with Exception Cases

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  Scenario Outline: View Pending Shipper Issue Ticket Type (uid:e4bc5e11-0ce4-4b9a-837c-557ab529319a)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | CREATED         |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome                | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | REPACKED/RELABELLED TO SEND | CREATED      |

  Scenario Outline: View Pending Parcel on Hold Ticket Type (uid:eb9b1948-329f-45e4-94ac-ce69dfdaacaf)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | CREATED         |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | CREATED      |

  @Happypath
  Scenario Outline: View Pending Parcel Exception Ticket Type (uid:bd998ebc-4a85-4604-aca0-58f6ea49d81c)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
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
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | CREATED         |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RTS          | CREATED      |

  Scenario Outline: View In-progress Shipper Issue Ticket Type (uid:06bcacaa-588f-464f-95f8-2ee71c5a40a0)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | <TicketStatus>  |
    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome                | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | REPACKED/RELABELLED TO SEND | IN PROGRESS  |

  Scenario Outline: View on Hold Shipper Issue Ticket Type (uid:a5af556b-3c65-469a-abe3-ed478990b0e7)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | <TicketStatus>  |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome    | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | PARCEL SCRAPPED | ON HOLD      |

  Scenario Outline: View Pending Shipper of Shipper Issue Ticket Type (uid:ae7d775e-4a1b-4df1-85b6-2a3c1d75780b)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | <TicketStatus>  |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome                | TicketStatus    |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | REPACKED/RELABELLED TO SEND | PENDING SHIPPER |

  Scenario Outline: View In-progress Parcel on Hold Ticket Type (uid:4e3e1b3f-679e-453e-9ff8-8cadb4fd21f3)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | <TicketStatus>  |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | IN PROGRESS  |

  Scenario Outline: View on Hold Parcel on Hold Ticket Type (uid:378e02ba-3196-4a6d-b924-4f61c93bed8b)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | <TicketStatus>  |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | ON HOLD      |

  Scenario Outline: View Pending Shipper Parcel on Hold Ticket Type (uid:f06876ed-3c73-443d-9266-0c96381ec64a)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | <TicketStatus>  |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus    |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | PENDING SHIPPER |

  Scenario Outline: View In-progress Parcel Exception Ticket Type (uid:b9e2d218-a25e-4a79-9ca5-82f086e7a2cd)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | <TicketStatus>  |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RTS          | IN PROGRESS  |

  Scenario Outline: View on Hold Parcel Exception Ticket Type (uid:c550f630-678c-442e-8c87-a4db9adb3b02)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | <TicketStatus>  |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RTS          | ON HOLD      |

  Scenario Outline: View Pending Shipper Parcel Exception Ticket Type (uid:36ba42b6-ea60-4983-a890-313c1679fe57)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator selects following filter criteria for the table column: "Ticket Subtype"
      | <TicketSubType> |
    And Operator verifies that the following details are displayed on the modal
      | Ticket Subtype | <TicketSubType> |
      | Ticket Status  | <TicketStatus>  |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome | TicketStatus    |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RTS          | PENDING SHIPPER |


  Scenario Outline: Resolved Ticket of Shipper Issue Type Disappear (uid:ab9b8b45-4b3a-4f61-9fb2-d78abde35d5f)
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome    | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | PARCEL SCRAPPED | RESOLVED     |

  @Happypath
  Scenario Outline: Resolved Ticket of Parcel Exception Type Disappear (uid:fc916a62-b9fe-4fb8-be97-915e29cc5b88)
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RTS          | RESOLVED     |

  Scenario Outline: Resolved Ticket of on Hold Type Disappear (uid:1df65d62-727a-4531-9368-a9f2079cb0f5)
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | subTicketType      | <TicketSubType>                            |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    Then DB Recovery - get id from ticket_custom_fields table Hibernate
      | ticketId      | {KEY_CREATED_RECOVERY_TICKET_ID} |
      | customFieldId | {KEY_CREATED_ORDER_OUTCOME_ID}   |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id}  |
      | status           | <TicketStatus>                           |
      | outcome          | <OrderOutcome>                           |
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Subtype    |
      | Ticket Status     |
      | Order Tags        |
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TileName                               | ModalName                    | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-3} | {hub-id-3} | Number of parcels with exception cases | Parcels with Exception Cases | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | RESOLVED     |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op