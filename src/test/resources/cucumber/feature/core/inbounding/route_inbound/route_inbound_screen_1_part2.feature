@OperatorV2 @Core @Inbounding @RouteInbound @RouteInboundScreen1Part2
Feature: Route Inbound Screen 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order's Transactions are Routed: More than 1 Route_Id (uid:0a303f61-a35d-46ac-97b7-7fa3b58debfd)
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Driver deliver the created parcel successfully
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                      |
      | fetchBy      | FETCH_BY_TRACKING_ID            |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID}           |
      | driverName  | {ninja-driver-name}              |
      | hubName     | {hub-name}                       |
      | routeDate   | {gradle-current-date-yyyy-MM-dd} |
      | wpPending   | 0                                |
      | wpPartial   | 0                                |
      | wpFailed    | 0                                |
      | wpCompleted | 1                                |
      | wpTotal     | 1                                |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order's Transactions are Routed: Only 1 Route_Id (uid:c77ab66c-7c1f-42bf-ac61-4a869be47651)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                        |
      | fetchBy      | FETCH_BY_TRACKING_ID              |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID}   |
      | routeId      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | driverName  | {ninja-driver-name}               |
      | hubName     | {hub-name}                        |
      | routeDate   | {gradle-current-date-yyyy-MM-dd}  |
      | wpPending   | 1                                 |
      | wpPartial   | 0                                 |
      | wpFailed    | 0                                 |
      | wpCompleted | 0                                 |
      | wpTotal     | 1                                 |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                        |
      | fetchBy      | FETCH_BY_TRACKING_ID              |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID}   |
      | routeId      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
      | driverName  | {ninja-driver-name}               |
      | hubName     | {hub-name}                        |
      | routeDate   | {gradle-current-date-yyyy-MM-dd}  |
      | wpPending   | 0                                 |
      | wpPartial   | 0                                 |
      | wpFailed    | 0                                 |
      | wpCompleted | 1                                 |
      | wpTotal     | 1                                 |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order is Not Routed (uid:edd843b2-f5ee-49e7-be18-adf71169da16)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                      |
      | fetchBy      | FETCH_BY_TRACKING_ID            |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 400 Unknown                |
      | errorCode    | 103096                     |
      | errorMessage | Order is not on any route! |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order Not Found (uid:40aef4e7-967d-450a-a1f3-8ba6e6266d7a)
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}           |
      | fetchBy      | FETCH_BY_TRACKING_ID |
      | fetchByValue | SOMEWRONGTRACKINGID  |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 404 Unknown      |
      | errorCode    | 103014           |
      | errorMessage | Order not found! |

  @DeleteOrArchiveRoute @DeleteDriver
  Scenario: Get Route Details by Driver Name - Number of Route_Id = 1 (uid:086b2bfe-8a68-43fb-a31d-011ef48de7bf)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator waits for 10 seconds
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_ID} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                     |
      | fetchBy      | FETCH_BY_DRIVER                |
      | fetchByValue | {KEY_CREATED_DRIVER.firstName} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID}           |
      | driverName  | {KEY_CREATED_DRIVER.firstName}   |
      | hubName     | {hub-name}                       |
      | routeDate   | {gradle-current-date-yyyy-MM-dd} |
      | wpPending   | 1                                |
      | wpPartial   | 0                                |
      | wpFailed    | 0                                |
      | wpCompleted | 0                                |
      | wpTotal     | 1                                |

  @DeleteOrArchiveRoute @DeleteDriver
  Scenario: Get Route Details by Driver Name - Number of Route_Id > 1 (uid:62ce5fbf-6f11-4dff-85ce-7c4d45e418f2)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator waits for 10 seconds
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_ID} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_ID} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                        |
      | fetchBy      | FETCH_BY_DRIVER                   |
      | fetchByValue | {KEY_CREATED_DRIVER.firstName}    |
      | routeId      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
      | driverName  | {KEY_CREATED_DRIVER.firstName}    |
      | hubName     | {hub-name}                        |
      | routeDate   | {gradle-current-date-yyyy-MM-dd}  |
      | wpPending   | 1                                 |
      | wpPartial   | 0                                 |
      | wpFailed    | 0                                 |
      | wpCompleted | 0                                 |
      | wpTotal     | 1                                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op