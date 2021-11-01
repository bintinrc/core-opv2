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

  @CloseNewWindows @DeleteOrArchiveRoute @Debug
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
