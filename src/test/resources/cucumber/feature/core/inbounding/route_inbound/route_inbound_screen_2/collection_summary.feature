@OperatorV2 @Core @Inbounding @RouteInbound @CollectionSummary
Feature: Collection Summary

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2
  Scenario: View Cash Collection (uid:0dccc613-ddc8-4c11-bee2-ed3d15a50590)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver deliver the created parcel successfully
    When API Operator create new COD for created order
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    And Operator open Money Collection history dialog on Route Inbound page
    Then Operator verify Money Collection history record using data below:
      | processedAmount | {KEY_ROUTE_CASH_INBOUND_COD.amountCollected} |
      | processedType   | Cash                                         |
      | receiptNo       | {KEY_ROUTE_CASH_INBOUND_COD.receiptNumber}   |
    And Operator verify Money Collection Collected Order record using data below:
      | processedCodAmount    | {KEY_COD_GOODS_AMOUNT}                     |
      | processedCodCollected | 0                                          |
      | trackingId            | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customType            | Delivery (Normal)                          |

  @ArchiveRouteCommonV2
  Scenario: View Failed Parcels
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels
    And API Operator get order details
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE           |
      | driverName  | {ninja-driver-name}              |
      | hubName     | {hub-name}                       |
      | routeDate   | {gradle-current-date-yyyy-MM-dd} |
      | wpPending   | 0                                |
      | wpPartial   | 0                                |
      | wpFailed    | 2                                |
      | wpCompleted | 0                                |
      | wpTotal     | 2                                |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | status     | Failed Delivery (Valid)                    |
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open Failed Parcels dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Parcels dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Parcels dialog
    Then Operator verify Orders table in Failed Parcels dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Failed | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Return) | Failed | 0        | Inbounded          |

  @ArchiveRouteCommonV2
  Scenario: View Return Parcels (uid:2a66a597-c949-49fd-912e-89cfa1f072ce)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
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
    Given API Shipper create multiple V4 orders using data below:
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
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                      |
      | routes     | KEY_DRIVER_ROUTES                                                               |
      | jobType    | TRANSACTION                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                         |
      | jobMode    | PICK_UP                                                                         |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 2                      |
      | wpTotal     | 2                      |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | status     | Return Pickup                              |
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open C2C + Return dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C + Return dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C + Return dialog
    Then Operator verify Orders table in C2C + Return dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | CREATED_ORDER_FROM_2 | Pick Up (Return) | Success | 0        | Inbounded          |

  @ArchiveRouteCommonV2
  Scenario: View Reservations (uid:7b009bad-45fa-4783-a33a-f4525b0a989a)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add reservation pick-up to the route
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | Reservation Pickup                         |
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open Reservations dialog on Route Inbound page
    Then Operator verify Shippers Info in Reservations dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Reservations dialog
    Then Operator verify Reservations table in Total Waypoints dialog using data below:
      | reservationId                            | location                   | readyToLatestTime              | approxVolume                   | status  | receivedParcels |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} | GET_FROM_CREATED_ADDRESS_1 | GET_FROM_CREATED_RESERVATION_1 | GET_FROM_CREATED_RESERVATION_1 | Success | 1               |
    Then Operator verify Orders table in Reservations dialog using data below:
      | trackingId                                 | stampId | location                                               | type                  | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | {KEY_CREATED_ADDRESS.to1LineAddressWithSpaceDelimiter} | Pick Up (Reservation) | Success | 0        | Inbounded          |
    And Operator close Reservations dialog on Route Inbound page
