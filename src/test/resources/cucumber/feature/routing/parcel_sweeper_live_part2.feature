@OperatorV2 @Routing @OperatorV2Part2 @ParcelSweeperLive
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
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
      | routeId    | sync_problem RECOVERY   |
      | driverName | COMPLETED               |
      | color      | #d86965                 |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | -       |
      | color    | #d86965 |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -       |
      | color   | #d86965 |
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

  @CloseNewWindows
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
    Then Operator verify RTS label on Parcel Sweeper Live page
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | sync_problem RECOVERY   |
      | driverName | RETURNED TO SENDER      |
      | color      | #d86965                 |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | -       |
      | color    | #d86965 |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -       |
      | color   | #d86965 |
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

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - Transferred to 3PL (uid:0eae2694-7221-42b1-97c5-bd04bfac1859)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
      |3plShipperName  | {3pl-shipper-name}    |
      |3plShipperId    | {3pl-shipper-id}      |
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | sync_problem RECOVERY   |
      | driverName | TRANSFERRED TO 3PL      |
      | color      | #d86965                 |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | -       |
      | color    | #d86965 |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -       |
      | color   | #d86965 |
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

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - Pending Reschedule (uid:a00edc09-d2fc-45a5-9424-9be72bbf92f9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
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
      | orderId    | -          |
      | color      | #67a0e2    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #67a0e2            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | GLOBAL INBOUND |
      | color   | #e8e8e8        |
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

  @CloseNewWindows
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
      | orderId    | -        |
      | color      | #67a0e2  |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #67a0e2            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | GLOBAL INBOUND |
      | color   | #67a0e2        |
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

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - On Vehicle for Delivery (uid:5ae4645e-1195-4c53-b6f6-fdddb16c172d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
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
      | routeId    | sync_problem RECOVERY   |
      | driverName | ON VEHICLE FOR DELIVERY |
      | color      | #d86965                 |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | -       |
      | color    | #d86965 |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -       |
      | color   | #d86965 |
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

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - Staging (uid:9b2f4f58-dd53-4fa8-a036-d5595d5fe65c)
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
      | routeId    | error_outline ERROR     |
      | driverName | NOT INBOUNDED           |
      | color      | #f4a73c                 |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | -       |
      | color    | #f4a73c |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -       |
      | color   | #f4a73c |
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

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - Arrived at Distribution Point (uid:b5b9d7fc-67fb-473f-b030-c78a67a553c6)
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
    And API Operator pulled out parcel "DELIVERY" from route
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
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
      | routeId    | error_outline ERROR     |
      | driverName | NOT INBOUNDED           |
      | color      | #f4a73c                 |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | -       |
      | color    | #f4a73c |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -       |
      | color   | #f4a73c |
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

  @CloseNewWindows
  Scenario: OPV2 Parcel Sweeper Live - Pending Pickup At Distribution Point (uid:0662fb02-a097-486b-9832-d371808e9290)
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
      | routeId    | error_outline ERROR     |
      | driverName | NOT INBOUNDED           |
      | color      | #f4a73c                 |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | -       |
      | color    | #f4a73c |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -       |
      | color   | #f4a73c |
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

  @DisableSetAside @CloseNewWindows
  Scenario: Parcel Sweeper Live - Set Aside Order (uid:49d4dfa4-551a-4b5a-ac6b-0c4168507f44)
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
      | color      | #d86965                |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #d86965            |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | {KEY_CREATED_ORDER.destinationHub} |
      | color   | #d86965                            |
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