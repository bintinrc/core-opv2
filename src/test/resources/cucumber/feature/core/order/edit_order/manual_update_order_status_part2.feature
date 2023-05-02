@OperatorV2 @Core @EditOrder @ManualUpdateOrderStatusPart2 @EditOrder1
Feature: Manual Update Order Status

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Manually Update Order Granular Status - Pending Pickup at Distribution Point (<uuid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus                       | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                   | uuid                                     |
      | Pending Pickup at Distribution Point | Pending | PENDING      | PENDING        | PENDING        | PENDING          | Old Granular Status: Pending Pickup\nNew Granular Status: Pending Pickup at Distribution Point\n\nReason: Status updated for testing purposes | uid:a7cfefcc-aad6-471a-a5a7-0fb61e52963f |

  Scenario: Operator Manually Update Order Granular Status - Pending Pickup, Latest Pickup is Unrouted (uid:e1f23694-0b3d-49e4-b891-24b5ea3b6637)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator update order status on Edit order page using data below:
      | granularStatus | Pending Pickup                      |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Success\nNew Pickup Status: Pending\n\nOld Granular Status: Arrived at Sorting Hub\nNew Granular Status: Pending Pickup\n\nOld Order Status: Transit\nNew Order Status: Pending\n\nReason: Status updated for testing purposes |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |

  @DeleteOrArchiveRoute
  Scenario: Operator Manually Update Order Granular Status - Pending Pickup, Latest Pickup is Routed (uid:6aa58426-ed6c-494c-9b42-524f2764be77)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator update order status on Edit order page using data below:
      | granularStatus | Pending Pickup                      |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                       |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Success\nNew Pickup Status: Pending\n\nOld Granular Status: Arrived at Sorting Hub\nNew Granular Status: Pending Pickup\n\nOld Order Status: Transit\nNew Order Status: Pending\n\nReason: Status updated for testing purposes |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |

  Scenario: Operator Manually Update Order Granular Status - On Vehicle for Delivery , Latest Delivery is Unrouted (uid:af550420-08b8-46af-bddf-bce1b9dd2f02)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Pending Reschedule                |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator update order status on Edit order page using data below:
      | granularStatus | On Vehicle for Delivery             |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                   |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Fail\nNew Delivery Status: Pending\n\nOld Granular Status: Pending Reschedule\nNew Granular Status: On Vehicle for Delivery\n\nOld Order Status: Delivery fail\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | SUCCESS |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |

  @DeleteOrArchiveRoute
  Scenario: Operator Manually Update Order Granular Status - On Vehicle for Delivery, Latest Delivery is Routed (uid:20006f7c-3f0b-4ce8-ad23-e98049e8a629)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Pending Reschedule                |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator update order status on Edit order page using data below:
      | granularStatus | On Vehicle for Delivery             |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                   |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Fail\nNew Delivery Status: Pending\n\nOld Granular Status: Pending Reschedule\nNew Granular Status: On Vehicle for Delivery\n\nOld Order Status: Delivery fail\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | SUCCESS |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |

  Scenario: Operator Not Allowed to Manually Update Normal Order Granular Status - Pickup Fail (uid:e515270b-6d35-4bf1-a282-d75e2112e836)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | Pickup fail                         |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                              |
      | bottom | ^.*Error Message: "Pickup fail status is only for return orders".* |
    When Operator refresh page
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page

  Scenario: Disable Manual Update Status for On Hold Order with Active PETS Ticket (uid:037cbbf0-9f33-4044-866e-78367d2805c7)
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | On Hold                           |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify menu item "Order Settings" > "Update Status" is disabled on Edit order page

  Scenario: Disable Manual Update Status for Returned To Sender Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator force succeed created order without cod
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify menu item "Order Settings" > "Update Status" is disabled on Edit order page

  @DeleteOrArchiveRoute
  Scenario: Operator Manually Update Order Granular Status - Pending Reschedule to Arrived at Sorting Hub
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Pending Reschedule                |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator update order status on Edit order page using data below:
      | granularStatus | Arrived at Sorting Hub              |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Fail\nNew Delivery Status: Pending\n\nOld Granular Status: Pending Reschedule\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: Delivery fail\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | SUCCESS |
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION.waypointId} |
      | status  | Routed                       |
      | routeId | {KEY_CREATED_ROUTE_ID}       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
