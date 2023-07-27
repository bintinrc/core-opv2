@StationManagement @AgeingParcelsPart1
Feature: Ageing Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | OrderOutcomeName        | TicketSubType      | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | ORDER OUTCOME (DAMAGED) | IMPROPER PACKAGING | CREATED      |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | OrderOutcomeName                 | TicketSubType   | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | ORDER OUTCOME (CUSTOMER REQUEST) | SHIPPER REQUEST | CREATED      |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | subTicketType      | <TicketSubType>                       |
      | orderOutcomeName   | <OrderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcomeName                   | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | CREATED      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | subTicketType      | <TicketSubType>                       |
      | orderOutcomeName   | <OrderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | RESUME DELIVERY | CREATED      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of On Hold Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | OrderOutcomeName        | TicketSubType      | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | ORDER OUTCOME (DAMAGED) | IMPROPER PACKAGING | ON HOLD      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of On Hold Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | ON HOLD      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of On Hold Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RESUME DELIVERY | ON HOLD      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of On Hold Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | RESUME DELIVERY | ON HOLD      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of In Progress Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome     | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV LIABLE - FULL | IN PROGRESS  |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of In Progress Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | IN PROGRESS  |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of In Progress Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RESUME DELIVERY | IN PROGRESS  |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of In Progress Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
      | orderOutcomeName | {KEY_CREATED_ORDER_OUTCOME}              |
      | customFieldId    | {KEY_LIST_OF_TICKET_CUSTOM_FIELD_IDS[1]} |
      | reporterId       | {ticketing-creator-user-id}              |
      | reporterName     | {ticketing-creator-user-name}            |
      | reporterEmail    | {ticketing-creator-user-email}           |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | RESUME DELIVERY | IN PROGRESS  |

  @ForceSuccessOrder @Set1
  Scenario Outline: Missing Ticket Not Appears in Ageing Parcel
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |


    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | MISSING    | ORDER OUTCOME (MISSING) | LOST - DECLARED | IN PROGRESS  |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | RESOLVED     |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Missing
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | MISSING    | IMPROPER PACKAGING | ORDER OUTCOME (MISSING) | FOUND - INBOUND | RESOLVED     |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | RESOLVED     |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RESUME DELIVERY | RESOLVED     |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome                | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | REPACKED/RELABELLED TO SEND | RESOLVED     |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | CANCELLED    |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Missing
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | <HubId>                               |
      | ticketType         | <TicketType>                          |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | MISSING    | IMPROPER PACKAGING | ORDER OUTCOME (MISSING) | FOUND - INBOUND | CANCELLED    |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | CANCELLED    |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RESUME DELIVERY | CANCELLED    |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome                | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | REPACKED/RELABELLED TO SEND | CANCELLED    |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Shipper Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcomeName        | OrderOutcome          | TicketStatus    |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | ORDER OUTCOME (DAMAGED) | NV TO REPACK AND SHIP | PENDING SHIPPER |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Shipper Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcomeName                | OrderOutcome    | TicketStatus    |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | ORDER OUTCOME (SHIPPER REQUEST) | RESUME DELIVERY | PENDING SHIPPER |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Shipper Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcomeName                   | OrderOutcome    | TicketStatus    |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | ORDER OUTCOME (INACCURATE ADDRESS) | RESUME DELIVERY | PENDING SHIPPER |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Shipper Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcomeName                 | OrderOutcome                | TicketStatus    |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | ORDER OUTCOME (DUPLICATE PARCEL) | REPACKED/RELABELLED TO SEND | PENDING SHIPPER |

  @ForceSuccessOrder @Set1
  Scenario Outline: Search Ageing Parcel in Hub by Recovery Ticket Type
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 3 days ago, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "Please Confirm ETA of FSR Parcels to Proceed" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator selects the following values in the modal pop up
      | Recovery Ticket Type | <TicketType> |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |


    Examples:
      | HubName       | HubId       | TicketType | OrderOutcomeName        | Status   | KeepCurrentOrderOutcome | Outcome           | TileName              | ModalName             | TicketStatus |
      | {hub-name-18} | {hub-id-18} | DAMAGED    | ORDER OUTCOME (DAMAGED) | RESOLVED | No                      | LOST - UNDECLARED | Ageing parcels in hub | Ageing Parcels in Hub | CREATED      |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op