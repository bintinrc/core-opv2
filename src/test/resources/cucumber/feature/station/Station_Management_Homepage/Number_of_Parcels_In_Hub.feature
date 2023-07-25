@StationManagement @NumberOfParcels
Feature: Number of Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Happypath @ForceSuccessOrder
  Scenario Outline: View Number of Parcels in Hub (uid:34b4182d-ee92-4936-b4b8-fbc3890be67d)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that the table:"<TableName1>" is displayed with following columns:
      | Size  |
      | Count |
    And Operator verifies that the table:"<TableName2>" is displayed with following columns:
      | Zones |
      | Count |

    Examples:
      | HubName       | HubId       | TileName                 | ModalName      | TableName1     | TableName2 |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | Parcels in Hub | By Parcel Size | By Zones   |

  @ForceSuccessOrder
  Scenario Outline: View Parcel of Resolved Missing Ticket Type and Outcome is Lost-Declared (uid:136f000f-9deb-44b2-9e92-f2195932a3cc)
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | MISSING                               |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | status           | <Status>                                |
      | orderOutcomeName | ORDER OUTCOME (MISSING)                 |
      | customFieldId    | 25021827                                |
      | outcome          | <Outcome>                               |
      | reporterId       | {ticketing-creator-user-id}             |
      | reporterName     | {ticketing-creator-user-name}           |
      | reporterEmail    | {ticketing-creator-user-email}          |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then API Core -  Wait for following order state:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | status     | <OrderStatus>                              |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1

    Examples:
      | HubName       | HubId       | TileName                 | Status   | KeepCurrentOrderOutcome | Outcome         | OrderStatus |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | RESOLVED | No                      | LOST - DECLARED | CANCELLED   |

  @ForceSuccessOrder
  Scenario Outline: View Parcel of Resolved Missing Ticket Type and Outcome is Lost-Undeclared (uid:70f81b81-e530-4a34-b520-ff5b0347977e)
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | MISSING                               |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | status           | <Status>                                |
      | orderOutcomeName | ORDER OUTCOME (MISSING)                 |
      | customFieldId    | 25021827                                |
      | outcome          | <Outcome>                               |
      | reporterId       | {ticketing-creator-user-id}             |
      | reporterName     | {ticketing-creator-user-name}           |
      | reporterEmail    | {ticketing-creator-user-email}          |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then API Core -  Wait for following order state:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | status     | <OrderStatus>                              |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1

    Examples:
      | HubName       | HubId       | TileName                 | Status   | KeepCurrentOrderOutcome | Outcome           | OrderStatus |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | RESOLVED | No                      | LOST - UNDECLARED | TRANSIT     |

  @ForceSuccessOrder
  Scenario Outline: View Parcel of Resolved Missing Ticket Type and Outcome is Customer Received (uid:9c5beef9-79df-4423-9a2d-42b9d37e228d)
  NOTE: For the Missing Ticket Type and Order Outcome Is CUSTOMER RECEIVED it suppose be included to the counts but because the granular status will be updated to Completed so it's not included (we have a logic to exclude order counts if the order granular status is '
  Completed', 'Cancelled', 'Returned to Sender')
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | orderOutcomeName   | <OrderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
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
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then API Core -  Wait for following order state:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | status     | <OrderStatus>                              |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1

    Examples:
      | HubName       | HubId       | TileName                 | TicketType | OrderOutcomeName        | OrderOutcome      | TicketStatus | OrderStatus |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | MISSING    | ORDER OUTCOME (MISSING) | CUSTOMER RECEIVED | RESOLVED     | COMPLETED   |

  @ForceSuccessOrder
  Scenario Outline: View Parcel of Resolved Missing Ticket Type and Outcome is Found-Inbounded (uid:a1767cec-1039-4743-8f8a-210e8cab9255)
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | orderOutcomeName   | <OrderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
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
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then API Core -  Wait for following order state:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | status     | <OrderStatus>                              |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has remained un-changed

    Examples:
      | HubName       | HubId       | TileName                 | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus | OrderStatus |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | MISSING    | ORDER OUTCOME (MISSING) | FOUND - INBOUND | RESOLVED     | TRANSIT     |

  @ForceSuccessOrder
  Scenario Outline: View Parcel of Resolved Missing Ticket Type and Outcome is Lost - No Response - Undeclared (uid:d26b7fca-7087-4fd1-af2b-15e4a7c6f7e6)
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | orderOutcomeName   | <OrderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
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
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then API Core -  Wait for following order state:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | status     | <OrderStatus>                              |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1

    Examples:
      | HubName       | HubId       | TileName                 | TicketType | OrderOutcomeName        | OrderOutcome                    | TicketStatus | OrderStatus |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | MISSING    | ORDER OUTCOME (MISSING) | LOST - NO RESPONSE - UNDECLARED | RESOLVED     | TRANSIT     |

  @ForceSuccessOrder
  Scenario Outline: View Parcel of Resolved Missing Ticket Type and Outcome is Lost - No Response - Declared (uid:e1957051-c693-420f-8650-073a9bcb023b)
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | orderOutcomeName   | <OrderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
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
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then API Core -  Wait for following order state:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | status     | <OrderStatus>                              |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1

    Examples:
      | HubName       | HubId       | TileName                 | TicketType | OrderOutcomeName        | OrderOutcome                  | TicketStatus | OrderStatus |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | MISSING    | ORDER OUTCOME (MISSING) | LOST - NO RESPONSE - DECLARED | RESOLVED     | CANCELLED   |

  @ForceSuccessOrder
  Scenario Outline: View Parcel of Cancelled Missing Ticket Type (uid:0c3ca8da-7671-4e3c-bd28-8adb6bfb07f5)
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | orderOutcomeName   | <OrderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
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
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then API Core -  Wait for following order state:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | status     | <OrderStatus>                              |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has remained un-changed

    Examples:
      | HubName       | HubId       | TileName                 | TicketType | OrderOutcomeName        | OrderOutcome       | TicketStatus | OrderStatus |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | MISSING    | ORDER OUTCOME (MISSING) | NV DID NOT RECEIVE | CANCELLED    | TRANSIT     |

  @ForceSuccessOrder
  Scenario Outline: View Parcel of Pending Missing Ticket Type
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | orderOutcomeName   | <OrderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1

    Examples:
      | HubName       | HubId       | TileName                 | TicketType | OrderOutcomeName        | OrderOutcome       | TicketStatus | OrderStatus |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | MISSING    | ORDER OUTCOME (MISSING) | NV DID NOT RECEIVE | RESOLVED     | TRANSIT     |


  @ForceSuccessOrder
  Scenario Outline: View Parcel in Hub after Update to Higher Size in Edit Order (uid:78bf5b4c-6222-42ff-9033-eb2bfedfab57)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And gets the count of the parcel by parcel size from the table: "<TableName>"
    And API Core - update order dimensions:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                    |
      | dimensions | {"width":1,"height":1,"length":1,"weight":1,"pricingWeight":1,"parcelSize":"XXLARGE"} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the parcel count for "<LowerSize>" is decreased by 1 in the table: "<TableName>"
    And verifies that the parcel count for "<UpperSize>" is increased by 1 in the table: "<TableName>"
    Then DB Station - Operator verifies that the size is also updated as "XXL" in station database for the parcel with trackingId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"

    Examples:
      | HubName       | HubId       | TileName                 | ModalName      | TableName      | LowerSize | UpperSize |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | Parcels in Hub | By Parcel Size | Small     | XX-Large  |

  @ForceSuccessOrder
  Scenario Outline: View Parcel in Hub after Update to Lower Size in Edit Order (uid:11e13743-5c66-4f81-abf8-9605d55de470)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"XXL", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And gets the count of the parcel by parcel size from the table: "<TableName>"
    And API Core - update order dimensions:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                  |
      | dimensions | {"width":1,"height":1,"length":1,"weight":1,"pricingWeight":1,"parcelSize":"SMALL"} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the parcel count for "<UpperSize>" is decreased by 1 in the table: "<TableName>"
    And verifies that the parcel count for "<LowerSize>" is increased by 1 in the table: "<TableName>"
    Then DB Station - Operator verifies that the size is also updated as "S" in station database for the parcel with trackingId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"

    Examples:
      | HubName       | HubId       | TileName                 | ModalName      | TableName      | UpperSize | LowerSize |
      | {hub-name-24} | {hub-id-24} | Number of parcels in hub | Parcels in Hub | By Parcel Size | XX-Large  | Small     |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op