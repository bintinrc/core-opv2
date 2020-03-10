@OperatorV2Deprecated @OperatorV2Part2Deprecated @ParcelSweeperByHub
Feature: Parcel Sweeper By Hub

  # THIS FEATURE HAS BEEN DEPRECATED

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Parcel Routing Sweep by Hub - RTS Order
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper by Hub
    And Operator sweep parcel on Parcel Sweeper By Hub page using data below:
      | hubName            | {hub-name}                    |
      | destinationHubName | GLOBAL INBOUND                |
      | trackingId         | KEY_CREATED_ORDER_TRACKING_ID |
    Then Operator verify RTS label on Parcel Sweeper By Hub page
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | orderId    | NOT ROUTED |
      | driverName | NIL        |
      | color      | #73deec    |
    And API Operator get all zones preferences
    And Operator verify Zone on Parcel Sweeper By Hub page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | GLOBAL INBOUND |
      | color   | #73deec        |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    Then Operator verify order event on Edit order page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Parcel Routing Sweep by Hub - RTS Order
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper by Hub
    And Operator sweep parcel on Parcel Sweeper By Hub page using data below:
      | hubName            | {hub-name}                    |
      | destinationHubName | FROM CREATED ORDER            |
      | trackingId         | KEY_CREATED_ORDER_TRACKING_ID |
    Then Operator verify RTS label on Parcel Sweeper By Hub page
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | routeId    | GENERATED           |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    And API Operator get all zones preferences
    And Operator verify Zone on Parcel Sweeper By Hub page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | {hub-name} |
      | color   | #73deec    |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And DB Operator verify order_events record for the created order:
      | type | 31 |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    Then Operator verify order event on Edit order page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    And Operator verify order event on Edit order page using data below:
      | name    | OUTBOUND SCAN |
      | hubName | {hub-name}    |
      | hubId   | {hub-id}      |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Parcel Sweeper by Hub - destination hub = synced hub, routed, route's hub different from physical hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper by Hub
    And Operator sweep parcel on Parcel Sweeper By Hub page using data below:
      | hubName            | {hub-name}                    |
      | destinationHubName | FROM CREATED ORDER            |
      | trackingId         | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | routeId    | GENERATED           |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    And API Operator get all zones preferences
    And Operator verify Zone on Parcel Sweeper By Hub page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | {hub-name} |
      | color   | #73deec    |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And DB Operator verify order_events record for the created order:
      | type | 31 |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    Then Operator verify order event on Edit order page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    And Operator verify order event on Edit order page using data below:
      | name    | OUTBOUND SCAN |
      | hubName | {hub-name}    |
      | hubId   | {hub-id}      |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Parcel Sweeper by Hub - destination hub = synced hub, routed, route's hub = physical hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper by Hub
    And Operator sweep parcel on Parcel Sweeper By Hub page using data below:
      | hubName            | {hub-name}                    |
      | destinationHubName | FROM CREATED ORDER            |
      | trackingId         | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | routeId    | GENERATED           |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    And API Operator get all zones preferences
    And Operator verify Zone on Parcel Sweeper By Hub page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | {hub-name-2} |
      | color   | #73deec      |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    Then Operator verify order event on Edit order page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Parcel Sweeper by Hub -  destination hub = synced hub, routed, route's hub = physical hub, route's date = today
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper by Hub
    And Operator sweep parcel on Parcel Sweeper By Hub page using data below:
      | hubName            | {hub-name}                    |
      | destinationHubName | FROM CREATED ORDER            |
      | trackingId         | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | routeId    | GENERATED           |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    And API Operator get all zones preferences
    And Operator verify Zone on Parcel Sweeper By Hub page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | {hub-name} |
      | color   | #73deec    |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And DB Operator verify order_events record for the created order:
      | type | 31 |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    Then Operator verify order event on Edit order page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    And Operator verify order event on Edit order page using data below:
      | name    | OUTBOUND SCAN |
      | hubName | {hub-name}    |
      | hubId   | {hub-id}      |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Parcel Sweeper by Hub - destination hub = synced hub, routed, route's hub = physical hub, wrong route's date
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-1-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-1-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper by Hub
    And Operator sweep parcel on Parcel Sweeper By Hub page using data below:
      | hubName            | {hub-name}                    |
      | destinationHubName | FROM CREATED ORDER            |
      | trackingId         | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | routeId    | GENERATED |
      | driverName | -         |
      | color      | #f45050   |
    And API Operator get all zones preferences
    And Operator verify Zone on Parcel Sweeper By Hub page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #f45050            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | FROM CREATED ORDER |
      | color   | #73deec            |
    And Operator verify Parcel route different date label on Parcel Sweeper By Hub page
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    Then Operator verify order event on Edit order page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Parcel Routing Sweep by Hub - On Hold Order (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | DAMAGED            |
      | ticketSubType           | IMPROPER PACKAGING |
      | parcelLocation          | DAMAGED RACK       |
      | liability               | NV DRIVER          |
      | damageDescription       | GENERATED          |
      | orderOutcomeDamaged     | NV LIABLE - FULL   |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper by Hub
    And Operator sweep parcel on Parcel Sweeper By Hub page using data below:
      | hubName            | {hub-name}                    |
      | destinationHubName | FROM CREATED ORDER            |
      | trackingId         | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | routeId    | ON HOLD  |
      | driverName | RECOVERY |
      | color      | #f45050  |
    And API Operator get all zones preferences
    And Operator verify Zone on Parcel Sweeper By Hub page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #f45050            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -       |
      | color   | #f45050 |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    Then Operator verify order event on Edit order page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    And Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page

  Scenario: Parcel Routing Sweep by Hub - Order Not Found - Invalid Tracking ID (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Routing -> Parcel Sweeper by Hub
    And Operator sweep parcel on Parcel Sweeper By Hub page using data below:
      | hubName            | {hub-name}         |
      | destinationHubName | {hub-name-2}       |
      | trackingId         | NVSGSOCV40K1GXOQL0 |
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | routeId    | NOT FOUND |
      | driverName | NIL       |
      | color      | #f45050   |
    And API Operator get all zones preferences
    And Operator verify Zone on Parcel Sweeper By Hub page using data below:
      | zoneName | NIL     |
      | color    | #f45050 |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | NOT FOUND |
      | color   | #f45050   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op