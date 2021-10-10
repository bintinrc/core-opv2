@OperatorV2 @Driver @Inbounding @RouteInbound
Feature: Route Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: View Photo Evidence Unsuccessful Waypoint (uid:debb74de-d2b9-422f-b011-5cb9223990af)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels
    And DB Operator adds photo to delivery waypoint of created order
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
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
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verifies unsuccessful waypoints title is "Unsuccessful Waypoints (1)" in Photo Audit dialog
    And Operator verifies unsuccessful waypoints parameters in Photo Audit dialog:
      | address                                 | photoCount |
      | {KEY_CREATED_ORDER.buildToAddress1and2} | 1          |
    When Operator clicks on 1 unsuccessful waypoint address in Photo Audit dialog
    Then Operator verifies waypoint parameters in Waypoint Details dialog:
      | address    | {KEY_CREATED_ORDER.buildToAddress1and2} |
      | contact    | {KEY_CREATED_ORDER.toContact}           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}         |
    When Operator clicks on "{KEY_CREATED_ORDER_TRACKING_ID}" Tracking Id in Waypoint Details dialog
    Then Operator switch to Edit Order's window
    When Operator close new tabs
    And Operator close Waypoint Details dialog
    And Operator clicks on 1 unsuccessful waypoint photo in Photo Audit dialog
    Then Operator verifies waypoint photo parameters in Photo Details dialog:
      | address | {KEY_CREATED_ORDER.buildToAddress1and2} |
      | contact | {KEY_CREATED_ORDER.toContact}           |
    When Operator close Photo Details dialog
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator click 'Go Back' button on Route Inbound page

  @DeleteOrArchiveRoute
  Scenario: View Photo Evidence Partial Waypoint (uid:0b1e29ae-945e-46e9-8095-bced449a3935)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
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
    And API Operator merge route transactions
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator get route details of created route
    And API Operator get order details from route details
    And API Driver deliver partial created parcels successfully
    And API Operator refresh created order data
    And DB Operator adds photo to delivery waypoint of created order
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 1                      |
      | wpFailed    | 0                      |
      | wpCompleted | 0                      |
      | wpTotal     | 1                      |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verifies partial waypoints title is "Partial Waypoints (1)" in Photo Audit dialog
    And Operator verifies partial waypoints parameters in Photo Audit dialog:
      | address                                 | photoCount |
      | {KEY_CREATED_ORDER.buildToAddress1and2} | 1          |
    When Operator clicks on 1 partial waypoint address in Photo Audit dialog
    Then Operator verifies waypoint parameters in Waypoint Details dialog:
      | address    | {KEY_CREATED_ORDER.buildToAddress1and2}                                               |
      | contact    | {KEY_CREATED_ORDER.toContact}                                                         |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]},{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator clicks on "{KEY_CREATED_ORDER_TRACKING_ID}" Tracking Id in Waypoint Details dialog
    Then Operator switch to Edit Order's window
    When Operator close new tabs
    And Operator close Waypoint Details dialog
    And Operator clicks on 1 partial waypoint photo in Photo Audit dialog
    Then Operator verifies waypoint photo parameters in Photo Details dialog:
      | address | {KEY_CREATED_ORDER.buildToAddress1and2} |
      | contact | {KEY_CREATED_ORDER.toContact}           |
    When Operator close Photo Details dialog
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator click 'Go Back' button on Route Inbound page

  @DeleteOrArchiveRoute
  Scenario: View Photo Evidence Successful Waypoint (uid:257035f8-29f1-40af-97ec-b8de2580fc7d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And DB Operator adds photo to delivery waypoint of created order
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
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
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verifies successful waypoints title is "Successful Waypoints (1)" in Photo Audit dialog
    And Operator verifies successful waypoints parameters in Photo Audit dialog:
      | address                                 | photoCount |
      | {KEY_CREATED_ORDER.buildToAddress1and2} | 1          |
    When Operator clicks on 1 successful waypoint address in Photo Audit dialog
    Then Operator verifies waypoint parameters in Waypoint Details dialog:
      | address    | {KEY_CREATED_ORDER.buildToAddress1and2} |
      | contact    | {KEY_CREATED_ORDER.toContact}           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}         |
    When Operator clicks on "{KEY_CREATED_ORDER_TRACKING_ID}" Tracking Id in Waypoint Details dialog
    Then Operator switch to Edit Order's window
    When Operator close new tabs
    And Operator close Waypoint Details dialog
    And Operator clicks on 1 successful waypoint photo in Photo Audit dialog
    Then Operator verifies waypoint photo parameters in Photo Details dialog:
      | address | {KEY_CREATED_ORDER.buildToAddress1and2} |
      | contact | {KEY_CREATED_ORDER.toContact}           |
    When Operator close Photo Details dialog
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator click 'Go Back' button on Route Inbound page

  @DeleteOrArchiveRoute
  Scenario: Re-attempt to View Photo Evidence Successful Waypoint (uid:8a27e3b8-5714-4ed2-8871-d9e5cfda5606)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And DB Operator adds photo to delivery waypoint of created order
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
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
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator click 'Photo Audit' button on Route Inbound page
    Then Operator verifies successful waypoints title is "Successful Waypoints (1)" in Photo Audit dialog
    And Operator verifies successful waypoints parameters in Photo Audit dialog:
      | address                                 | photoCount |
      | {KEY_CREATED_ORDER.buildToAddress1and2} | 1          |
    When Operator clicks on 1 successful waypoint address in Photo Audit dialog
    Then Operator verifies waypoint parameters in Waypoint Details dialog:
      | address    | {KEY_CREATED_ORDER.buildToAddress1and2} |
      | contact    | {KEY_CREATED_ORDER.toContact}           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}         |
    When Operator clicks on "{KEY_CREATED_ORDER_TRACKING_ID}" Tracking Id in Waypoint Details dialog
    Then Operator switch to Edit Order's window
    When Operator close new tabs
    And Operator close Waypoint Details dialog
    And Operator clicks on 1 successful waypoint photo in Photo Audit dialog
    Then Operator verifies waypoint photo parameters in Photo Details dialog:
      | address | {KEY_CREATED_ORDER.buildToAddress1and2} |
      | contact | {KEY_CREATED_ORDER.toContact}           |
    When Operator close Photo Details dialog
    And Operator close Photo Audit dialog

  @DeleteOrArchiveRoute
  Scenario: Can Not View Successful Waypoint Without Photo Evidence (uid:8f32cc5e-4e88-4115-8143-bbc8a1f0c092)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
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
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator search "{KEY_CREATED_ORDER_TRACKING_ID}" Tracking ID in Photo Audit dialog
    Then Operator verifies successful waypoints title is "Successful Waypoints (1)" in Photo Audit dialog
    And Operator verifies no successful waypoints photos displayed in Photo Audit dialog
    When Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator click 'Go Back' button on Route Inbound page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op