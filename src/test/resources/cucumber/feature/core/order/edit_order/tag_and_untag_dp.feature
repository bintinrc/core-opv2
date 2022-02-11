@OperatorV2 @Core @Order @EditOrder @TagAndUntagDP
Feature: Tag & Untag DP

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Tag Order to DP (uid:b6540556-8969-4519-9716-f273a96db356)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "{dpms-id}" DP on Edit Order Page
    Then Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | ASSIGNED TO DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    When DB Operator get DP address by ID = "{dpms-id}"
    Then DB Operator verifies orders record using data below:
      | toAddress1 | GET_FROM_CREATED_ORDER |
      | toAddress2 | GET_FROM_CREATED_ORDER |
      | toPostcode | GET_FROM_CREATED_ORDER |
      | toCity     | GET_FROM_CREATED_ORDER |
      | toCountry  | GET_FROM_CREATED_ORDER |
      | toState    |                        |
      | toDistrict |                        |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | distribution_point_id | {dpms-id}              |
      | address1              | GET_FROM_CREATED_ORDER |
      | address2              | GET_FROM_CREATED_ORDER |
      | postcode              | GET_FROM_CREATED_ORDER |
      | city                  | GET_FROM_CREATED_ORDER |
      | country               | GET_FROM_CREATED_ORDER |
    And Operator verifies Delivery Details are updated on Edit Order Page
    And DB Operator verify Delivery waypoint record is updated
    And DB Operator verify the order_events record exists for the created order with type:
      | 18 |

  Scenario: Operator Untag/Remove Order from DP (uid:cc4e3098-6bdd-48ea-9488-579535af8722)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "{dpms-id}" DP on Edit Order Page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | distribution_point_id | 0                      |
      | address1              | GET_FROM_CREATED_ORDER |
      | address2              | GET_FROM_CREATED_ORDER |
      | postcode              | GET_FROM_CREATED_ORDER |
      | city                  | GET_FROM_CREATED_ORDER |
      | country               | GET_FROM_CREATED_ORDER |
    And DB Operator verifies delivery info is updated in order record
    And Operator verifies Delivery Details are updated on Edit Order Page
    And DB Operator verify Delivery waypoint record is updated
    And DB Operator verify the order_events record exists for the created order with type:
      | 35 |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Untag DP Order that is merged and routed (uid:77fec425-2a5b-4667-b82f-b6394caec5d5)
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator merge route transactions
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    When Operator get multiple "DELIVERY" transactions with status "PENDING"
    Then DB Operator verifies all route_waypoint records
    And DB Operator verifies all waypoints status is "ROUTED"
    And DB Operator verifies all waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints
    And DB Operator verifies all route_monitoring_data records

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Untag DP Order that is not merged and routed (uid:2c86a0e4-480f-4361-90e5-0be6628c90cb)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    When Operator get multiple "DELIVERY" transactions with status "PENDING"
    Then DB Operator verifies all route_waypoint records
    And DB Operator verifies all waypoints status is "ROUTED"
    And DB Operator verifies all waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints
    And DB Operator verifies all route_monitoring_data records

  @routing-refactor
  Scenario: Untag DP Order that is merged and not routed (uid:cea0056a-d4e8-4d54-8b7d-28fc786ee3db)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator assign delivery multiple waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And Operator get multiple "DELIVERY" transactions with status "PENDING"
    And Operator merge transactions on Zonal Routing
    Then API Operator verifies Delivery transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    When Operator get multiple "DELIVERY" transactions with status "PENDING"
    Then DB Operator verifies all waypoints status is "PENDING"
    And DB Operator verifies all waypoints.route_id & seq_no is NULL

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
