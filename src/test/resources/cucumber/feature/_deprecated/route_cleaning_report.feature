@OperatorV2Deprecated @RouteCleaningReport
Feature: Route Cleaning Report

  # THIS FEATURE HAS BEEN DEPRECATED

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator download Excel report on Route Cleaning Report successfully (uid:860479ee-1308-41ef-bd2f-1e14ab841e8b)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given Operator go to menu Fleet -> Route Cash Inbound
    When Operator create new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is created successfully
    Given Operator go to menu Recovery -> Route Cleaning Report
    When Operator download Excel report on Route Cleaning Report page
    Then Operator download Excel report on Route Cleaning Report page successfully

  @DeleteOrArchiveRoute
  Scenario: Operator verify the COD information is correct on Route Cleaning Report (uid:3d81bfb3-1a19-4f3e-b434-12668a7a0300)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Fleet -> Route Cash Inbound
    When Operator create new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is created successfully
    When Operator go to menu Recovery -> Route Cleaning Report
    And Operator Select COD on Route Cleaning Report page
    And Operator fetch by current date on Route Cleaning Report page
    Then Operator verify the COD information on Route Cleaning Report page by following parameters:
      | codInbound  | GET_FROM_CREATED_COD   |
      | codExpected | GET_FROM_CREATED_ORDER |
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |

  @DeleteOrArchiveRoute
  Scenario: Operator download CSV of selected COD and verify the CSV contains correct information on Route Cleaning Report (uid:d9fb1eb2-4d47-42e0-8c1b-669391020e00)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Fleet -> Route Cash Inbound
    When Operator create new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is created successfully
    When Operator go to menu Recovery -> Route Cleaning Report
    And Operator Select COD on Route Cleaning Report page
    And Operator fetch by current date on Route Cleaning Report page
    And Operator collect COD info for the route
    Then Operator download CSV for the new COD on Route Cleaning Report page
    And Operator verify the COD info is correct in downloaded CSV file

  @DeleteOrArchiveRoute
  Scenario: Operator verify order info on Parcel tab is correct on Route Cleaning Report page (uid:679392bc-3621-4fc0-8592-b1e6abfaf0a0)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    When Operator go to menu Recovery -> Route Cleaning Report
    And Operator Select Parcel on Route Cleaning Report page
    And Operator fetch by current date on Route Cleaning Report page
    And Operator verify the Parcel info for the created order is correct on Route Cleaning Report page by following parameters:
      | trackingId     | GET_FROM_CREATED_ORDER |
      | granularStatus | Arrived at Sorting Hub |
      | lastScanHubId  | {hub-id}               |
      | exception      | Pending delivery       |
      | routeId        | GET_FROM_CREATED_ROUTE |
      | shipperName    | {shipper-v4-name}      |
      | driverName     | {ninja-driver-name}    |
      | lastScanType   | INBOUND (SORTING_HUB)  |

  @DeleteOrArchiveRoute
  Scenario: Operator download CSV of order on Parcel tab and verify the info is correct on Route Cleaning Report page (uid:96f0836b-b890-4a2f-a2c2-1c356c0e228a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    When Operator go to menu Recovery -> Route Cleaning Report
    And Operator Select Parcel on Route Cleaning Report page
    And Operator fetch by current date on Route Cleaning Report page
    And Operator collect Parcel info for the created order on Route Cleaning Report page
    Then Operator download CSV for the created order on Route Cleaning Report page
    And Operator verify the Parcel info is correct in downloaded CSV file

  @DeleteOrArchiveRoute
  Scenario: Operator should be able to create a ticket from Route Cleaning Report page (uid:4dd2ec04-3136-426b-8462-4fca7e7321a6)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    When Operator go to menu Recovery -> Route Cleaning Report
    And Operator Select Parcel on Route Cleaning Report page
    And Operator fetch by current date on Route Cleaning Report page
    And Operator verify the Parcel info for the created order is correct on Route Cleaning Report page by following parameters:
      | trackingId     | GET_FROM_CREATED_ORDER |
      | granularStatus | Arrived at Sorting Hub |
      | lastScanHubId  | {hub-id}               |
      | exception      | Pending delivery       |
      | routeId        | GET_FROM_CREATED_ROUTE |
      | shipperName    | {shipper-v4-name}      |
      | driverName     | {ninja-driver-name}    |
      | lastScanType   | INBOUND (SORTING_HUB)  |
    And Operator create ticket for the created order on Route Cleaning Report page
    Then Operator verify ticket was created for the created order on Route Cleaning Report page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
