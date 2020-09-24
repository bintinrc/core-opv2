@OperatorV2 @Core @Inbounding @RouteInbound
Feature: Route Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario Outline: Operator get route details by - <Title> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | hubName      | {hub-name}     |
      | fetchBy      | <fetchBy>      |
      | fetchByValue | <fetchByValue> |
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
    Examples:
      | Title       | hiptest-uid                              | fetchBy              | fetchByValue                    |
      | Route ID    | uid:a5f5fc7f-ee43-423a-a0f8-9e1193285952 | FETCH_BY_ROUTE_ID    | {KEY_CREATED_ROUTE_ID}          |
      | Tracking ID | uid:dbbf61d7-deec-4e8e-8277-f2a73ac05768 | FETCH_BY_TRACKING_ID | {KEY_CREATED_ORDER_TRACKING_ID} |
      | Driver      | uid:97852b05-c887-40a7-88b7-2a6cba64e6a1 | FETCH_BY_DRIVER      | {ninja-driver-name}             |


  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Route ID - Route with Waypoints (uid:896979db-0ac5-4304-9c94-e76c9d8c4a02)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Add  waypoints to success
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Fleet -> Route Cash Inbound
    And Operator create new COD on Route Cash Inbound page
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
#    Add waypoints to fail
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator create new COD on Route Cash Inbound page
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
# Add pedding waypoints
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Fleet -> Route Cash Inbound
    And Operator create new COD on Route Cash Inbound page
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver successfully deliver created parcels with numbers: 1, 2, 3
    And API Driver failed the delivery of parcels with numbers: 4, 5, 6
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
      | wpPending   | 4                      |
      | wpPartial   | 0                      |
      | wpFailed    | 3                      |
      | wpCompleted | 3                      |
      | wpTotal     | 10                     |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Route ID - Route with No Waypoints (uid:fc8b3c2d-a024-4cae-8bc1-b8377f056326)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 400 Unknown            |
      | errorCode    | 103009                 |
      | errorMessage | route has no waypoints |

  Scenario: Get Route Details by Route ID - Route doesn't Exist (uid:fb74d8c6-e48a-454f-bf6d-e8da56cf43bf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}        |
      | fetchBy      | FETCH_BY_ROUTE_ID |
      | fetchByValue | 123456            |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 404 Unknown      |
      | errorCode    | 103019           |
      | errorMessage | Route not found! |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Route ID - Route not Assigned to a Driver (uid:09c660de-0c62-4171-bcf1-3c0a4b93560b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id} } |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 400 Unknown                       |
      | errorCode    | 103088                            |
      | errorMessage | Route is not assigned to a driver |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order's Transactions are Routed: More than 1 Route_Id (uid:0a303f61-a35d-46ac-97b7-7fa3b58debfd)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
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

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order's Transactions are Routed: Only 1 Route_Id (uid:c77ab66c-7c1f-42bf-ac61-4a869be47651)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID     |
      | routeId      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | driverName  | {ninja-driver-name}               |
      | hubName     | {hub-name}                        |
      | routeDate   | GET_FROM_CREATED_ROUTE            |
      | wpPending   | 1                                 |
      | wpPartial   | 0                                 |
      | wpFailed    | 0                                 |
      | wpCompleted | 0                                 |
      | wpTotal     | 1                                 |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                        |
      | fetchBy      | FETCH_BY_TRACKING_ID              |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID     |
      | routeId      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
      | driverName  | {ninja-driver-name}               |
      | hubName     | {hub-name}                        |
      | routeDate   | GET_FROM_CREATED_ROUTE            |
      | wpPending   | 0                                 |
      | wpPartial   | 0                                 |
      | wpFailed    | 0                                 |
      | wpCompleted | 1                                 |
      | wpTotal     | 1                                 |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order is Not Routed (uid:edd843b2-f5ee-49e7-be18-adf71169da16)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 400 Unknown                |
      | errorCode    | 103096                     |
      | errorMessage | Order is not on any route! |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order Not Found (uid:40aef4e7-967d-450a-a1f3-8ba6e6266d7a)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
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
      | routeId     | {KEY_CREATED_ROUTE_ID}                                      |
      | driverName  | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} |
      | hubName     | {hub-name}                                                  |
      | routeDate   | GET_FROM_CREATED_ROUTE                                      |
      | wpPending   | 1                                                           |
      | wpPartial   | 0                                                           |
      | wpFailed    | 0                                                           |
      | wpCompleted | 0                                                           |
      | wpTotal     | 1                                                           |

  @DeleteOrArchiveRoute @DeleteDriver
  Scenario: Get Route Details by Driver Name - Number of Route_Id > 1 (uid:62ce5fbf-6f11-4dff-85ce-7c4d45e418f2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
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
      | routeId     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]}                           |
      | driverName  | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} |
      | hubName     | {hub-name}                                                  |
      | routeDate   | GET_FROM_CREATED_ROUTE                                      |
      | wpPending   | 1                                                           |
      | wpPartial   | 0                                                           |
      | wpFailed    | 0                                                           |
      | wpCompleted | 0                                                           |
      | wpTotal     | 1                                                           |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
