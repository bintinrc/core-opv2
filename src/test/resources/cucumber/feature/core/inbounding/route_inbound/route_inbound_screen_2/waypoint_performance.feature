@OperatorV2 @Core @Inbounding @RouteInbound @WaypointPerformance @current
Feature: Waypoint Performance

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2
  Scenario: View Waypoint Performance of Pending Waypoints on Route Inbound Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                              |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify the Route Summary Details is correct using data below:
<<<<<<< HEAD
      | routeId     | GET_FROM_CREATED_ROUTE                    |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 4                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 0                                         |
      | wpCompleted | 0                                         |
      | wpTotal     | 4                                         |
=======
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 3                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 0                                         |
      | wpCompleted | 0                                         |
      | wpTotal     | 3                                         |
>>>>>>> feature/NVQA-8221
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}" on Route Inbound page
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open Pending Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Pending Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Pending Waypoints dialog
    Then Operator verify Reservations table in Pending Waypoints dialog using data below:
      | reservationId                            | location                                                            | readyToLatestTime                                                                                          | approxVolume                                       | status  | receivedParcels |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithSpaceDelimiter} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].readyDatetime} - {KEY_LIST_OF_CREATED_RESERVATIONS[1].latestDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | Pending | 0               |
    Then Operator verify Orders table in Pending Waypoints dialog using data below:
      | trackingId                            | stampId | location                                           | type              | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | {KEY_LIST_OF_CREATED_ORDERS[1].to1LineToAddress}   | Delivery (Normal) | Pending | 0        |                    |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |         | {KEY_LIST_OF_CREATED_ORDERS[2].to1LineFromAddress} | Pick Up (Return)  | Pending | 0        | Inbounded          |

  @ArchiveRouteCommonV2
  Scenario: View Waypoint Performance of Success Waypoints on Route Inbound Page (uid:a00f892a-08e9-4a73-b458-2b8a32172261)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new COD for created order
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver deliver all created parcels successfully
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE                    |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 0                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 0                                         |
      | wpCompleted | 3                                         |
      | wpTotal     | 3                                         |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open Completed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Pending Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 3     |
    When Operator click 'View orders or reservations' button for shipper #1 in Success Waypoints dialog
    Then Operator verify Orders table in Success Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Return) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |         | GET_FROM_CREATED_ORDER_3 | Delivery (Normal) | Success | 0        | Inbounded          |

  @ArchiveRouteCommonV2
  Scenario: View Waypoint Performance of Failed Waypoints on Route Inbound Page (uid:744d1e16-b4a7-4036-bf21-c7a7ab94afb7)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new COD for created order
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver failed the delivery of multiple parcels
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE                    |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 0                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 3                                         |
      | wpCompleted | 0                                         |
      | wpTotal     | 3                                         |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open Failed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 3     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Waypoints dialog
    Then Operator verify Orders table in Failed Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Failed | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Return) | Failed | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |         | GET_FROM_CREATED_ORDER_3 | Delivery (Normal) | Failed | 0        | Inbounded          |

  @ArchiveRouteCommonV2
  Scenario: View Waypoint Performance of Total Waypoints on Route Inbound Page (uid:40fd6a8f-ba66-4b5e-a036-fcd8b6af95ea)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Add  order to success
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
#    Add  reservation to success
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
#    Add waypoints to fail
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
#     Add pending reservation
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
#     Add pending order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[2]}        |
    And API Driver successfully deliver created parcels with numbers: 1
    And API Driver failed the delivery of parcels with numbers: 3
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE                    |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 3                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 1                                         |
      | wpCompleted | 2                                         |
      | wpTotal     | 6                                         |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open Total Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Total Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 5     |
    When Operator click 'View orders or reservations' button for shipper #1 in Total Waypoints dialog
    Then Operator verify Reservations table in Total Waypoints dialog using data below:
      | reservationId                            | location                                                        | readyToLatestTime              | approxVolume                                       | status  | receivedParcels |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {KEY_LIST_OF_CREATED_ADDRESSES[1].getFullSpaceSeparatedAddress} | GET_FROM_CREATED_RESERVATION_1 | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | Success | 1               |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} | {KEY_LIST_OF_CREATED_ADDRESSES[2].getFullSpaceSeparatedAddress} | GET_FROM_CREATED_RESERVATION_2 | {KEY_LIST_OF_CREATED_RESERVATIONS[2].approxVolume} | Pending | 0               |
    Then Operator verify Orders table in Total Waypoints dialog using data below:
      | trackingId                                 | stampId | location                                                        | type                  | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | null    | {KEY_LIST_OF_CREATED_ORDER[1].getFullSpaceSeparatedToAddress}   | Delivery (Normal)     | Success | 0        | null               |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | null    | {KEY_LIST_OF_CREATED_ADDRESSES[1].getFullSpaceSeparatedAddress} | Pick Up (Reservation) | Success | 0        | null               |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | null    | {KEY_LIST_OF_CREATED_ORDER[2].getFullSpaceSeparatedToAddress}   | Delivery (Normal)     | Pending | 0        | null               |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | null    | {KEY_LIST_OF_CREATED_ORDER[3].getFullSpaceSeparatedToAddress}   | Delivery (Normal)     | Failed  | 0        | null               |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | null    | {KEY_LIST_OF_CREATED_ORDER[4].getFullSpaceSeparatedToAddress}   | Delivery (Return)     | Pending | 0        | Inbounded          |

  @ArchiveRouteCommonV2
  Scenario: View Waypoint Performance of Partial Waypoints on Route Inbound Page (uid:285f51f0-3c99-4be9-bea9-11d47f73e313)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator get route details of created route
#  to update get from index = 0 once dummy waypoint is removed
    And API Operator get order details from route details
    And API Driver deliver partial created parcels successfully
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID}                    |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 0                                         |
      | wpPartial   | 1                                         |
      | wpFailed    | 0                                         |
      | wpCompleted | 0                                         |
      | wpTotal     | 1                                         |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    And Operator click 'Go Back' button on Route Inbound page
    And Operator open Partial Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Partial Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Partial Waypoints dialog
    Then Operator verify Orders table in Partial Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Normal) | Failed  | 0        | Inbounded          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Success | 0        |                    |
