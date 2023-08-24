@StationManagement @RecoveryTickets @MissedParcels
Feature: Number of Missing Parcels

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @Happypath @HighPriority
  Scenario Outline: View Pending Missing Ticket Type (uid:1b0879dc-9af9-428b-9d30-c27f3d772f81)
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
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<TableName>"
      | Ticket Status | <TicketStatus> |
    Then Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" and edit order page is loaded with order id "order-v2?id={KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verifies that recovery tickets page is opened on clicking arrow button
    And Operator verifies that the url for recovery tickets page is loaded with tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | Missing Parcels | MISSING    | ORDER OUTCOME (MISSING) | FOUND - INBOUND | CREATED      |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: View In-progress Missing Ticket Type (uid:ad02e20f-0bf6-4408-a1b1-afb851693d30)
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
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<TableName>"
      | Ticket Status | <TicketStatus> |

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | Missing Parcels | MISSING    | ORDER OUTCOME (MISSING) | LOST - DECLARED | IN PROGRESS  |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: View on Hold Missing Ticket Type (uid:32ed909f-4b6e-437a-959b-fc40d047606c)
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
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<TableName>"
      | Ticket Status | <TicketStatus> |

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | Missing Parcels | MISSING    | ORDER OUTCOME (MISSING) | LOST - DECLARED | ON HOLD      |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: View Pending Shipper Missing Ticket Type (uid:8c5a1caf-308c-4916-ad93-aaa6137d6bc5)
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
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Status     |
      | Order Tags        |
    And Operator searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<TableName>"
      | Ticket Status | <TicketStatus> |

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | Missing Parcels | MISSING    | ORDER OUTCOME (MISSING) | LOST - DECLARED | ON HOLD      |

  @ForceSuccessOrder
  Scenario Outline: View Order Details of Missing Parcels (uid:e2b42ea0-26ae-4207-8485-e5d64958ac3f)
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
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" and edit order page is loaded with order id "order-v2?id={KEY_LIST_OF_CREATED_ORDERS[1].id}"

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | Missing Parcels | MISSING    | ORDER OUTCOME (MISSING) | LOST - DECLARED | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: View Recovery Ticket  of Missing Parcels (uid:9ffe52c5-bc61-410b-bacf-577e29abefee)
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
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the order details in the table:"<TableName>" by applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that recovery tickets page is opened on clicking arrow button
    And Operator verifies that the url for recovery tickets page is loaded with tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | Missing Parcels | MISSING    | ORDER OUTCOME (MISSING) | LOST - DECLARED | CREATED      |

  @Happypath @ForceSuccessOrder @HighPriority
  Scenario Outline: Resolved Ticket of Missing Type Disappear (uid:9366a5d9-5245-4651-a799-146fbcdac30b)
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
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
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
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that the table:"<TableName>" is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Status     |
      | Order Tags        |
    And Operator expects no results in the modal under the table:"<TableName>" when applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | Missing Parcels | MISSING    | ORDER OUTCOME (MISSING) | LOST - DECLARED | RESOLVED     |

  @ForceSuccessOrder
  Scenario Outline: Parcel Exception Ticket Not Appears in Missing Cases (uid:c1d5ec41-0bef-4eab-9200-16b8cb7aa433)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName1>"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in tile: "<TileName1>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName1>" through hamburger button for the tile: "<TileName1>"
    And Operator expects no results in the modal under the table:"<ModalName1>" when applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TileName1       | ModalName1      | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RTS          | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: Parcel on Hold Ticket Not Appears in Missing Cases (uid:940a6d90-26b6-4bd4-82d9-0203be558e68)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName1>"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in tile: "<TileName1>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName1>" through hamburger button for the tile: "<TileName1>"
    And Operator expects no results in the modal under the table:"<ModalName1>" when applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TileName1       | ModalName1      | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: Shipper Issue Ticket Not Appears in Missing Cases (uid:f722c7f8-7dfe-43c2-9346-20e4e00259a3)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName1>"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in tile: "<TileName1>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName1>" through hamburger button for the tile: "<TileName1>"
    And Operator expects no results in the modal under the table:"<ModalName1>" when applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TileName1       | ModalName1      | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome                | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | REPACKED/RELABELLED TO SEND | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: Damaged Ticket Not Appears in Missing Cases (uid:bff303e4-a9c9-477f-a8ac-656cdf39dc59)
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
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results in the modal under the table:"<ModalName>" when applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: View Hub Inbound Scanned Missing Parcels (uid:c2316f01-daa3-4d75-a498-f2acb2d57a2b)
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
      | hubId                | {hub-id-Global2}                                                                                                                                                                                                                                   |
    And Operator gets Last Scan time for TrackingId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Status     |
      | Order Tags        |
    And Operator selects following filter criteria for the table column: "Last Scan"
      | <LastScannedEvent> |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<ModalName>"
      | Last Scanned Time | {KEY_EVENT_TIME} |
      | Ticket Status     | CREATED          |

    Examples:
      | HubName            | HubId            | TileName        | ModalName       | LastScannedEvent | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-Global2} | {hub-id-Global2} | Missing parcels | Missing Parcels | HUB_INBOUND_SCAN | MISSING    | ORDER OUTCOME (MISSING) | FOUND - INBOUND | CREATED      |


  @ForceSuccessOrder
  Scenario Outline: View Parcel Routing Scanned Missing Parcels
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
    And Operator gets Last Scan time for TrackingId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Status     |
      | Order Tags        |
    And Operator selects following filter criteria for the table column: "Last Scan"
      | <LastScannedEvent> |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<ModalName>"
      | Last Scanned Time | {KEY_EVENT_TIME} |
      | Ticket Status     | CREATED          |


    Examples:
      | HubName      | HubId      | TileName        | ModalName       | LastScannedEvent    | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | PARCEL_ROUTING_SCAN | MISSING    | ORDER OUTCOME (MISSING) | FOUND - INBOUND | CREATED      |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Driver Inbound Scanned Missing Parcels (uid:f985d503-87ed-4289-b7f0-21c066bedc8b)
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
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And Operator gets Last Scan time for TrackingId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Status     |
      | Order Tags        |
    And Operator selects following filter criteria for the table column: "Last Scan"
      | <LastScannedEvent> |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<ModalName>"
      | Last Scanned Time | {KEY_EVENT_TIME} |
      | Ticket Status     | CREATED          |

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | LastScannedEvent    | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | DRIVER_INBOUND_SCAN | MISSING    | ORDER OUTCOME (MISSING) | FOUND - INBOUND | CREATED      |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Route Inbound Scanned Missing Parcels (uid:a08ac796-5052-4427-b079-79deb22ce462)
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
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 11                                                                                                                     |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>              |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" on Route Inbound page
    And Operator gets Last Scan time for TrackingId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}              |
      | investigatingHubId | <HubId>                                    |
      | ticketType         | <TicketType>                               |
      | orderOutcomeName   | <OrderOutcomeName>                         |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID       |
      | Last Scan         |
      | Last Scanned Time |
      | Ticket Status     |
      | Order Tags        |
    And Operator selects following filter criteria for the table column: "Last Scan"
      | <LastScannedEvent> |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<ModalName>"
      | Last Scanned Time | {KEY_EVENT_TIME} |
      | Ticket Status     | CREATED          |

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | LastScannedEvent   | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels | ROUTE_INBOUND_SCAN | MISSING    | ORDER OUTCOME (MISSING) | FOUND - INBOUND | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: Sort Missing Parcels Based on Last Scanned Time (uid:b91f8411-5117-49cc-b02a-a62a5534dedc)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operators sorts and verifies that the column:"Last Scanned Time" is in ascending order

    Examples:
      | HubName      | HubId      | TileName        | ModalName       |
      | {hub-name-6} | {hub-id-6} | Missing parcels | Missing Parcels |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op