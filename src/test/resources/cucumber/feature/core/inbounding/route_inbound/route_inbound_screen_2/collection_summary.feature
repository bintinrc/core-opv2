@OperatorV2 @Core @Inbounding @RouteInbound @CollectionSummary
Feature: Collection Summary

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: View Cash Collection
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                             |
      | routes          | KEY_DRIVER_ROUTES                                                                                                                      |
      | jobType         | TRANSACTION                                                                                                                            |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS", "cod":{KEY_LIST_OF_CREATED_ORDERS[1].cod.goodsAmount}}] |
      | jobAction       | SUCCESS                                                                                                                                |
      | jobMode         | DELIVERY                                                                                                                               |
      | globalShipperId | {shipper-v4-id}                                                                                                                        |
    When API Core - Operator create new COD Inbound for created order:
      | routeId   | {KEY_LIST_OF_CREATED_ROUTES[1].id}              |
      | codAmount | {KEY_LIST_OF_CREATED_ORDERS[1].cod.goodsAmount} |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator open Money Collection history dialog on Route Inbound page
    Then Operator verify Money Collection history record using data below:
      | processedAmount | {KEY_CORE_ROUTE_CASH_INBOUND_COD.amountCollected} |
      | processedType   | Cash                                              |
      | receiptNo       | {KEY_CORE_ROUTE_CASH_INBOUND_COD.receiptNo}       |
    And Operator verify Money Collection Collected Order record using data below:
      | processedCodAmount    | {KEY_LIST_OF_CREATED_ORDERS[1].cod.goodsAmount} |
      | processedCodCollected | {KEY_LIST_OF_CREATED_ORDERS[1].cod.goodsAmount} |
      | trackingId            | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}           |
      | customType            | Delivery (Normal)                               |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: View Failed Parcels
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":11}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 11                                                                                                  |
      | globalShipperId | {shipper-v4-id}                                                                                     |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":11}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 11                                                                                                  |
      | globalShipperId | {shipper-v4-id}                                                                                     |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 0                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 2                                         |
      | wpCompleted | 0                                         |
      | wpTotal     | 2                                         |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | status     | Failed Delivery (Invalid)             |
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open Failed Parcels dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Parcels dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Parcels dialog
    Then Operator verify Orders table in Failed Parcels dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Normal) | Failed | 1        |                    |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |         | {KEY_LIST_OF_CREATED_ORDERS[2].to1LineToAddress} | Delivery (Return) | Failed | 1        | Inbounded          |

  @ArchiveRouteCommonV2 @MediumPriority @wip
  Scenario: View Return Parcels
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFrom        | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo          | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                      |
      | routes          | KEY_DRIVER_ROUTES                                                               |
      | jobType         | TRANSACTION                                                                     |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS"}] |
      | jobAction       | SUCCESS                                                                         |
      | jobMode         | PICK_UP                                                                         |
      | globalShipperId | {shipper-v4-id}                                                                 |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFrom        | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo          | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                      |
      | routes          | KEY_DRIVER_ROUTES                                                               |
      | jobType         | TRANSACTION                                                                     |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"SUCCESS"}] |
      | jobAction       | SUCCESS                                                                         |
      | jobMode         | PICK_UP                                                                         |
      | globalShipperId | {shipper-v4-id}                                                                 |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 0                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 0                                         |
      | wpCompleted | 2                                         |
      | wpTotal     | 2                                         |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | status     | Return Pickup                         |
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open C2C + Return dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C + Return dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C + Return dialog
    Then Operator verify Orders table in C2C + Return dialog using data below:
      | trackingId                            | stampId | location                                           | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineFromAddress} | Pick Up (Return) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |         | {KEY_LIST_OF_CREATED_ORDERS[2].to1LineFromAddress} | Pick Up (Return) | Success | 0        | Inbounded          |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: View Reservations
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                     |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","global_shipper_id":{shipper-v4-id}, "action": "SUCCESS"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                    |
      | jobType         | RESERVATION                                                                                                          |
      | jobAction       | SUCCESS                                                                                                              |
      | jobMode         | PICK_UP                                                                                                              |
      | globalShipperId | {shipper-v4-id}                                                                                                      |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Reservation Pickup                    |
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open Reservations dialog on Route Inbound page
    Then Operator verify Shippers Info in Reservations dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Reservations dialog
    Then Operator verify Reservations table in Total Waypoints dialog using data below:
      | reservationId                            | location                                                            | readyToLatestTime                                                                     | approxVolume                                       | status  | receivedParcels |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithSpaceDelimiter} | {gradle-current-date-yyyy-MM-dd} 15:00:00 - {gradle-current-date-yyyy-MM-dd} 18:00:00 | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | Success | 1               |
    Then Operator verify Orders table in Reservations dialog using data below:
      | trackingId                            | stampId | location                                                            | type                  | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithSpaceDelimiter} | Pick Up (Reservation) | Success | 0        | Inbounded          |
    And Operator close Reservations dialog on Route Inbound page
