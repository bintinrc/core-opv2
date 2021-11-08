@OperatorV2 @Core @NewFeatures @OutboundMonitoring
Feature: Outbound Monitoring

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Search Outbound Data on Outbound Monitoring Page (uid:e70dd3bc-b9ad-4447-b717-5afb2b52ed30)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    And Operator search on Route ID Header Table on Outbound Monitoring Page
    Then Operator verify the route ID is exist on Outbound Monitoring Page

  @DeleteOrArchiveRoute
  Scenario: Operator Verifies the In Progress Outbound Status on Outbound Monitoring Page (uid:4414c191-4865-4d4f-8722-8678795d3636)
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
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    And Operator search on Route ID Header Table on Outbound Monitoring Page
    Then Operator verify the In Progress Outbound Status on Outbound Monitoring Page

  @DeleteOrArchiveRoute
  Scenario: Operator Verifies the Complete Outbound Status on Outbound Monitoring Page (uid:e00fae9b-9e58-40da-bb16-e66ca91960e7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator Outbound Scan parcel using data below:
      | outboundRequest | { "hubId":{hub-id} } |
    Given API Operator start the route
    Given API Driver deliver the created parcel successfully
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page
    Then Operator verify the Complete Outbound Status on Outbound Monitoring Page

  @DeleteOrArchiveRoute
  Scenario: Operator Clicks on Flag Icon to Mark Route ID on Outbound Monitoring Page (uid:9a062aaa-cc20-4937-a4d4-e996200bd283)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page
    When Operator click on flag icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies the Outbound status on the chosen route ID is changed

  @DeleteOrArchiveRoute
  Scenario: Operator Adding Comment on the Outbound Monitoring Page (uid:5fab15ab-78eb-4349-8656-e96e0942f560)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page
    When Operator click on comment icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies the comment table on the chosen route ID is changed

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Delivery Order from a Route on Outbound Breakroute V1 Page (uid:ff2d5814-a7fa-4386-aa98-5fe41c2a2032)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    And Operator pull out order "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" from route on Outbound Breakroute page
    Then Operator verifies that success toast displayed:
      | top                | Success pullout tracking id {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | waitUntilInvisible | true                                                                   |
    Then API Operator verify order is pulled out from route
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Delivery Order from a Route on Outbound Breakroute V1 Page - Route is Soft Deleted (uid:f474c12f-e041-46ce-8e39-9008f501a8b7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    And DB Operator soft delete route "KEY_CREATED_ROUTE_ID"
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    And Operator pull out order "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" from route on Outbound Breakroute page
    Then Operator verifies that success toast displayed:
      | top                | Success pullout tracking id {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | waitUntilInvisible | true                                                                   |
    Then API Operator verify order is pulled out from route
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Filters Single Route on Outbound Monitoring Page by Edit Route button (uid:e474a4e6-f12b-40c9-8f90-c4dc83aa6ebf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    Then Operator verify the route ID is exist on Outbound Monitoring Page
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    Then Operator verify that there is "{KEY_CREATED_ROUTE_ID}" route selected shown on 'Outbound Route Pullout' field
    And Operator verify that Orders in Route table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Unable to Pull Out Non-Pending State Delivery Order on Outbound Breakroute V1 Page (uid:2f626e5a-a44f-451c-9804-c4cbae206bfe)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver successfully deliver created parcels with numbers: 1
    And API Driver failed the delivery of parcels with numbers: 2
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    Then Operator verify the route ID is exist on Outbound Monitoring Page
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    And Operator pull out order "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" from route on Outbound Breakroute page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                                                                                           |
      | bottom | ^.*Error Message: Get ProcessingException \[Code:ORDER_COMPLETED_EXCEPTION\]\[Message:Transaction for \[OrderID:{KEY_LIST_OF_CREATED_ORDER_ID[2]}\] is not in pending state\].* |
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Able to Show Pending State and Non-Pending State Delivery Order on Outbound Breakroute V1 Page (uid:924e237a-dcc5-4cb0-b637-df018eb78b74)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver successfully deliver created parcels with numbers: 1
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    Then Operator verify the route ID is exist on Outbound Monitoring Page
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Unable to Show Pending State and Non-Pending State Pickup Order on Outbound Breakroute V1 Page (uid:a0141844-ce3a-4483-9b5d-bce1825d3ff3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver pickup the created parcel successfully
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    Then Operator verify the route ID is exist on Outbound Monitoring Page
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    Then Operator verify that Orders in Route table is empty
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table is empty

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Filters Single Route on Outbound Monitoring Page by Pull Out button (uid:8230270a-a20f-46a0-8e3b-e78567b4714a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_CREATED_ROUTE_ID} |
    Then Operator verifies 1 total selected Route IDs shown on Outbound Breakroute V2 page
    And Operator verifies "{gradle-current-date-yyyy-MM-dd}" date shown on Outbound Breakroute V2 page
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Searches Order of Multiple Routes on Outbound Breakroute V2 Page (uid:578f36ea-973d-4368-a7b0-784c6e6d5290)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 4                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} | { "type":"DD" }         |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | { "type":"DD" }         |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verifies 2 total selected Route IDs shown on Outbound Breakroute V2 page
    And Operator verifies "{gradle-current-date-yyyy-MM-dd}" date shown on Outbound Breakroute V2 page
    When Operator filter orders table on Outbound Breakroute V2 page:
      | tracking_id | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | granular_status | Arrived at Sorting Hub |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | last_scanned_hub | {hub-name} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | route_id | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | route_date | {gradle-current-date-yyyy-MM-dd} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | driver_id | {ninja-driver-id} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | driver_name | {ninja-driver-name} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | driver_type | {default-driver-type-name} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | address | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | last_scanned_type | inbound_scan |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | order_delivery_type | STANDARD |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Able to Show Pending State and Non-Pending State Delivery Order on Outbound Breakroute V2 Page (uid:e31af1b1-8b58-40c9-96e8-f6aeb325034d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Completed              | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Unable to Show Pending State and Non-Pending State Pickup Order on Outbound Breakroute V2 Page (uid:c30b12ca-8fb5-4ceb-a285-7ebf9e4c749f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver pickup the created parcel successfully
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verifies 2 total selected Route IDs shown on Outbound Breakroute V2 page
    And Operator verifies orders table is empty on Outbound Breakroute V2 page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Delivery Order from a Route on Outbound Breakroute V2 Page (uid:a740644e-aa57-4506-9814-f548898fcb3b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Tracking IDs Pulled Out   |
      | bottom             | 1 Tracking IDs pulled out |
      | waitUntilInvisible | true                      |
    And Operator verifies orders table is empty on Outbound Breakroute V2 page
    When API Operator get order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Delivery Order from a Route on Outbound Breakroute V2 Page - Route is Soft Deleted (uid:48deac7d-dde2-4e28-a637-3a08b1ae1a47)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    And DB Operator soft delete route "KEY_CREATED_ROUTE_ID"
    And Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Tracking IDs Pulled Out   |
      | bottom             | 1 Tracking IDs pulled out |
      | waitUntilInvisible | true                      |
    And Operator verifies orders table is empty on Outbound Breakroute V2 page
    When API Operator get order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Shows Multiple Same Tracking IDs of Different Routes on Outbound Breakrout V2 Page (uid:ac596684-bb26-4d14-8194-6c9d99964298)
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
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Operator reschedule failed delivery order
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    And Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus          | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | On Vehicle for Delivery | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | On Vehicle for Delivery | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Shows a Route that has Multiple Tracking IDs on Outbound Breakroute V2 Page (uid:5f2414ae-d154-41d7-ab1c-ceb5358ec7fc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_CREATED_ROUTE_ID} |
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus          | lastScannedHub | routeId                | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | On Vehicle for Delivery | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | On Vehicle for Delivery | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Multiple Delivery Orders from Multiple Routes on Outbound Breakroute V2 Page (uid:6ab00e81-acd3-4364-942e-30591d6c17a6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Tracking IDs Pulled Out   |
      | bottom             | 2 Tracking IDs pulled out |
      | waitUntilInvisible | true                      |
    And Operator verifies orders table is empty on Outbound Breakroute V2 page
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And DB Operator verifies route_monitoring_data is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And DB Operator verifies route_monitoring_data is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Unable to Pull Out Non-Pending State Delivery Order on Outbound Breakroute V2 Page (uid:b10c24d7-805f-4f79-911b-dfa69790d426)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver successfully deliver created parcels with numbers: 1
    And API Driver failed the delivery of parcels with numbers: 2
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies errors in Processing modal on Outbound Breakroute V2 page:
      | Get ProcessingException [Code:ORDER_COMPLETED_EXCEPTION][Message:Transaction for [OrderID:{KEY_LIST_OF_CREATED_ORDER_ID[1]}] is not in pending state] |
      | Get ProcessingException [Code:ORDER_COMPLETED_EXCEPTION][Message:Transaction for [OrderID:{KEY_LIST_OF_CREATED_ORDER_ID[2]}] is not in pending state] |
    When Operator clicks Cancel in Processing modal on Outbound Breakroute V2 page
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus     | lastScannedHub | routeId                | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Completed          | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Pending Reschedule | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Partial Success To Pull Out Multiple Orders from Multiple Routes on Outbound Breakroute V2 Page -  Pending State & Non-Pending State Delivery (uid:bd01f24e-18ad-45e4-8f33-46ab5acb7324)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies errors in Processing modal on Outbound Breakroute V2 page:
      | Get ProcessingException [Code:ORDER_COMPLETED_EXCEPTION][Message:Transaction for [OrderID:{KEY_LIST_OF_CREATED_ORDER_ID[2]}] is not in pending state] |
    When Operator clicks Cancel in Processing modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Tracking IDs Pulled Out   |
      | bottom             | 1 Tracking IDs pulled out |
      | waitUntilInvisible | true                      |
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus | lastScannedHub | routeId                | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Completed      | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And DB Operator verifies route_monitoring_data is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Partial Success To Pull Out Multiple Orders from Multiple Routes on Outbound Breakroute V2 Page - Delivery Order is Pulled Out (uid:b8856d12-3c45-42fc-a7db-0b95085d4099)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When API Operator pulled out parcel "DELIVERY" from route
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies errors in Processing modal on Outbound Breakroute V2 page:
      | Get ProcessingException [Code:BAD_REQUEST_EXCEPTION][Message:No route found to unroute for [OrderID:{KEY_LIST_OF_CREATED_ORDER_ID[2]}]] |
    When Operator clicks Cancel in Processing modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Tracking IDs Pulled Out   |
      | bottom             | 1 Tracking IDs pulled out |
      | waitUntilInvisible | true                      |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And DB Operator verifies route_monitoring_data is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
