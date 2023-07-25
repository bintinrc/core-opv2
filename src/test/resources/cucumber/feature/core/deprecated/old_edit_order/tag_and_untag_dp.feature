#@OperatorV2 @Core @EditOrder @TagAndUntagDP @EditOrder1 @RoutingModules
Feature: Tag & Untag DP

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path
  Scenario: Operator Tag Order to DP (uid:b6540556-8969-4519-9716-f273a96db356)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "QA core api automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "{dpms-id}" DP on Edit Order Page
    Then Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verifies Delivery Details on Edit Order Page:
      | toName     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}    |
      | toEmail    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}   |
      | toContact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact} |
      | toAddress1 | 501, ORCHARD ROAD, SG, 238880             |
      | toAddress2 | 3-4                                       |
      | toPostcode | 238880                                    |
    And Operator verify order event on Edit order page using data below:
      | name | ASSIGNED TO DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE AV |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | toAddress1 | 501, ORCHARD ROAD, SG, 238880      |
      | toAddress2 | 3-4                                |
      | toPostcode | 238880                             |
      | toCity     | SG                                 |
      | toCountry  | SG                                 |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrdersManagerImpl::generateOrderDataBean   |
      | seq_no   | 1                                          |
    And DB Core - verify transactions record:
      | id                    | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId            | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status                | Pending                                                    |
      | distribution_point_id | {dpms-id}                                                  |
      | address1              | 501, ORCHARD ROAD, SG, 238880                              |
      | address2              | 3-4                                                        |
      | postcode              | 238880                                                     |
      | city                  | SG                                                         |
      | country               | SG                                                         |
    And DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | 501, ORCHARD ROAD, SG, 238880                              |
      | address2 | 3-4                                                        |
      | postcode | 238880                                                     |
      | city     | SG                                                         |
      | country  | SG                                                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | 501, ORCHARD ROAD, SG, 238880                              |
      | address2 | 3-4                                                        |
      | postcode | 238880                                                     |
      | city     | SG                                                         |
      | country  | SG                                                         |

  @happy-path
  Scenario: Operator Untag/Remove Order from DP (uid:cc4e3098-6bdd-48ea-9488-579535af8722)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "QA core api automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "{dpms-id}" DP on Edit Order Page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE AV |
    And Operator verifies Delivery Details on Edit Order Page:
      | toName     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | toEmail    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | toContact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | toAddress1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | toAddress2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | toPostcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | toAddress1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | toAddress2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | toPostcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | toCountry  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
    And DB Core - verify transactions record:
      | id                    | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId            | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status                | Pending                                                    |
      | distribution_point_id | null                                                       |
      | address1              | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | address2              | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}                 |
      | postcode              | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}                 |
      | country               | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}                  |
    And DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}                 |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}                 |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}                  |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}                 |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}                 |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}                  |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Untag DP Order that is merged and routed
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator tag "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order to "{dp-id}" DP
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    When Operator get multiple "DELIVERY" transactions with status "PENDING"
    And DB Operator verifies all waypoints status is "ROUTED"
    And DB Operator verifies all waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies all route_monitoring_data records

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Untag DP Order that is not merged and routed (uid:2c86a0e4-480f-4361-90e5-0be6628c90cb)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions": {"weight": 1}, "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And DB Operator verifies all waypoints status is "ROUTED"
    And DB Operator verifies all waypoints.route_id & seq_no is populated correctly

    And DB Operator verifies all route_monitoring_data records

  @routing-refactor @DeleteRouteGroups
  Scenario: Untag DP Order that is merged and not routed
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator tag "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order to "{dp-id}" DP
    And API Operator tag "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" order to "{dp-id}" DP
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | DELIVERY |
    And Operator get multiple "DELIVERY" transactions with status "PENDING"
    And API Core - Operator merge waypoints on Zonal Routing:
      | {KEY_LIST_OF_WAYPOINT_IDS[1]} |
      | {KEY_LIST_OF_WAYPOINT_IDS[2]} |
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
