@OperatorV2 @Core @Order @ViewTaggedOrders
Feature: View Tagged Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View Tagged Orders - Pending Pickup, No Route Id, No Attempt, No Inbound Days
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name} |
      | granularStatus | Pending Pickup   |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | No Driver                       |
      | route                | No Route                        |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | Not Inbounded                   |
      | granularStatus       | Pending Pickup                  |

  @DeleteOrArchiveRoute
  Scenario: View Tagged Orders - Delivery Attempted, Pending Reschedule
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name}   |
      | granularStatus | Pending Reschedule |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID}     |
      | tags                 | {order-tag-name}                    |
      | driver               | {ninja-driver-name}                 |
      | route                | {KEY_CREATED_ROUTE_ID}              |
      | lastAttempt          | ^{gradle-current-date-yyyy-MM-dd}.* |
      | daysFromFirstInbound | 1                                   |
      | granularStatus       | Pending Reschedule                  |

  Scenario: View Tagged Orders - Arrived at Sorting Hub, No Route Id,  No Attempt
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name}       |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | No Driver                       |
      | route                | No Route                        |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | 1                               |
      | granularStatus       | Arrived at Sorting Hub          |

  Scenario: View Tagged Orders - Arrived at Sorting Hub, No Route Id,  No Attempt
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name} |
      | granularStatus | Staging          |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | No Driver                       |
      | route                | No Route                        |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | Not Inbounded                   |
      | granularStatus       | Staging                         |

  Scenario: View Tagged Orders - On Hold, No Route Id,  No Attempt, No Inbound Days
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
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
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name} |
      | granularStatus | On Hold          |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | No Driver                       |
      | route                | No Route                        |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | Not Inbounded                   |
      | granularStatus       | On Hold                         |

  @DeleteOrArchiveRoute
  Scenario: View Tagged Orders - DP Delivery Attempted, Arrived at Distribution Point
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
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
    When Operator go to menu Order -> View Tagged Orders
    And Operator selects filter and clicks Load Selection on View Tagged Orders page:
      | orderTags      | {order-tag-name}              |
      | granularStatus | Arrived at Distribution Point |
    Then Operator verifies tagged order params on View Tagged Orders page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID}     |
      | tags                 | {order-tag-name}                    |
      | driver               | {ninja-driver-name}                 |
      | route                | {KEY_CREATED_ROUTE_ID}              |
      | lastAttempt          | ^{gradle-current-date-yyyy-MM-dd}.* |
      | daysFromFirstInbound | 1                                   |
      | granularStatus       | Arrived at Distribution Point       |

  @DeleteOrArchiveRoute
  Scenario: View Tagged Orders - En-route to Sorting Hub, No Route Id,  No Attempt, No Inbound Days
    Given Operator go to menu Shipper Support -> Blocked Dates
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
  Scenario: View Tagged Orders - On Vehicle Delivery, No Attempt
    Given Operator go to menu Shipper Support -> Blocked Dates
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
  Scenario: View Tagged Orders - Pending Pickup at Distribution Point, No Route Id, No Attempt, No Inbound Days
    When Operator go to menu Shipper Support -> Blocked Dates
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
  Scenario: View Tagged Orders - Pickup Fail, No Attempt, No Inbound Days
    Given Operator go to menu Shipper Support -> Blocked Dates
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
  Scenario: View Tagged Orders - Van en-route to pickup, No Attempt, No Inbound Days
    Given Operator go to menu Shipper Support -> Blocked Dates
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