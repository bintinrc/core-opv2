@OperatorV2 @Core @Inbounding @RouteInbound @RouteInboundExpectedScans @RouteInboundExpectedScansPart2
Feature: Route Inbound Expected Scans

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Return Pickup Success
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                              |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
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
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
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
      | wpCompleted | 1                                         |
      | wpTotal     | 1                                         |
    When Operator open Completed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Completed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Completed dialog
    Then Operator verify Orders table in Completed dialog using data below:
      | trackingId                            | stampId | location                                           | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineFromAddress} | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close Completed dialog on Route Inbound page
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans  | 1 |
      | parcelProcessedTotal  | 1 |
      | c2cReturnPickupsScans | 1 |
      | c2cReturnPickupsTotal | 1 |
    When Operator open C2C Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C / Return Pickups Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                            | stampId | location                                           | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineFromAddress} | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close C2C / Return Pickups dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                            | stampId | location                                           | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineFromAddress} | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | -                                     |
      | reason     | Duplicate                             |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Reservation Pickup Success
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
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                               |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                 |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                |
      | jobType         | RESERVATION                                                                      |
      | jobAction       | SUCCESS                                                                          |
      | jobMode         | PICK_UP                                                                          |
      | globalShipperId | {shipper-v4-id}                                                                  |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    Given Operator go to menu Inbounding -> Route Inbound
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
      | wpCompleted | 1                                         |
      | wpTotal     | 1                                         |
    When Operator open Completed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Completed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Completed dialog
    Then Operator verify Orders table in Completed dialog using data below:
      | trackingId                            | stampId | location                                                        | type                  | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ADDRESSES[1].getFullSpaceSeparatedAddress} | Pick Up (Reservation) | Success | 0        | Inbounded          |
    When Operator close Completed dialog on Route Inbound page
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans    | 1 |
      | parcelProcessedTotal    | 1 |
      | reservationPickupsScans | 1 |
      | reservationPickupsTotal | 1 |
    When Operator open Reservation Pickups dialog on Route Inbound page
    Then Operator verify Inbounded Orders record using data below:
      | trackingId    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}    |
      | shipperName   | {shipper-v4-name}                        |
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    When Operator close Reservation Pickups dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                            | stampId | location                                                        | type                  | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ADDRESSES[1].getFullSpaceSeparatedAddress} | Pick Up (Reservation) | Success | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | -                                     |
      | reason     | Duplicate                             |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Failed Delivery (Valid)
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
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
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":84}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 84                                                                                                  |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
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
      | wpFailed    | 1                                         |
      | wpCompleted | 0                                         |
      | wpTotal     | 1                                         |
    When Operator open Failed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed dialog
    Then Operator verify Orders table in Failed dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Normal) | Failed | 0        | Inbounded          |
    When Operator close Failed dialog on Route Inbound page
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans       | 1 |
      | parcelProcessedTotal       | 1 |
      | failedDeliveriesValidScans | 1 |
      | failedDeliveriesValidTotal | 1 |
    When Operator open Failed Deliveries Valid dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Deliveries Valid dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Deliveries Valid dialog
    Then Operator verify Orders table in Failed Deliveries Valid dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Normal) | Failed | 0        | Inbounded          |
    When Operator close Failed Deliveries Valid dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Normal) | Failed | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Failed Delivery (Valid)               |
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | -                                     |
      | reason     | Duplicate                             |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Failed Delivery (Invalid)
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
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
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":11}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 11                                                                                                  |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
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
      | wpFailed    | 1                                         |
      | wpCompleted | 0                                         |
      | wpTotal     | 1                                         |
    When Operator open Failed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed dialog
    Then Operator verify Orders table in Failed dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Normal) | Failed | 1        | Inbounded          |
    When Operator close Failed dialog on Route Inbound page
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans         | 1 |
      | parcelProcessedTotal         | 1 |
      | failedDeliveriesInvalidScans | 1 |
      | failedDeliveriesInvalidTotal | 1 |
    When Operator open Failed Deliveries Invalid dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Deliveries Invalid dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Deliveries Invalid dialog
    Then Operator verify Orders table in Failed Deliveries Invalid dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Normal) | Failed | 1        | Inbounded          |
    When Operator close Failed Deliveries Invalid dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Normal) | Failed | 1        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Failed Delivery (Invalid)             |
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | -                                     |
      | reason     | Duplicate                             |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Multiple Global Inbounds on Attempted Pickup & Delivery
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                              |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
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
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
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
      | wpCompleted | 1                                         |
      | wpTotal     | 1                                         |
    When Operator open Completed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Completed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Completed dialog
    Then Operator verify Orders table in Completed dialog using data below:
      | trackingId                            | stampId | location                                           | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineFromAddress} | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close Completed dialog on Route Inbound page
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans  | 1 |
      | parcelProcessedTotal  | 1 |
      | c2cReturnPickupsScans | 1 |
      | c2cReturnPickupsTotal | 1 |
    When Operator open C2C Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C / Return Pickups Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                            | stampId | location                                           | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineFromAddress} | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close C2C / Return Pickups dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                            | stampId | location                                           | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineFromAddress} | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Return Pickup                         |
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | -                                     |
      | reason     | Duplicate                             |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":84}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 84                                                                                                  |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator refresh page
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[2].id}        |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[2].createdAt} |
      | wpPending   | 0                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 1                                         |
      | wpCompleted | 0                                         |
      | wpTotal     | 1                                         |
    When Operator open Failed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed dialog
    Then Operator verify Orders table in Failed dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Return) | Failed | 0        | Inbounded          |
    When Operator close Failed dialog on Route Inbound page
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans       | 1 |
      | parcelProcessedTotal       | 1 |
      | failedDeliveriesValidScans | 1 |
      | failedDeliveriesValidTotal | 1 |
    When Operator open Failed Deliveries Valid dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Deliveries Valid dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Deliveries Valid dialog
    Then Operator verify Orders table in Failed Deliveries Valid dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Return) | Failed | 0        | Inbounded          |
    When Operator close Failed Deliveries Valid dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                            | stampId | location                                         | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress} | Delivery (Return) | Failed | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | Failed Delivery (Valid)               |
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status     | -                                     |
      | reason     | Duplicate                             |
