#@OperatorV2 @Core @EditOrder @EditOrderRouting @EditOrder2 @RoutingModules
Feature: Routing

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @routing-refactor @happy-path
  Scenario Outline: Operator Add to Route on Delivery Menu Edit Order Page - <Note> (<hiptest-uid>)
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator add created order route on Edit Order page using data below:
      | type    | Delivery               |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verifies that info toast displayed:
      | top | {KEY_CREATED_ORDER_TRACKING_ID} has been added to route {KEY_CREATED_ROUTE_ID} successfully |
    When Operator refresh page
    Then Operator verify Latest Route ID is "{KEY_CREATED_ROUTE_ID}" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE         |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id

    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly


    And DB Operator verifies route_monitoring_data record
    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    Then Verify that waypoints are shown on driver "{ninja-driver-id}" list route correctly

    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:9d63adef-503f-48af-9232-c2a003c5240e | Normal    |
      | Return | uid:75222ea2-43c3-4783-9b1c-bed9a999f45e | Return    |

  @DeleteOrArchiveRoute @routing-refactor @happy-path
  Scenario: Operator Pull Out Parcel from a Route - PICKUP (uid:c6ab425f-c508-451f-b84c-09eb267c5f27)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Pickup -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | {KEY_CREATED_ORDER_TRACKING_ID} has been pulled from route {KEY_CREATED_ROUTE_ID} successfully |
      | waitUntilInvisible | true                                                                                           |
    Then Operator verify Pickup transaction on Edit order page using data below:
      | routeId |  |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify order_events record for the created order:
      | type | 33 |
    Then DB Operator verify next Pickup transaction values are updated for the created order:
      | routeId | 0 |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

    And DB Operator verifies route_monitoring_data is hard-deleted

  #   TODO DISABLED
  #scenario is disabled because causing db inconsistent data
  #  Scenario: Operator Pull Out Parcel from a Route - PICKUP - Route is Soft Deleted (uid:ea35eba9-818c-4a84-a4c5-bb884bd1ba91)
  #    Given API Shipper create V4 order using data below:
  #      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                     |
  #      | v4OrderRequest    | {"service_type":"Return","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
  #    Given API Operator create new route using data below:
  #      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
  #    Given API Operator add parcel to the route using data below:
  #      | addParcelToRouteRequest | { "type":"PP" } |
  #    And DB Operator soft delete route "KEY_CREATED_ROUTE_ID"
  #    And API Operator get order details
  #    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
  #    And Operator click Pickup -> Pull from Route on Edit Order page
  #    And Operator pull out parcel from the route for Pickup on Edit Order page
  #    And Operator refresh page
  #    Then Operator verify order events on Edit order page using data below:
  #      | name              |
  #      | PULL OUT OF ROUTE |
  #    Then DB Operator verify next Pickup transaction values are updated for the created order:
  #      | routeId | 0 |
  #    And DB Operator verifies transaction route id is null
  #    And DB Operator verifies waypoints.route_id & seq_no is NULL
  #
  #    And DB Operator verifies route_monitoring_data is hard-deleted
  #    And DB Operator verifies waypoint status is "PENDING"

  @DeleteOrArchiveRoute @routing-refactor @happy-path
  Scenario: Operator Pull Out Parcel from a Route - DELIVERY (uid:91bf2923-94ba-4d8c-bd1b-c000eca19ee9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | {KEY_CREATED_ORDER_TRACKING_ID} has been pulled from route {KEY_CREATED_ROUTE_ID} successfully |
      | waitUntilInvisible | true                                                                                           |
    Then Operator verify Delivery transaction on Edit order page using data below:
      | routeId |  |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify order_events record for the created order:
      | type | 33 |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | routeId | 0 |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |

    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

    And DB Operator verifies route_monitoring_data is hard-deleted

  #   TODO DISABLED
  #scenario is disabled because causing db inconsistent data
  #  Scenario: Operator Pull Out Parcel from a Route - DELIVERY - Route is Soft Deleted (uid:a3346fd5-8f4f-40c6-98f1-5fd172a2261c)
  #    Given API Shipper create V4 order using data below:
  #      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
  #      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
  #    Given API Operator create new route using data below:
  #      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
  #    Given API Operator add parcel to the route using data below:
  #      | addParcelToRouteRequest | { "type":"DD" } |
  #    And DB Operator soft delete route "KEY_CREATED_ROUTE_ID"
  #    And API Operator get order details
  #    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
  #    And Operator click Delivery -> Pull from Route on Edit Order page
  #    And Operator pull out parcel from the route for Delivery on Edit Order page
  #    And Operator refresh page
  #    Then Operator verify order events on Edit order page using data below:
  #      | name              |
  #      | PULL OUT OF ROUTE |
  #    Then DB Operator verify next Delivery transaction values are updated for the created order:
  #      | routeId | 0 |
  #    And DB Operator verifies transaction route id is null
  #    And DB Operator verifies waypoints.route_id & seq_no is NULL
  #
  #    And DB Operator verifies route_monitoring_data is hard-deleted
  #    And DB Operator verifies waypoint status is "PENDING"

  @DeleteOrArchiveRoute @routing-refactor @happy-path
  Scenario Outline: Operator Add to Route on Pickup Menu Edit Order Page - <Note> (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator add created order to the <routeType> route on Edit Order page
    Then Operator verifies that info toast displayed:
      | top | {KEY_CREATED_ORDER_TRACKING_ID} has been added to route {KEY_CREATED_ROUTE_ID} successfully |
    And Operator refresh page
    Then Operator verify the order is added to the "<routeType>" route on Edit Order page
    Then Operator verify Latest Route ID is "{KEY_CREATED_ROUTE_ID}" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE         |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify <routeType> waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly

    And DB Operator verifies route_monitoring_data record
    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    Then Verify that waypoints are shown on driver "{ninja-driver-id}" list route correctly
    Examples:
      | Note              | hiptest-uid                              | orderType | routeType |
      | Return - Delivery | uid:ce190fcf-c0d5-47ad-9777-0296edecc8c2 | Return    | Delivery  |
      | Return - Pickup   | uid:0c1c44ce-9fce-46e7-9016-f73613eef833 | Return    | Pickup    |

  Scenario: Block Add to Route for Cancelled Order on Edit Order Page
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator cancel created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify menu item "Delivery" > "Add To Route" is disabled on Edit order page
