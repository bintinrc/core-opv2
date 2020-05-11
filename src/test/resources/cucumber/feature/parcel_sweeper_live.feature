@OperatorV2 @OperatorV2Part2 @ParcelSweeperLive
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Parcel Sweeper Live - Order Not Found - Invalid Tracking ID (uid:5699c5ca-a546-42c4-b29d-0b25ad512360)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Parcel Sweeper Live
  When Operator provides data on Parcel Sweeper Live page:
    | hubName    | {hub-name} |
    | trackingId | invalid    |
  Then Operator verifies data on Parcel Sweeper Live page using data below:
    | routeId              | NOT FOUND;NIL |
    | routeId_color        | #f45050       |
    | zoneName             | NIL           |
    | zoneName_color       | #f45050       |
    | destinationHub       | NOT FOUND     |
    | destinationHub_color | #f45050       |

  Scenario: Parcel Sweeper Live - Order Not Found - Pending Pickup (uid:d59c536f-3671-46b8-883c-6785a524a38a)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Parcel Sweeper Live
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verifies data on Parcel Sweeper Live page using data below:
      | routeId              | NOT FOUND;NIL |
      | routeId_color        | #f45050       |
      | zoneName             | NIL           |
      | zoneName_color       | #f45050       |
      | destinationHub       | NOT FOUND     |
      | destinationHub_color | #f45050       |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED    |
      | hubId      | {hub-id}   |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Van En-Route to Pickup (uid:be9ed0d6-276b-4368-bf9a-47dc0a8bec27)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    Then API Operator verify order info after Return PP transaction added to route
    When Operator go to menu Routing -> Parcel Sweeper Live
    And Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verifies data on Parcel Sweeper Live page using data below:
      | routeId              | NOT ROUTED;NIL |
      | routeId_color        | #73deec        |
#      | zoneName             | FROM CREATED ORDER    |
      | zoneName_color       | #f45050        |
      | destinationHub       | CREATED        |
      | destinationHub_color | #73deec        |
    #in TC it should be grey for destinationHub_color
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van en-route to pickup" on Edit Order page

  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt unrouted (uid:db35114c-2d0b-4a7e-9243-a60a1722cdd0)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT ROUTED |
      | driverName | NIL        |
      | color      | #73deec    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub = physical hub, route's date = today (uid:fde3c3b5-a9ae-410f-8621-efd9037aaf33)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | {ninja-driver-name}    |
      | color      | #73deec                |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 31    |
      | 27    |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verifies event is present for order on Edit order page
      | eventName | OUTBOUND SCAN	    |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub different from physical hub, route's date = today (uid:343e6c75-97d8-4381-a684-0b12afb3a30b)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name-2} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | {ninja-driver-name}    |
      | color      | #73deec                |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id-2} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 27    |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name-2}          |
      | hubId     | {hub-id-2}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub = physical hub, route's date is NOT today (uid:7a3348b5-7f3d-4d1c-aa4d-6a1b93b5021a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-1-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-1-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | -                      |
      | color      | #f45050                |
    When API Operator get all zones preferences
    And Operator verify Parcel route different date label on Parcel Sweeper By Hub page
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #f45050            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 27    |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub different from physical hub, route's date is NOT today (uid:824507a8-a2a5-4543-be47-4d702afe3aea)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-1-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-1-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name-2} |
      | trackingId | CREATED      |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | -                      |
      | color      | #f45050                |
    When API Operator get all zones preferences
    And Operator verify Parcel route different date label on Parcel Sweeper By Hub page
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #f45050            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id-2} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 27    |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN   |
      | hubName   | {hub-name-2}          |
      | hubId     | {hub-id-2}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario Outline: Parcel Sweeper Live - With Priority Level - <scenarioName> (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator refresh created order data
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    When Operator change Priority Level to "<priorityLevel>" on Edit Order page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | {ninja-driver-name}    |
      | color      | #73deec                |
    Then Operator verifies priority level dialog box shows correct priority level info using data below:
      | priorityLevel           | <priorityLevel>             |
      | priorityLevelColorAsHex | <priorityLevelColorAsHex>   |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 31    |
      | 27    |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verifies event is present for order on Edit order page
      | eventName | OUTBOUND SCAN	    |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Examples:
      | scenarioName           | hiptest-uid                              | priorityLevel | priorityLevelColorAsHex |
      | No Priority (0)        | uid:9ab1cd71-5936-4033-b8eb-3d5f40e1c5e2 | 0             | #e8e8e8                 |
      | No Priority (1)        | uid:c9f356cb-4558-463e-9d28-d3cc8570f69c | 1             | #ffff00                 |
      | Late Priority (2 - 90) | uid:e166f436-b6c0-4cb2-b1f4-340220898063 | 50            | #ffa500                 |
      | Urgent Priority (91++) | uid:8acf6dff-fca2-42ff-bc60-2b63b04f3d32 | 100           | #ff0000                 |

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - RTS Order (uid:6603db76-fc8c-45ec-a4ab-52a47a9c13c8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify RTS label on Parcel Sweeper Live page
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
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - On Hold Order - NON-MISSING TICKET (uid:b0baaa1e-e23d-43e3-8e0b-64f9e881b6f8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
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
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | orderId    | ON HOLD    |
      | driverName | RECOVERY   |
      | color      | #f45050    |
    And API Operator get all zones preferences
    And Operator verify Zone on Parcel Sweeper By Hub page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #f45050            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -               |
      | color   | #f45050         |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - On Hold Order - MISSING TICKET (uid:195348a0-3620-4ad9-aa6c-103783aef17e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | orderId    | Not Routed |
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
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order event on Edit order page using data below:
      | name    | TICKET RESOLVED       |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And DB Operator verify ticket status
      | status | 3 |

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Pickup Fail (uid:41b05d2e-ea25-48fc-81bd-b326321aca69)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verifies data on Parcel Sweeper Live page using data below:
      | routeId              | NOT FOUND;NIL |
      | routeId_color        | #f45050       |
      | zoneName             | NIL           |
      | zoneName_color       | #f45050       |
      | destinationHub       | NOT FOUND     |
      | destinationHub_color | #f45050       |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED    |
      | hubId      | {hub-id}   |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Pickup fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - En-route to Sorting Hub (uid:5b520d7a-51d3-427a-89b7-43ec63e707f8)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver failed the delivery of the created parcel
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verifies data on Parcel Sweeper Live page using data below:
      | routeId              | ALERT;PARCEL STATUS ERROR'   |
      | routeId_color        | #f45050                      |
      | zoneName             | NIL                          |
      | zoneName_color       | #f45050                      |
      | destinationHub       | NIL                          |
      | destinationHub_color | #f45050                      |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED    |
      | hubId      | {hub-id}   |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page

  Scenario: Parcel Sweeper Live - Arrived at Sorting Hub (uid:bcdec68a-2619-48e3-8043-43f7bfe266b7)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT ROUTED |
      | driverName | NIL        |
      | color      | #73deec    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  Scenario: Parcel Sweeper Live - Cancelled (uid:29a43c56-13dc-4498-b557-66e943825a4b)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator cancel created order
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT FOUND  |
      | driverName | NIL        |
      | color      | #f45050    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL         |
      | color    | #f45050     |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | NOT FOUND   |
      | color   | #f45050     |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page

  Scenario: Parcel Sweeper Live - Completed (uid:a0ec03e7-4074-4ae0-85c7-ca908e74e9ac)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator force succeed created order
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT FOUND  |
      | driverName | NIL        |
      | color      | #f45050    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL         |
      | color    | #f45050     |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | NOT FOUND |
      | color   | #f45050   |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  Scenario: Parcel Sweeper Live - Returned to Sender (uid:99b866b3-d280-46e7-98e7-1387377773de)
    Given Operator go to menu Order -> All Orders
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When API Operator force succeed created order
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT FOUND  |
      | driverName | NIL        |
      | color      | #f45050    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL         |
      | color    | #f45050     |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | NOT FOUND |
      | color   | #f45050   |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to sender" on Edit Order page

  Scenario: Parcel Sweeper Live - Transferred to 3PL (uid:0eae2694-7221-42b1-97c5-bd04bfac1859)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT FOUND  |
      | driverName | NIL        |
      | color      | #f45050    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL         |
      | color    | #f45050     |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | NOT FOUND |
      | color   | #f45050   |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Transferred to 3PL" on Edit Order page

  Scenario: Parcel Sweeper Live - Arrived at Origin Hub (uid:d990f8e0-9a2e-4208-b8fd-bee83480a2ea)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{origin-hub-id} } |
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT ROUTED |
      | driverName | NIL        |
      | color      | #73deec    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | GLOBAL INBOUND |
      | color   | #73deec        |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Origin Hub" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Pending Reschedule (uid:a00edc09-d2fc-45a5-9424-9be72bbf92f9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    When Operator fail delivery waypoint from Route Manifest page
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT ROUTED |
      | driverName | NIL        |
      | color      | #73deec    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | GLOBAL INBOUND |
      | color   | #73deec        |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page

  Scenario: Parcel Sweeper Live - Show Order Tag (uid:8b0cb0c0-3146-48e7-b3db-96302c1d54f8)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-name} |
      | status          | Pending           |
      | granular status | Pending Pickup    |
    And Operator searches and selects orders created on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1   |
      | OPV2AUTO2   |
      | OPV2AUTO3   |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT ROUTED |
      | driverName | NIL        |
      | color      | #73deec    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | GLOBAL INBOUND |
      | color   | #73deec        |
    And Operator verifies tags on Parcel Sweeper Live page
      | OPV2AUTO1   |
      | OPV2AUTO2   |
      | OPV2AUTO3   |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - On Vehicle for Delivery
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver collect all his routes
    When API Driver get pickup/delivery waypoint of the created order
    When API Operator Van Inbound parcel
    When API Operator start the route
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | ALERT                 |
      | driverName | PARCEL STATUS ERROR   |
      | color      | #f45050               |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL      |
      | color    | #f45050  |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | NIL       |
      | color   | #f45050   |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page

  Scenario: Parcel Sweeper Live - Staging
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT FOUND |
      | driverName | NIL       |
      | color      | #f45050   |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL      |
      | color    | #f45050  |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | NOT FOUND |
      | color   | #f45050   |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Staging" on Edit Order page
    And Operator verify order granular status is "Staging" on Edit Order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Parcel Sweeper Live - Arrived at Distribution Point
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with DPMS ID = "{dpms-id}"
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
    And API Driver deliver the created parcel successfully
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT FOUND |
      | driverName | NIL       |
      | color      | #f45050   |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL      |
      | color    | #f45050  |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | NOT FOUND |
      | color   | #f45050   |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Distribution Point" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: OPV2 Parcel Sweeper Live - Pending Pickup At Distribution Point
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}}|
    Given API DP creates a return fully integrated order in a dp "{dp-id}" and Shipper Legacy ID = "{shipper-v4-legacy-id}"
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | ALERT                 |
      | driverName | PARCEL STATUS ERROR   |
      | color      | #f45050               |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL      |
      | color    | #f45050  |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | NIL       |
      | color   | #f45050   |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup at Distribution Point" on Edit Order page

  @DisableSetAside @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Set Aside Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get information about delivery routing hub of created order
    And API Operator enable Set Aside using data below:
      | setAsideGroup           | {set-aside-group-id} |
      | setAsideMaxDeliveryDays | 3                    |
      | setAsideHubs            | {KEY_ORDER_HUB_ID}   |
    When Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
    When API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | SET ASIDE              |
      | driverName | {set-aside-group-name} |
      | color      | #f45050                |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #f45050            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | {KEY_CREATED_ORDER.destinationHub} |
      | color   | #73deec                            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 27    |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op