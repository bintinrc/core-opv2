@OperatorV2 @Core @EditOrder @OrderEvents @EditOrder1
Feature: Order Events

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Edit Order Event Table Showing Correctly for Order Event - Hub Inbound Scan (uid:bc007800-0866-45e1-9b51-c80ab9a7fa88)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify order event on Edit order page using data below:
      | name | HUB INBOUND SCAN |

  @DeleteOrArchiveRoute
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Add to Route (uid:7cf7dfc9-3f39-46e2-be72-3821e34588ee)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE           |
      | routeId | {KEY_CREATED_ROUTE_ID} |

  @DeleteOrArchiveRoute
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Driver Inbound Scan (uid:8671098a-bf35-43d2-80e5-3f9f8169f130)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | DRIVER INBOUND SCAN |

  @DeleteOrArchiveRoute
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Delivery Success (uid:09212b02-336e-494f-bd35-d8296216297a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | SUCCESS                |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify order event on Edit order page using data below:
      | name    | DELIVERY SUCCESS     |
      | routeId | KEY_CREATED_ROUTE_ID |

  @DeleteOrArchiveRoute
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Delivery Failure (uid:9d19c25a-7e53-4ad6-b02e-ad814d2d3847)
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
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify order event on Edit order page using data below:
      | name    | DELIVERY FAILURE     |
      | routeId | KEY_CREATED_ROUTE_ID |

  @DeleteOrArchiveRoute
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Pickup Failure (uid:4dca0169-3c1d-46ed-a7fd-cf3f733aa7bf)
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
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pickup Fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify order event on Edit order page using data below:
      | name    | PICKUP FAILURE       |
      | routeId | KEY_CREATED_ROUTE_ID |

  @DeleteOrArchiveRoute
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Pull Out of Route (uid:ddfcdd87-20d5-4b1f-968c-abe84ae1efa7)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator start the route
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | {KEY_CREATED_ORDER_TRACKING_ID} has been pulled from route {KEY_CREATED_ROUTE_ID} successfully |
      | waitUntilInvisible | true                                                                                           |
    Then Operator verify order event on Edit order page using data below:
      | name | PULL OUT OF ROUTE |

  Scenario: Edit Order Event Table Showing Correctly for Order Event - Assigned to DP (uid:0746ba48-c55a-4cd2-b802-0c7be37290c3)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "{dpms-id}" DP on Edit Order Page
    Then Operator verify order event on Edit order page using data below:
      | name | ASSIGNED TO DP |

  Scenario: Edit Order Event Table Showing Correctly for Order Event - Added to Reservation (uid:d32ee708-564b-47b2-85ba-7494090e48c0)
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator can find created reservation mapped to created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name        | ADDED TO RESERVATION                         |
      | description | Reservation ID: {KEY_CREATED_RESERVATION_ID} |

  @DeleteOrArchiveRoute
  Scenario: Operator Applies Filter on Events Table (uid:966000fe-cb85-4093-90df-26b6f125a201)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add reservation pick-up to the route
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Delivery toggle to yes
    And Operator change the COD value to "100"
    And Operator update order status on Edit order page using data below:
      | granularStatus | Pending Pickup                      |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator click Delivery -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | {KEY_CREATED_ORDER_TRACKING_ID} has been pulled from route {KEY_CREATED_ROUTE_ID} successfully |
      | waitUntilInvisible | true                                                                                           |
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator confirm manually complete order on Edit Order page
    When Operator selects "All Events" in Events Filter menu on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | tags               | name                 |
      | SYSTEM ACTION      | PRICING CHANGE       |
      | MANUAL ACTION      | FORCED SUCCESS       |
      | COD, MANUAL ACTION | UPDATE CASH          |
      | MANUAL ACTION      | PULL OUT OF ROUTE    |
      | MANUAL ACTION      | UPDATE STATUS        |
      | MANUAL ACTION      | ADD TO ROUTE         |
      | MANUAL ACTION      | UPDATE ADDRESS       |
      | DP                 | ASSIGNED TO DP       |
      | SCAN, DELIVERY     | ROUTE INBOUND SCAN   |
      | SCAN, DELIVERY     | DRIVER INBOUND SCAN  |
      | SORT, SCAN         | HUB INBOUND SCAN     |
      | PICKUP             | ADDED TO RESERVATION |
    When Operator selects "System Actions Only" in Events Filter menu on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | tags          | name           |
      | SYSTEM ACTION | PRICING CHANGE |
    When Operator selects "Manual Actions Only" in Events Filter menu on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | tags               | name              |
      | MANUAL ACTION      | FORCED SUCCESS    |
      | COD, MANUAL ACTION | UPDATE CASH       |
      | MANUAL ACTION      | PULL OUT OF ROUTE |
      | MANUAL ACTION      | UPDATE STATUS     |
      | MANUAL ACTION      | ADD TO ROUTE      |
      | MANUAL ACTION      | UPDATE ADDRESS    |
    When Operator selects "Scans Only" in Events Filter menu on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | tags           | name                |
      | SORT, SCAN     | HUB INBOUND SCAN    |
      | SCAN, DELIVERY | DRIVER INBOUND SCAN |
      | SCAN, DELIVERY | ROUTE INBOUND SCAN  |
    When Operator selects "Pickups Only" in Events Filter menu on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | tags   | name                 |
      | PICKUP | ADDED TO RESERVATION |
    When Operator selects "Deliveries Only" in Events Filter menu on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | tags           | name                |
      | SCAN, DELIVERY | DRIVER INBOUND SCAN |
      | SCAN, DELIVERY | ROUTE INBOUND SCAN  |
    When Operator selects "CODs Only" in Events Filter menu on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | tags               | name        |
      | COD, MANUAL ACTION | UPDATE CASH |
    When Operator selects "DPs Only" in Events Filter menu on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | tags | name           |
      | DP   | ASSIGNED TO DP |
