@StationManagement @RecoveryTickets @DamagedParcels
Feature: Number of Damaged Parcels

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Happypath @ForceSuccessOrder @HighPriority
  Scenario Outline: View Pending Damage Ticket Type (uid:c233aa39-f51d-410f-a833-944086363dd8)
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
    When API Sort - Operator global inbound
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
      | Ticket Status | CREATED |
    Then Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" and edit order page is loaded with order id "order/{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verifies that recovery tickets page is opened on clicking arrow button
    And Operator verifies that the url for recovery tickets page is loaded with tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | Damaged Parcels | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | CREATED      |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: View In-progress Damage Ticket Type (uid:aaa0d5b4-ce79-44f3-86aa-01c902c0f34e)
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
    When API Sort - Operator global inbound
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
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | Damaged Parcels | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | IN PROGRESS  |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: View on Hold Damage Ticket Type (uid:88925961-4327-4688-9d3e-dd5e304baca3)
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
    When API Sort - Operator global inbound
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
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | Damaged Parcels | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | ON HOLD      |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: View Pending Shipper of  Damage Ticket Type (uid:189f7c7b-515b-4d04-aba3-7ced3b87e8bf)
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
    When API Sort - Operator global inbound
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
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus    |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | Damaged Parcels | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | PENDING SHIPPER |

  @Happypath @ForceSuccessOrder @HighPriority
  Scenario Outline: Resolved Ticket of Damage Type Disappear (uid:ae510579-e438-4a1f-b609-160c93c96a8c)
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
    When API Sort - Operator global inbound
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
      | HubName      | HubId      | TileName        | ModalName       | TableName       | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | Damaged Parcels | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | RESOLVED     |


  @ForceSuccessOrder
  Scenario Outline: View Hub Inbound Scanned Damaged Parcels (uid:c045511d-c5b0-4377-bd52-3aa4e7dbb671)
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
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
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
      | HubName            | HubId            | TileName        | ModalName       | LastScannedEvent | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-Global2} | {hub-id-Global2} | Damaged parcels | Damaged Parcels | HUB_INBOUND_SCAN | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | CREATED      |


  @ForceSuccessOrder
  Scenario Outline: View Parcel Routing Scanned Damaged Pacels (uid:78b409c6-d0c7-46b7-b575-1b31f0de1154)
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
    When API Sort - Operator global inbound
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
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<ModalName>"
      | Last Scanned Time | {KEY_EVENT_TIME} |
      | Ticket Status     | CREATED          |


    Examples:
      | HubName      | HubId      | TileName        | ModalName       | LastScannedEvent    | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | PARCEL_ROUTING_SCAN | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | CREATED      |


  @ForceSuccessOrder  @ArchiveRouteCommonV2
  Scenario Outline: View Route Inbound Scanned Damaged Parcels (uid:10f5c894-bb82-487b-ba88-326cf2bb66ba)
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
    When API Sort - Operator global inbound
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
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal under the table:"<ModalName>"
      | Last Scanned Time | {KEY_EVENT_TIME} |
      | Ticket Status     | CREATED          |

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | LastScannedEvent   | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | ROUTE_INBOUND_SCAN | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: View Order Details of Damaged Parcels (uid:a326fa77-c1c0-4271-94fd-cb5debd5c1dd)
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
    When API Sort - Operator global inbound
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
    And Operator searches for the order details in the table:"<ModalName>" by applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" and edit order page is loaded with order id "order/KEY_LIST_OF_CREATED_ORDERS[1].id}"

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | LastScannedEvent   | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | ROUTE_INBOUND_SCAN | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: View Recovery Ticket  of Damaged Parcels (uid:c171160e-3740-4852-b44e-3c6bdb2314af)
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
    When API Sort - Operator global inbound
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
    And Operator searches for the order details in the table:"<ModalName>" by applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that recovery tickets page is opened on clicking arrow button
    And Operator verifies that the url for recovery tickets page is loaded with tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"

    Examples:
      | HubName      | HubId      | TileName        | ModalName       | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: Sort Damaged Parcels Based on Last Scanned Time (uid:b1456531-3e28-4e0f-a32f-cc6679cc0606)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operators sorts and verifies that the column:"Last Scanned Time" is in ascending order

    Examples:
      | HubName      | HubId      | TileName        | ModalName       |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels |

  @ForceSuccessOrder
  Scenario Outline: Parcel Exception Ticket Not Appears in Damaged Cases (uid:3802bc73-49c3-4d1c-ae0a-a01f24b5a722)
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
    When API Sort - Operator global inbound
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
    Then Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results in the modal under the table:"<ModalName>" when applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TicketSubType      | TileName        | ModalName       | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome | TicketStatus |
      | {hub-name-6} | {hub-id-6} | INACCURATE ADDRESS | Damaged parcels | Damaged Parcels | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RTS          | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: Parcel on Hold Ticket Not Appears in Damaged Cases (uid:36429a6f-6d65-466b-9fc0-a6e045da4d5a)
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
    When API Sort - Operator global inbound
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
    Then Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results in the modal under the table:"<ModalName>" when applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TicketSubType   | TileName        | ModalName       | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | SHIPPER REQUEST | Damaged parcels | Damaged Parcels | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: Shipper Issue Ticket Not Appears in Damaged Cases (uid:eb921d4a-638e-4301-a546-9d97a35986f7)
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
    When API Sort - Operator global inbound
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
    Then Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results in the modal under the table:"<ModalName>" when applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName      | HubId      | TicketSubType    | TileName        | ModalName       | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome                | TicketStatus |
      | {hub-name-6} | {hub-id-6} | DUPLICATE PARCEL | Damaged parcels | Damaged Parcels | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | REPACKED/RELABELLED TO SEND | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: Missing Ticket Not Appears in Damaged Cases (uid:b30b4a99-3370-4d8d-af1a-5f828fe78f69)
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
    When API Sort - Operator global inbound
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
      | HubName      | HubId      | TileName        | ModalName       | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-6} | {hub-id-6} | Damaged parcels | Damaged Parcels | MISSING    | ORDER OUTCOME (MISSING) | FOUND - INBOUND | CREATED      |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op