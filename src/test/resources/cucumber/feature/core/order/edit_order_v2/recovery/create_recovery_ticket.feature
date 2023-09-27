@OperatorV2 @Core @EditOrderV2 @Recovery @CreateTicket
Feature: Create Recovery Ticket

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2
  Scenario: Operator Create Recovery Ticket For Return Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Van en-route to pickup |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | PENDING |
    When Operator create new recovery ticket on Edit Order V2 page:
      | trackingId                    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource                   | CUSTOMER COMPLAINT                    |
      | investigatingDepartment       | Recovery                              |
      | investigatingHub              | {hub-name}                            |
      | ticketType                    | PARCEL EXCEPTION                      |
      | ticketSubType                 | INACCURATE ADDRESS                    |
      | orderOutcomeInaccurateAddress | RESUME DELIVERY                       |
      | custZendeskId                 | 1                                     |
      | shipperZendeskId              | 1                                     |
      | ticketNotes                   | GENERATED                             |
    When Operator verifies that success react notification displayed:
      | top | Ticket has been created! |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |
    And Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | TICKET CREATED |
      | UPDATE STATUS  |
      | RESCHEDULE     |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_OLD_TRANSACTION"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_NEW_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_PP_OLD_TRANSACTION.id}        |
      | status  | Fail                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id      | {KEY_PP_NEW_TRANSACTION.id} |
      | status  | Pending                     |
      | routeId | null                        |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_PP_OLD_TRANSACTION.waypointId} |
      | status   | Fail                                |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}  |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_PP_NEW_TRANSACTION.waypointId} |
      | status   | Pending                             |
      | routeId  | null                                |

  @ArchiveRouteCommonV2
  Scenario: Operator Create Recovery Ticket For Pending Reschedule Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
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
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    And DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | Delivery fail                      |
      | granularStatus | Pending Reschedule                 |
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | INACCURATE ADDRESS                         |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (INACCURATE ADDRESS)         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | PARCEL EXCEPTION                           |
      | ticketSubType      | INACCURATE ADDRESS                         |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    And DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | On Hold                            |
      | granularStatus | On Hold                            |
    And API Core - Operator verify that "TICKET_CREATED" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_OLD_TRANSACTION"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_NEW_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_DD_OLD_TRANSACTION.id}        |
      | status  | Fail                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id      | {KEY_DD_NEW_TRANSACTION.id} |
      | status  | Pending                     |
      | routeId | null                        |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_DD_OLD_TRANSACTION.waypointId} |
      | status   | Fail                                |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}  |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_DD_NEW_TRANSACTION.waypointId} |
      | status   | Pending                             |
      | routeId  | null                                |

  @ArchiveRouteCommonV2
  Scenario: Operator Create Recovery Ticket For Pickup Fail
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
    Then DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | Pickup fail                        |
      | granularStatus | Pickup fail                        |
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | INACCURATE ADDRESS                         |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (INACCURATE ADDRESS)         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | PARCEL EXCEPTION                           |
      | ticketSubType      | INACCURATE ADDRESS                         |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    And DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | On Hold                            |
      | granularStatus | On Hold                            |
    And API Core - Operator verify that "TICKET_CREATED" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_OLD_TRANSACTION"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_NEW_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_PP_OLD_TRANSACTION.id}        |
      | status  | Fail                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id      | {KEY_PP_NEW_TRANSACTION.id} |
      | status  | Pending                     |
      | routeId | null                        |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_PP_OLD_TRANSACTION.waypointId} |
      | status   | Fail                                |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}  |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_PP_NEW_TRANSACTION.waypointId} |
      | status   | Pending                             |
      | routeId  | null                                |

  Scenario: Operator Create and Search Recovery Ticket For Hub Inbound Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    Then DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | Transit                            |
      | granularStatus | Arrived at Sorting Hub             |
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                          |
      | eventType | UPDATE_STATUS                                                                                                                                                               |
      | eventData | {"granular_status":{"old_value":"Pending Pickup","new_value":"Arrived at Sorting Hub"},"order_status":{"old_value":"Pending","new_value":"Transit"},"reason":"HUB_INBOUND"} |
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | INACCURATE ADDRESS                         |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (INACCURATE ADDRESS)         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | PARCEL EXCEPTION                           |
      | ticketSubType      | INACCURATE ADDRESS                         |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    Then DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | On Hold                            |
      | granularStatus | On Hold                            |
    And API Core - Operator verify that "TICKET_CREATED" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                       |
      | eventType | UPDATE_STATUS                                                                                                                                                            |
      | eventData | {"granular_status":{"old_value":"Arrived at Sorting Hub","new_value":"On Hold"},"order_status":{"old_value":"Transit","new_value":"On Hold"},"reason":"TICKET_CREATION"} |

  @ArchiveRouteCommonV2
  Scenario: Operator Create and Search Recovery Ticket For Route Inbound Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                      |
      | routes     | KEY_DRIVER_ROUTES                                                               |
      | jobType    | TRANSACTION                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                         |
      | jobMode    | PICK_UP                                                                         |
    When API Sort - Operator route inbound
      | trackingId          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                           |
      | hubId               | {hub-id}                                                                                                                                             |
      | routeId             | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                   |
      | routeInboundRequest | {"scan": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","inbound_type": "SORTING_HUB","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"hub_id":{hub-id}} |
    Then DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | Transit                            |
      | granularStatus | Arrived at Sorting Hub             |
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | INACCURATE ADDRESS                         |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (INACCURATE ADDRESS)         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | PARCEL EXCEPTION                           |
      | ticketSubType      | INACCURATE ADDRESS                         |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    And DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | On Hold                            |
      | granularStatus | On Hold                            |
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                       |
      | eventType | UPDATE_STATUS                                                                                                                                                            |
      | eventData | {"granular_status":{"old_value":"Arrived at Sorting Hub","new_value":"On Hold"},"order_status":{"old_value":"Transit","new_value":"On Hold"},"reason":"TICKET_CREATION"} |

  @ArchiveRouteCommonV2
  Scenario: Operator Create and Search Recovery Ticket For Outbound Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And DB Sort - get hub by hub name "{KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And Operator waits for 10 seconds
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                            |
      | hubId              | {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}                                                              |
      | taskId             | 1                                                                                                |
    Then DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | Transit                            |
      | granularStatus | Arrived at Sorting Hub             |
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                               |
      | eventType | PARCEL_ROUTING_SCAN                                                                                                                              |
      | eventData | {"hub_id": {KEY_SORT_LIST_OF_HUBS_DB[1].hubId},"hub_location_types": ["DESTINATION"],"scan_value": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"} |
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}              |
      | eventType | OUTBOUND_SCAN                                   |
      | eventData | {"hub_id": {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}} |
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | MISSING                                    |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)                    |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | MISSING                                    |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    And DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | On Hold                            |
      | granularStatus | On Hold                            |
    And API Core - Operator verify that "TICKET_CREATED" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                       |
      | eventType | UPDATE_STATUS                                                                                                                                                            |
      | eventData | {"granular_status":{"old_value":"Arrived at Sorting Hub","new_value":"On Hold"},"order_status":{"old_value":"Transit","new_value":"On Hold"},"reason":"TICKET_CREATION"} |
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}               |
      | eventType | PULL_OUT_OF_ROUTE                                |
      | eventData | {"route_id": {KEY_LIST_OF_CREATED_ROUTES[1].id}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_NEW_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_DD_NEW_TRANSACTION.id} |
      | status  | Pending                     |
      | routeId | null                        |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_DD_NEW_TRANSACTION.waypointId} |
      | status   | Pending                             |
      | routeId  | null                                |

  Scenario: Operator Create and Search Recovery Ticket For Warehouse Sweep Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And DB Sort - get hub by hub name "{KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}"
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                            |
      | hubId              | {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}                                                              |
      | taskId             | 1                                                                                                |
    Then DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | Transit                            |
      | granularStatus | Arrived at Sorting Hub             |
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                               |
      | eventType | PARCEL_ROUTING_SCAN                                                                                                                              |
      | eventData | {"hub_id": {KEY_SORT_LIST_OF_HUBS_DB[1].hubId},"hub_location_types": ["DESTINATION"],"scan_value": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"} |
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | MISSING                                    |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)                    |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | MISSING                                    |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    And DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | On Hold                            |
      | granularStatus | On Hold                            |
    And API Core - Operator verify that "TICKET_CREATED" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                       |
      | eventType | UPDATE_STATUS                                                                                                                                                            |
      | eventData | {"granular_status":{"old_value":"Arrived at Sorting Hub","new_value":"On Hold"},"order_status":{"old_value":"Transit","new_value":"On Hold"},"reason":"TICKET_CREATION"} |

  @ArchiveRouteCommonV2
  Scenario: Operator Create and Search Recovery Ticket For Driver Pickup Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobType    | RESERVATION                                                                                                               |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    Then DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | Transit                            |
      | granularStatus | En-route to Sorting Hub            |
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                |
      | eventType | UPDATE_STATUS                                                                                                                                                                     |
      | eventData | {"granular_status":{"old_value":"Pending Pickup","new_value":"En-route to Sorting Hub"},"order_status":{"old_value":"Pending","new_value":"Transit"},"reason":"BATCH_POD_UPDATE"} |
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}               |
      | eventType | DRIVER_PICKUP_SCAN                               |
      | eventData | {"route_id": {KEY_LIST_OF_CREATED_ROUTES[1].id}} |
    And API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketType         | PARCEL EXCEPTION                           |
      | subTicketType      | INACCURATE ADDRESS                         |
      | entrySource        | CUSTOMER COMPLAINT                         |
      | orderOutcomeName   | ORDER OUTCOME (INACCURATE ADDRESS)         |
      | investigatingParty | 456                                        |
      | investigatingHubId | {hub-id}                                   |
      | shipperZendeskId   | 1                                          |
      | custZendeskId      | 1                                          |
      | ticketNotes        | GENERATED                                  |
      | creatorUserId      | {ticketing-creator-user-id}                |
      | creatorUserName    | {ticketing-creator-user-name}              |
      | creatorUserEmail   | {ticketing-creator-user-email}             |
    When API Recovery - Operator search recovery ticket:
      | request | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"]} |
    Then API Recovery - verify ticket details:
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ticketId           | {KEY_RECOVERY_SEARCH_TICKET_RESULT[1].id}  |
      | status             | PENDING                                    |
      | ticketType         | PARCEL EXCEPTION                           |
      | ticketSubType      | INACCURATE ADDRESS                         |
      | investigatingParty | Recovery                                   |
      | sourceOfEntry      | CUSTOMER COMPLAINT                         |
    And DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | On Hold                            |
      | granularStatus | On Hold                            |
    And API Core - Operator verify that "TICKET_CREATED" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                        |
      | eventType | UPDATE_STATUS                                                                                                                                                             |
      | eventData | {"granular_status":{"old_value":"En-route to Sorting Hub","new_value":"On Hold"},"order_status":{"old_value":"Transit","new_value":"On Hold"},"reason":"TICKET_CREATION"} |