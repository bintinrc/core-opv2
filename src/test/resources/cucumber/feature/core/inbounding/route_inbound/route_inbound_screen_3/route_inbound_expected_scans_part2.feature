@OperatorV2 @Core @Inbounding @RouteInbound @RouteInboundExpectedScans @RouteInboundExpectedScansPart2
Feature: Route Inbound Expected Scans

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Return Pickup Success
    Given Operator go to menu Utilities -> QRCode Printing
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver pickup the created parcel successfully
    And API Operator verify order info using data below:
      | id             | {KEY_CREATED_ORDER_ID} |
      | status         | TRANSIT                |
      | granularStatus | ENROUTE_TO_SORTING_HUB |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
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
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    When Operator open Completed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Completed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Completed dialog
    Then Operator verify Orders table in Completed dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close Completed dialog on Route Inbound page
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans  | 1 |
      | parcelProcessedTotal  | 1 |
      | c2cReturnPickupsScans | 1 |
      | c2cReturnPickupsTotal | 1 |
    When Operator open C2C / Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C / Return Pickups Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close C2C / Return Pickups dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | -                                          |
      | reason     | Duplicate                                  |

  @DeleteOrArchiveRoute
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Reservation Pickup Success
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation by scanning created parcel
    And API Operator wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | TRANSIT                                    |
      | granularStatus | ENROUTE_TO_SORTING_HUB                     |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | TRANSIT                                    |
      | granularStatus | ARRIVED_AT_SORTING_HUB                     |
    Given Operator go to menu Inbounding -> Route Inbound
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
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    When Operator open Completed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Completed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Completed dialog
    Then Operator verify Orders table in Completed dialog using data below:
      | trackingId                                 | stampId | location                                                        | type                  | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | {KEY_LIST_OF_CREATED_ADDRESSES[1].getFullSpaceSeparatedAddress} | Pick Up (Reservation) | Success | 0        | Inbounded          |
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
      | trackingId    | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | shipperName   | {shipper-v4-name}                          |
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]}   |
    When Operator close Reservation Pickups dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                                 | stampId | location                                                        | type                  | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | {KEY_LIST_OF_CREATED_ADDRESSES[1].getFullSpaceSeparatedAddress} | Pick Up (Reservation) | Success | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | -                                          |
      | reason     | Duplicate                                  |

  @DeleteOrArchiveRoute
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Failed Delivery (Valid)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | DELIVERY_FAIL                              |
      | granularStatus | PENDING_RESCHEDULE                         |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
      | expectedStatus       | DELIVERY_FAIL        |
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
      | wpFailed    | 1                      |
      | wpCompleted | 0                      |
      | wpTotal     | 1                      |
    When Operator open Failed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed dialog
    Then Operator verify Orders table in Failed dialog using data below:
      | trackingId                                 | stampId | location               | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER | Delivery (Normal) | Failed | 0        | Inbounded          |
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
      | trackingId                                 | stampId | location               | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER | Delivery (Normal) | Failed | 0        | Inbounded          |
    When Operator close Failed Deliveries Valid dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                                 | stampId | location               | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER | Delivery (Normal) | Failed | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | Failed Delivery (Valid)                    |
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | -                                          |
      | reason     | Duplicate                                  |

  @DeleteOrArchiveRoute
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Failed Delivery (Invalid)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Operator wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | DELIVERY_FAIL                              |
      | granularStatus | PENDING_RESCHEDULE                         |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
      | expectedStatus       | DELIVERY_FAIL        |
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
      | wpFailed    | 1                      |
      | wpCompleted | 0                      |
      | wpTotal     | 1                      |
    When Operator open Failed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed dialog
    Then Operator verify Orders table in Failed dialog using data below:
      | trackingId                                 | stampId | location               | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER | Delivery (Normal) | Failed | 1        | Inbounded          |
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
      | trackingId                                 | stampId | location               | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER | Delivery (Normal) | Failed | 1        | Inbounded          |
    When Operator close Failed Deliveries Invalid dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                                 | stampId | location               | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER | Delivery (Normal) | Failed | 1        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | Failed Delivery (Invalid)                  |
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | -                                          |
      | reason     | Duplicate                                  |

  @DeleteOrArchiveRoute
  Scenario: Show Global Inbounded Parcel as Route Inbound Scanned - Multiple Global Inbounds on Attempted Pickup & Delivery
    Given Operator go to menu Utilities -> QRCode Printing
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver pickup the created parcel successfully
    And API Operator verify order info using data below:
      | id             | {KEY_CREATED_ORDER_ID} |
      | status         | TRANSIT                |
      | granularStatus | ENROUTE_TO_SORTING_HUB |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
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
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    When Operator open Completed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Completed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Completed dialog
    Then Operator verify Orders table in Completed dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close Completed dialog on Route Inbound page
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans  | 1 |
      | parcelProcessedTotal  | 1 |
      | c2cReturnPickupsScans | 1 |
      | c2cReturnPickupsTotal | 1 |
    When Operator open C2C / Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C / Return Pickups Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close C2C / Return Pickups dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Success | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | Return Pickup                              |
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | -                                          |
      | reason     | Duplicate                                  |
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | DELIVERY_FAIL                              |
      | granularStatus | PENDING_RESCHEDULE                         |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
      | expectedStatus       | DELIVERY_FAIL        |
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
      | wpFailed    | 1                      |
      | wpCompleted | 0                      |
      | wpTotal     | 1                      |
    When Operator open Failed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed dialog
    Then Operator verify Orders table in Failed dialog using data below:
      | trackingId                                 | stampId | location               | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER | Delivery (Return) | Failed | 0        | Inbounded          |
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
      | trackingId                                 | stampId | location               | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER | Delivery (Return) | Failed | 0        | Inbounded          |
    When Operator close Failed Deliveries Valid dialog on Route Inbound page
    When Operator open Parcel Processed dialog on Route Inbound page
    Then Operator verify Shippers Info in Parcel Processed dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Parcel Processed dialog
    Then Operator verify Orders table in Parcel Processed dialog using data below:
      | trackingId                                 | stampId | location               | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER | Delivery (Return) | Failed | 0        | Inbounded          |
    When Operator close Parcel Processed dialog on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | Failed Delivery (Valid)                    |
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | -                                          |
      | reason     | Duplicate                                  |
