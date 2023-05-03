@OperatorV2 @Core @Order @ViewTaggedOrders @ViewTaggedOrdersPart2
Feature: View Tagged Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: View Tagged Orders - En-route to Sorting Hub, No Route Id,  No Attempt, No Inbound Days (uid:c85cdc7d-03ad-4d19-9e84-f6a09b3fe923)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver pickup the created parcel successfully
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name}        |
      | granularStatus | En-route to Sorting Hub |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | {ninja-driver-name}             |
      | route                | {KEY_CREATED_ROUTE_ID}          |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | Not Inbounded                   |
      | granularStatus       | En-route to Sorting Hub         |

  @DeleteOrArchiveRoute
  Scenario: View Tagged Orders - On Vehicle Delivery, No Attempt (uid:47e71b73-c90e-43f8-86dd-869be076ec5d)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name}        |
      | granularStatus | On Vehicle for Delivery |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | {ninja-driver-name}             |
      | route                | {KEY_CREATED_ROUTE_ID}          |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | 1                               |
      | granularStatus       | On Vehicle for Delivery         |

  @DeleteOrArchiveRoute
  Scenario: View Tagged Orders - Pending Pickup at Distribution Point, No Route Id, No Attempt, No Inbound Days (uid:006826c7-611c-4212-8e02-fe65c7a32292)
    When Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    Given API DP creates a return fully integrated order in a dp "{dp-id}" and Shipper Legacy ID = "{shipper-v4-legacy-id}"
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name}                     |
      | granularStatus | Pending Pickup at Distribution Point |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID}      |
      | tags                 | {order-tag-name}                     |
      | driver               | No Driver                            |
      | route                | No Route                             |
      | lastAttempt          | No Attempt                           |
      | daysFromFirstInbound | Not Inbounded                        |
      | granularStatus       | Pending Pickup at Distribution Point |

  @DeleteOrArchiveRoute
  Scenario: View Tagged Orders - Pickup Fail, No Attempt, No Inbound Days (uid:df1fb45b-264f-4689-bbdd-044690c46754)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup using data below:
      | orderNumber            | 1           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name} |
      | granularStatus | Pickup fail      |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | {ninja-driver-name}             |
      | route                | {KEY_CREATED_ROUTE_ID}          |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | Not Inbounded                   |
      | granularStatus       | Pickup fail                     |

  @DeleteOrArchiveRoute
  Scenario: View Tagged Orders - Van en-route to pickup, No Attempt, No Inbound Days (uid:77704c4b-9221-4320-9449-8047d4f0159e)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name}       |
      | granularStatus | Van en-route to pickup |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | {ninja-driver-name}             |
      | route                | {KEY_CREATED_ROUTE_ID}          |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | Not Inbounded                   |
      | granularStatus       | Van en-route to pickup          |

  @KillBrowser
  Scenario: Kill Browser
    Given no-op