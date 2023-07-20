@OperatorV2 @Core @EditOrder @ResumeOrder @EditOrder2
Feature: Resume Order

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @routing-refactor @happy-path
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Pickup Cancelled, Delivery Cancelled (uid:849dfc99-3ee7-4e7d-a665-bbfec8396ff3)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status to = "Cancelled"
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Cancelled\nNew Granular Status: Pending Pickup\n\nOld Order Status: Cancelled\nNew Order Status: Pending\n\nReason: RESUME_ORDER |

  Scenario: Operator Resume an Order on Edit Order page - Non-Cancelled Order (uid:d55ff55e-4422-4e41-b836-aed757f72dc4)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Then Operator verify menu item "Order Settings" > "Resume Order" is disabled on Edit order page
    When API Operator resume the created order
    And Operator refresh page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |

  @DeleteOrArchiveRoute
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Return Pickup Fail With Waypoint
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    And API Operator cancel created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    When Operator get "Pickup" transaction with status "Fail"
    Then DB Operator verifies waypoint status is "FAIL"
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Cancelled\nNew Granular Status: Pending Pickup\n\nOld Order Status: Cancelled\nNew Order Status: Pending\n\nReason: RESUME_ORDER |

  @DeleteOrArchiveRoute
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Delivery is Not Cancelled (uid:9f299d69-54b1-4049-93ee-bc9bdaf50476)
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
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Pending Reschedule                |
    And API Operator force cancels the created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Cancelled\nNew Granular Status: Pending Pickup\n\nOld Order Status: Cancelled\nNew Order Status: Pending\n\nReason: RESUME_ORDER |
    Then DB Operator verify the last Pickup transaction record of the created order:
      | status | Pending |
      | dnrId  | 0       |
    Then DB Operator verify the last Delivery transaction record of the created order:
      | status | Fail |

  Scenario: Operator Resume a Cancelled Order on Edit Order page - Return Pickup Fail With NO Waypoint (uid:6086ccbe-01f6-4d6b-bcb6-a0f5f420dd4b)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status to = "Pickup Fail"
    And API Operator cancel created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator get "Pickup" transaction with status "Fail"
    Then DB Operator verify the last Pickup transaction record of the created order:
      | status | Pending |
      | dnrId  | 0       |
    And DB Operator verify the last Delivery transaction record of the created order:
      | status | Pending |
      | dnrId  | 0       |
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Cancelled\nNew Granular Status: Pending Pickup\n\nOld Order Status: Cancelled\nNew Order Status: Pending\n\nReason: RESUME_ORDER |
