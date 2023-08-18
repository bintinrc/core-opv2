@OperatorV2 @Core @Order @ViewTaggedOrders @ViewTaggedOrdersPart1
Feature: View Tagged Orders

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View Tagged Orders - Pending Pickup, No Route Id, No Attempt, No Inbound Days
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_CREATED_ORDER_ID} |
      | orderTag | {order-tag-id}         |
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
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_CREATED_ORDER_ID} |
      | orderTag | {order-tag-id}         |
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
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

  Scenario: View Tagged Orders - Arrived at Sorting Hub, No Route Id, No Attempt
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_CREATED_ORDER_ID} |
      | orderTag | {order-tag-id}         |
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

  Scenario: View Tagged Orders - Staging, No Route Id, No Attempt, No Inbound Days
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_CREATED_ORDER_ID} |
      | orderTag | {order-tag-id}         |
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

  Scenario: View Tagged Orders - On Hold, No Route Id, No Attempt, No Inbound Days
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_CREATED_ORDER_ID} |
      | orderTag | {order-tag-id}         |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | On Hold                           |
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
    When Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_CREATED_ORDER_ID} |
      | orderTag | {order-tag-id}         |
    Given Operator go to menu Distribution Points -> DP Tagging
    And Operator wait for DP tagging page to load
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
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
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
