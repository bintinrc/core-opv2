@OperatorV2 @Core @EditOrderV2 @RTS @RTSPart2
Feature: RTS

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator not Allowed to RTS Order Tagged to a DP
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{dp-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify menu item "Delivery" > "Return to Sender" is disabled on Edit Order V2 page

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator RTS Order with Allowed Granular Status - On Vehicle for Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | {"hubId":{hub-id} }                   |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | On Vehicle for Delivery |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order V2 page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that success react notification displayed:
      | top    | 1 order(s) RTS-ed                           |
      | bottom | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | status | PENDING                                        |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id     | {KEY_TRANSACTION.id} |
      | status | Fail                 |
    And DB Core - verify waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Routed                       |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id       | {KEY_TRANSACTION.id}                           |
      | status   | Pending                                        |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}      |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1}   |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2}   |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode}   |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}    |
    When DB Core - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "RTS", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    And DB Core - verify waypoints record:
      | id            | {KEY_TRANSACTION.waypointId}                 |
      | status        | Pending                                      |
      | routeId       | null                                         |
      | seqNo         | null                                         |
      | address1      | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | address2      | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | postcode      | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | country       | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}        |
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    And DB Addressing - verify zones record:
      | legacyZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId} |
      | type         | RTS                                   |

  @MediumPriority
  Scenario Outline: Operator RTS Order with Active PETS Ticket Damaged/Missing - <DatasetName>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | <ticketType>                          |
      | orderOutcomeName   | <orderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    When Operator RTS order on Edit Order V2 page using data below:
      | reason   | Nobody at address    |
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that success react notification displayed:
      | top    | 1 order(s) RTS-ed                           |
      | bottom | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | status | PENDING                                        |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id       | {KEY_TRANSACTION.id}                           |
      | status   | Pending                                        |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}      |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1}   |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2}   |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode}   |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}    |
    When DB Core - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "RTS", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    And DB Core - verify waypoints record:
      | id            | {KEY_TRANSACTION.waypointId}                 |
      | status        | Pending                                      |
      | routeId       | null                                         |
      | seqNo         | null                                         |
      | address1      | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | address2      | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | postcode      | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | country       | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}        |
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    And DB Addressing - verify zones record:
      | legacyZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId} |
      | type         | RTS                                   |
    Examples:
      | DatasetName           | ticketType | orderOutcomeName            |
      | Ticket Type = MISSING | MISSING    | ORDER OUTCOME (MISSING)     |
      | Ticket Type = DAMAGED | DAMAGED    | ORDER OUTCOME (NEW_DAMAGED) |

  @MediumPriority
  Scenario Outline: Operator RTS Order with On Hold Resolved PETS Ticket Non-Damaged/Missing - SELF COLLECTION
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | <ticketType>                          |
      | orderOutcomeName   | <orderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | status           | RESOLVED                                |
      | orderOutcomeName | <orderOutcomeName>                      |
      | customFieldId    | <resolveCustomFieldId>                  |
      | outcome          | <resolveOutcome>                        |
      | reporterId       | {ticketing-creator-user-id}             |
      | reporterName     | {ticketing-creator-user-name}           |
      | reporterEmail    | {ticketing-creator-user-email}          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    When Operator RTS order on Edit Order V2 page using data below:
      | reason   | Nobody at address    |
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that success react notification displayed:
      | top    | 1 order(s) RTS-ed                           |
      | bottom | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | status | PENDING                                        |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id       | {KEY_TRANSACTION.id}                           |
      | status   | Pending                                        |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}      |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1}   |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2}   |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode}   |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}    |
    And DB Core - verify waypoints record:
      | id       | {KEY_TRANSACTION.waypointId}                 |
      | status   | Pending                                      |
      | routeId  | null                                         |
      | seqNo    | null                                         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    Examples:
      | ticketType      | orderOutcomeName                | resolveOutcome | resolveCustomFieldId |
      | SELF COLLECTION | ORDER OUTCOME (SELF COLLECTION) | RE-DELIVER     | 24291519             |

  @MediumPriority
  Scenario Outline: Operator RTS Order with On Hold Resolved PETS Ticket Non-Damaged/Missing - <DatasetName>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | <ticketType>                          |
      | subTicketType      | <ticketSubType>                       |
      | orderOutcomeName   | <orderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    And  API Recovery - Operator update recovery ticket:
      | ticketId         | {KEY_CREATED_RECOVERY_TICKET.ticket.id} |
      | status           | RESOLVED                                |
      | orderOutcomeName | <orderOutcomeName>                      |
      | customFieldId    | <resolveCustomFieldId>                  |
      | outcome          | <resolveOutcome>                        |
      | reporterId       | {ticketing-creator-user-id}             |
      | reporterName     | {ticketing-creator-user-name}           |
      | reporterEmail    | {ticketing-creator-user-email}          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    When Operator RTS order on Edit Order V2 page using data below:
      | reason   | Nobody at address    |
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that success react notification displayed:
      | top    | 1 order(s) RTS-ed                           |
      | bottom | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | status | PENDING                                        |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id       | {KEY_TRANSACTION.id}                           |
      | status   | Pending                                        |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}      |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1}   |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2}   |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode}   |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}    |
    And DB Core - verify waypoints record:
      | id       | {KEY_TRANSACTION.waypointId}                 |
      | status   | Pending                                      |
      | routeId  | null                                         |
      | seqNo    | null                                         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    Examples:
      | DatasetName                    | ticketType       | ticketSubType     | orderOutcomeName                  | resolveOutcome              | resolveCustomFieldId |
      | Ticket Type = SHIPPER ISSUE    | SHIPPER ISSUE    | DUPLICATE PARCEL  | ORDER OUTCOME (SHIPPER EXCEPTION) | REPACKED/RELABELLED TO SEND | 24317247             |
      | Ticket Type = PARCEL EXCEPTION | PARCEL EXCEPTION | CUSTOMER REJECTED | ORDER OUTCOME (CUSTOMER REJECTED) | RESUME DELIVERY             | 24317569             |
      | Ticket Type = PARCEL ON HOLD   | PARCEL ON HOLD   | SHIPPER REQUEST   | ORDER OUTCOME (SHIPPER REQUEST)   | RESUME DELIVERY             | 24269291             |

  @MediumPriority
  Scenario Outline: Operator Not Allowed to RTS Order With Active PETS Ticket Non-Damaged/Missing - <DatasetName>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | <ticketType>                          |
      | subTicketType      | <ticketSubType>                       |
      | orderOutcomeName   | <orderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    When Operator RTS order on Edit Order V2 page using data below:
      | reason   | Nobody at address    |
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                               |
      | bottom | ^.*Error Message: An order with status 'ON_HOLD' can be RTS only when last ticket is of type DAMAGED or MISSING.* |
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 0                                  |
    Examples:
      | DatasetName                    | ticketType       | ticketSubType     | orderOutcomeName                  |
      | Ticket Type = SHIPPER ISSUE    | SHIPPER ISSUE    | DUPLICATE PARCEL  | ORDER OUTCOME (SHIPPER EXCEPTION) |
      | Ticket Type = PARCEL EXCEPTION | PARCEL EXCEPTION | CUSTOMER REJECTED | ORDER OUTCOME (CUSTOMER REJECTED) |
      | Ticket Type = PARCEL ON HOLD   | PARCEL ON HOLD   | SHIPPER REQUEST   | ORDER OUTCOME (SHIPPER REQUEST)   |

  @MediumPriority
  Scenario Outline: Operator Not Allowed to RTS Order With Active PETS Ticket Non-Damaged/Missing - SELF COLLECTION
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | <ticketType>                          |
      | orderOutcomeName   | <orderOutcomeName>                    |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    When Operator RTS order on Edit Order V2 page using data below:
      | reason   | Nobody at address    |
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                               |
      | bottom | ^.*Error Message: An order with status 'ON_HOLD' can be RTS only when last ticket is of type DAMAGED or MISSING.* |
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 0                                  |
    Examples:
      | ticketType      | orderOutcomeName                |
      | SELF COLLECTION | ORDER OUTCOME (SELF COLLECTION) |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Routed - Edit Delivery Address - New Address Belongs To Standard Zone
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION_BEFORE"
    And Operator RTS order on Edit Order V2 page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
      | country      | Singapore                      |
      | city         | Singapore                      |
      | address1     | 50 Amber Rd                    |
      | postalCode   | 439888                         |
    Then Operator verifies that success react notification displayed:
      | top | 1 order(s) RTS-ed |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION_AFTER"
    Then DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION_BEFORE.id}         |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}  |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | DD                                  |
      | status     | Fail                                |
    Then DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION_AFTER.id}         |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
      | routeId    | null                               |
      | address1   | 50 Amber Rd                        |
      | postcode   | 439888                             |
      | city       | Singapore                          |
      | country    | Singapore                          |
    Then DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | seqNo   | null                               |
      | routeId | null                               |
      | status  | Pending                            |
    When DB Core - operator get waypoints details for "{KEY_TRANSACTION_AFTER.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "RTS", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verifies order details on Edit Order V2 page:
      | zone | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
    And DB Core - verify waypoints record:
      | id            | {KEY_TRANSACTION_AFTER.waypointId}    |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId} |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator RTS an Order on Edit Order Page - PPNT Tied To DP
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD", "address2":"addsrt", "postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{lodge-in-dp-id}"
    And API DP - DP lodge in order:
      | lodgeInRequest | {"dp_id":{lodge-in-dp-id},"reservations":[{"shipper_id":{lodge-in-shipper-legacy-id},"tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"}]} |
    And Operator waits for 10 seconds
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending                              |
      | granularStatus | Pending Pickup at Distribution Point |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And Operator refresh page
    And Operator click Delivery -> Return to Sender on Edit Order V2 page
    And Operator verify "Order has DP attached to Pickup transactions. Contact and address details disabled" RTS hint is displayed on Edit Order V2 page
    And Operator RTS order on Edit Order V2 page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that success react notification displayed:
      | top    | 1 order(s) RTS-ed                           |
      | bottom | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    Then DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION.id}               |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | type       | DD                                 |
      | status     | Pending                            |
      | routeId    | null                               |
      | address1   | 233E ST. JOHN'S ROAD               |
      | address2   | addsrt                             |
      | postcode   | 757995                             |
      | country    | SG                                 |
    And DB Core - verify waypoints record:
      | id       | {KEY_TRANSACTION.waypointId} |
      | status   | Pending                      |
      | routeId  | null                         |
      | seqNo    | null                         |
      | address1 | 233E ST. JOHN'S ROAD         |
      | address2 | addsrt                       |
      | postcode | 757995                       |
      | country  | SG                           |