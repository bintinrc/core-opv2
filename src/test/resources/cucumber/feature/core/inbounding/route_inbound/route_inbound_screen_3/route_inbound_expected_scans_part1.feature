@OperatorV2 @Core @Inbounding @RouteInbound @RouteInboundExpectedScans @RouteInboundExpectedScansPart1
Feature: Route Inbound Expected Scans

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @happy-path
  Scenario: Route Inbound Expected Scans : Pending Deliveries
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                | {KEY_CREATED_ROUTE_ID} |
      | driverName             | {ninja-driver-name}    |
      | hubName                | {hub-name}             |
      | routeDate              | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans   | 0                      |
      | parcelProcessedTotal   | 2                      |
      | pendingDeliveriesScans | 0                      |
      | pendingDeliveriesTotal | 2                      |
    When Operator open Pending Deliveries dialog on Route Inbound page
    Then Operator verify Shippers Info in Pending Deliveries Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Pending Deliveries Waypoints dialog
    Then Operator verify Orders table in Pending Deliveries Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Pending | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Normal) | Pending | 0        |                    |
    When Operator close Pending Deliveries dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans   | 1 |
      | parcelProcessedTotal   | 2 |
      | pendingDeliveriesScans | 1 |
      | pendingDeliveriesTotal | 2 |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |
    And DB Operator verifies inbound_scans record with type "2" and correct route_id

  @DeleteOrArchiveRoute
  Scenario: Route Inbound Expected Scans : Failed Deliveries (Invalid)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                      | {KEY_CREATED_ROUTE_ID} |
      | driverName                   | {ninja-driver-name}    |
      | hubName                      | {hub-name}             |
      | routeDate                    | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans         | 0                      |
      | parcelProcessedTotal         | 2                      |
      | failedDeliveriesInvalidScans | 0                      |
      | failedDeliveriesInvalidTotal | 1                      |
    When Operator open Failed Deliveries Invalid dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Deliveries Invalid Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Deliveries Invalid Waypoints dialog
    Then Operator verify Orders table in Failed Deliveries Invalid Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Normal) | Failed | 1        |                    |
    When Operator close Failed Deliveries Invalid dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans         | 1 |
      | parcelProcessedTotal         | 2 |
      | failedDeliveriesInvalidScans | 1 |
      | failedDeliveriesInvalidTotal | 1 |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |
    And DB Operator verifies inbound_scans record with type "2" and correct route_id

  @DeleteOrArchiveRoute @happy-path
  Scenario: Route Inbound Expected Scans : Failed Deliveries (Valid)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                    | {KEY_CREATED_ROUTE_ID} |
      | driverName                 | {ninja-driver-name}    |
      | hubName                    | {hub-name}             |
      | routeDate                  | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans       | 0                      |
      | parcelProcessedTotal       | 2                      |
      | failedDeliveriesValidScans | 0                      |
      | failedDeliveriesValidTotal | 2                      |
    When Operator open Failed Deliveries Valid dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Deliveries Valid Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Deliveries Valid Waypoints dialog
    Then Operator verify Orders table in Failed Deliveries Valid Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Failed | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Normal) | Failed | 0        |                    |
    When Operator close Failed Deliveries Valid dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans       | 1 |
      | parcelProcessedTotal       | 2 |
      | failedDeliveriesValidScans | 1 |
      | failedDeliveriesValidTotal | 2 |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |
    And DB Operator verifies inbound_scans record with type "2" and correct route_id

  @DeleteOrArchiveRoute @happy-path
  Scenario: Route Inbound Expected Scans : Return Pickups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                           |
      | routes     | KEY_DRIVER_ROUTES                                                                    |
      | jobType    | TRANSACTION                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                              |
      | jobMode    | PICK_UP                                                                              |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                           |
      | routes     | KEY_DRIVER_ROUTES                                                                    |
      | jobType    | TRANSACTION                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                              |
      | jobMode    | PICK_UP                                                                              |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId               | {KEY_CREATED_ROUTE_ID} |
      | driverName            | {ninja-driver-name}    |
      | hubName               | {hub-name}             |
      | routeDate             | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans  | 0                      |
      | parcelProcessedTotal  | 2                      |
      | c2cReturnPickupsScans | 0                      |
      | c2cReturnPickupsTotal | 2                      |
    When Operator open C2C / Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C / Return Pickups Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | CREATED_ORDER_FROM_2 | Pick Up (Return) | Success | 0        |                    |
    When Operator close C2C / Return Pickups dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans  | 1 |
      | parcelProcessedTotal  | 2 |
      | c2cReturnPickupsScans | 1 |
      | c2cReturnPickupsTotal | 2 |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |
    And DB Operator verifies inbound_scans record with type "2" and correct route_id

  @DeleteOrArchiveRoute @happy-path
  Scenario: Route Inbound Expected Scans : Pending Return Pickups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                      | {KEY_CREATED_ROUTE_ID} |
      | driverName                   | {ninja-driver-name}    |
      | hubName                      | {hub-name}             |
      | routeDate                    | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans         | 0                      |
      | parcelProcessedTotal         | 1                      |
      | pendingC2cReturnPickupsScans | 0                      |
      | pendingC2cReturnPickupsTotal | 1                      |
    When Operator open Pending C2C / Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in Pending C2C / Return Pickups Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Pending C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in Pending C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Pending | 0        |                    |
    When Operator close Pending C2C / Return Pickups dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans         | 1 |
      | parcelProcessedTotal         | 1 |
      | pendingC2cReturnPickupsScans | 1 |
      | pendingC2cReturnPickupsTotal | 1 |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |
    And DB Operator verifies inbound_scans record with type "2" and correct route_id

  @DeleteOrArchiveRoute @happy-path
  Scenario: Route Inbound Expected Scans : Reservation Pickups
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new route using data below:
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
    And API Driver collect all his routes
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
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                 | {KEY_CREATED_ROUTE_ID} |
      | driverName              | {ninja-driver-name}    |
      | hubName                 | {hub-name}             |
      | routeDate               | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans    | 0                      |
      | parcelProcessedTotal    | 1                      |
      | reservationPickupsScans | 0                      |
      | reservationPickupsTotal | 1                      |
    When Operator open Reservation Pickups dialog on Route Inbound page
    And Operator close Reservation Pickups dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans    | 1 |
      | parcelProcessedTotal    | 1 |
      | reservationPickupsScans | 1 |
      | reservationPickupsTotal | 1 |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |
    And DB Operator verifies inbound_scans record with type "2" and correct route_id

  @DeleteOrArchiveRoute
  Scenario: Route Inbound Expected Scans : Reservation Extra Orders
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
    And API Driver success Reservation by NOT scanning order using data below:
      | reservationId  | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId        | {KEY_CREATED_ROUTE_ID}                   |
      | pickupQuantity | 1                                        |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                 | {KEY_CREATED_ROUTE_ID} |
      | driverName              | {ninja-driver-name}    |
      | hubName                 | {hub-name}             |
      | routeDate               | GET_FROM_CREATED_ROUTE |
      | reservationPickupsScans | 0                      |
      | reservationPickupsTotal | 1                      |
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | Reservation Pickup                         |
      | reason     | ^.*Extra Order                             |
    Then Operator verify the Route Inbound Details is correct using data below:
      | reservationPickupsScans       | 0 |
      | reservationPickupsTotal       | 1 |
      | reservationPickupsExtraOrders | 1 |
    When Operator open Reservation Pickups dialog on Route Inbound page
    Then Operator verify Extra Orders record using data below:
      | trackingId  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | shipperName | {shipper-v4-name}                          |
    When Operator close Reservation Pickups dialog on Route Inbound page
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |
    And DB Operator verifies inbound_scans record with type "2" and correct route_id

  @DeleteOrArchiveRoute
  Scenario: Show DP Return Pickups Under Return Pickups Modal & Reservation Modal Route Inbound Page
    Given Operator go to menu Utilities -> QRCode Printing
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API DP creates a return fully integrated order in a dp "{lodge-in-dp-id}" and Shipper Legacy ID = "{lodge-in-shipper-legacy-id}"
    And API Operator get reservation id of "{KEY_CREATED_ORDER_ID}" order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup at Distribution Point" on Edit Order page
    And Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | FROM SHIPPER TO DP |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    And API Operator get "{KEY_LIST_OF_CREATED_RESERVATION_IDS[1]}" reservation
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation by scanning created parcel
    And Operator refresh page
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PICKUP SUCCESS |
    #    TODO This event is absent
    #    And Operator verify order event on Edit order page using data below:
    #      | name | FROM DP TO DRIVER |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | {ninja-driver-name}    |
      | hubName    | {hub-name}             |
      | routeDate  | GET_FROM_CREATED_ROUTE |
    When Operator open C2C / Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C / Return Pickups Waypoints dialog using data below:
      | shipperName             | scanned | total |
      | {lodge-in-shipper-name} | 0       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                                 | stampId                                    | location | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |          | Pick Up (Return) | Success | 0        |                    |
    When Operator close C2C / Return Pickups dialog on Route Inbound page
    And Operator open Reservation Pickups dialog on Route Inbound page
    Then Operator verify Non-Inbounded Orders record using data below:
      | trackingId    | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | shipperName   | {lodge-in-shipper-name}                    |
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]}   |
    And Operator scan a tracking ID of created order on Route Inbound page

