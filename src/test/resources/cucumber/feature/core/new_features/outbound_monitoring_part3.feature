@OperatorV2 @Core @NewFeatures @OutboundMonitoring @OutboundMonitoringPart3 @NewFeatures1
Feature: Outbound Monitoring

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Partial Success To Pull Out Multiple Orders from Multiple Routes on Outbound Breakroute V2 Page - Delivery Order is Pulled Out
    Given Operator go to menu Utilities -> QRCode Printing
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
    And DB Operator verifies route_monitoring_data is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Views Orders Under Orders in Routes and Outbound Scans fields on Outbound Breakroute V1
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_DESTINATION_HUB_ID}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {KEY_DESTINATION_HUB_ID}                   |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name}                        |
      | hubName  | {KEY_CREATED_ORDER.destinationHub} |
    Then Operator verify the route ID is exist on Outbound Monitoring Page
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator verify that Outbound Scans table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator verify that Parcels not in Outbound Scans table is empty

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Views Orders Under Orders in Routes and Parcels not in Outbound Scans fields on Outbound Breakroute V1 - Order Scanned in Different Hub as Order and Route
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_DESTINATION_HUB_ID}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name}                        |
      | hubName  | {KEY_CREATED_ORDER.destinationHub} |
    Then Operator verify the route ID is exist on Outbound Monitoring Page
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator pull out order "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" from route on Outbound Breakroute page
    Then Operator verifies that success toast displayed:
      | top                | Success pullout tracking id {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | waitUntilInvisible | true                                                                   |
    Then API Operator verify order is pulled out from route

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Views Orders Under Orders in Routes and Parcels not in Outbound Scans fields on Outbound Breakroute V1 - Order is not Scanned
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_DESTINATION_HUB_ID}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name}                        |
      | hubName  | {KEY_CREATED_ORDER.destinationHub} |
    Then Operator verify the route ID is exist on Outbound Monitoring Page
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator verify that Outbound Scans table is empty
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator pull out order "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" from route on Outbound Breakroute page
    Then Operator verifies that success toast displayed:
      | top                | Success pullout tracking id {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | waitUntilInvisible | true                                                                   |
    Then API Operator verify order is pulled out from route

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Views Orders Under Orders in Routes, Outbound Scans, and Parcels not in Outbound Scans fields on Outbound Breakroute V1
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                          |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_DESTINATION_HUB_ID}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | hubId | {KEY_DESTINATION_HUB_ID}                   |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name}                        |
      | hubName  | {KEY_CREATED_ORDER.destinationHub} |
    Then Operator verify the route ID is exist on Outbound Monitoring Page
    When Operator clicks Edit button for "{KEY_CREATED_ROUTE_ID}" route on Outbound Monitoring Page
    And Operator verify that Orders in Route table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And Operator verify that Outbound Scans table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And Operator verify that Parcels not in Outbound Scans table contains records:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator pull out order "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" from route on Outbound Breakroute page
    Then Operator verifies that success toast displayed:
      | top                | Success pullout tracking id {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | waitUntilInvisible | true                                                                   |

  @DeleteOrArchiveRoute
  Scenario: Operator Clicks on Flag Icon to Un-Mark Route ID on Outbound Monitoring Page
    Given Operator go to menu Utilities -> QRCode Printing
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
    When Operator go to menu New Features -> Outbound Load Monitoring
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator search on Route ID Header Table on Outbound Monitoring Page
    When Operator click on flag icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies route record on Outbound Monitoring page:
      | id             | {KEY_CREATED_ROUTE_ID} |
      | outboundStatus | Marked                 |
    And Operator verifies route record has "yellow" background color
    When Operator click on flag icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies route record on Outbound Monitoring page:
      | id             | {KEY_CREATED_ROUTE_ID} |
      | outboundStatus | In Progress            |
    And Operator verifies route record has "red" background color
    And DB Operator verifies route_logs record:
      | id   | {KEY_CREATED_ROUTE_ID} |
      | isOk | 0                      |

