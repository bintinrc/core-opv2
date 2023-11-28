@OperatorV2 @Core @RoutingID @AddOrderToRouteID @RoutingModulesID
Feature: Add Order To Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @routing-refactor @HighPriority
  Scenario: Add Delivery Routed Order to a New Route - New Route Date and Hub Same to Existing Route
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTE_ID[2]}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that success toast displayed:
      | top | Order {KEY_CREATED_ORDER_TRACKING_ID} added to route {KEY_CREATED_ROUTE_ID} |
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute @routing-refactor @MediumPriority
  Scenario: Not Allowed to Add Delivery Routed Order to a New Route - New Route Date same but different Hub to Existing Route
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                       |
      | bottom | ^.*Error Code: 103042.*Error Message: New route does not have the same route date and hub.* |
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute @routing-refactor @MediumPriority
  Scenario: Not Allowed to Add Delivery Routed Order to a New Route - New Route hub same but different Date to Existing Route
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Core - Operator create new route using data below:
      | createRouteRequest    | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
      | to_use_different_date | true                                                                                             |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                       |
      | bottom | ^.*Error Code: 103042.*Error Message: New route does not have the same route date and hub.* |
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute @routing-refactor @MediumPriority
  Scenario: Not Allowed to Add Delivery Routed Order to a New Route - New Route date and hub different to Existing Route
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Core - Operator create new route using data below:
      | createRouteRequest    | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
      | to_use_different_date | true                                                                                               |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                       |
      | bottom | ^.*Error Code: 103042.*Error Message: New route does not have the same route date and hub.* |
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id

    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute @routing-refactor @MediumPriority
  Scenario: Not Allowed to Add Delivery Routed Order to a New Route - Existing Route is Archived
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                       |
      | bottom | ^.*Error Code: 103088.*Error Message: Current route {KEY_LIST_OF_CREATED_ROUTE_ID[2]} has status ARCHIVED.* |
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute @routing-refactor @MediumPriority
  Scenario: Not Allowed to Add Delivery Routed Order to a New Route - New Route is Archived
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that error toast message contains following message:
      | message | routeID={KEY_LIST_OF_CREATED_ROUTE_ID[1]}][status=ARCHIVED]: cannot add waypoint if route not in [PENDING IN_PROGRESS] status |
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies route_monitoring_data record

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Add Merged Pickup Routed Order to a New Route - New Route Date and Hub Same to Existing Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo          | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PICKUP_A_BEFORE"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PICKUP_B_BEFORE"
    Then Operator verifies that "{KEY_PICKUP_A_BEFORE.waypointId}" equals "{KEY_PICKUP_B_BEFORE.waypointId}"
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[2].id}" route id on Add Order to Route page
    And Operator set "Pickup" transaction type on Add Order to Route page
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking id on Add Order to Route page
    Then Operator verifies that success toast displayed:
      | top | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} added to route {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verifies the last scanned tracking id is "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PICKUP_A_AFTER"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PICKUP_B_AFTER"
    Then Operator verifies that "{KEY_PICKUP_A_AFTER.waypointId}" does not equal "{KEY_PICKUP_A_BEFORE.waypointId}"
    Then Operator verifies that "{KEY_PICKUP_B_AFTER.waypointId}" equals "{KEY_PICKUP_B_BEFORE.waypointId}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify Pickup transaction on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id      | {KEY_PICKUP_B_AFTER.id}            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_PICKUP_B_AFTER.waypointId}    |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_PICKUP_B_AFTER.waypointId}    |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId           | {ninja-driver-id}                     |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And API Driver - Driver read routes:
      | driverId           | {ninja-driver-id}                     |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify Pickup transaction on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And DB Core - verify transactions record:
      | id      | {KEY_PICKUP_A_AFTER.id}            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And DB Core - verify waypoints record:
      | id      | {KEY_PICKUP_A_AFTER.waypointId}    |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | seqNo   | not null                           |
      | status  | Routed                             |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_PICKUP_A_AFTER.waypointId}    |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_PICKUP_A_AFTER.waypointId}    |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id} |

  @DeleteRoutes @HighPriority
  Scenario: Add Merged Delivery Routed Order to a New Route - New Route Date and Hub Same to Existing Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFrom        | INDEX-0                                                                                                                                                                                                                                                                                                                          |
      | generateTo          | INDEX-1                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DELIVERY_A_BEFORE"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DELIVERY_B_BEFORE"
    Then Operator verifies that "{KEY_DELIVERY_A_BEFORE.waypointId}" equals "{KEY_DELIVERY_B_BEFORE.waypointId}"
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[2].id}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking id on Add Order to Route page
    Then Operator verifies that success toast displayed:
      | top | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} added to route {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verifies the last scanned tracking id is "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DELIVERY_A_AFTER"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DELIVERY_B_AFTER"
    Then Operator verifies that "{KEY_DELIVERY_A_AFTER.waypointId}" does not equal "{KEY_DELIVERY_A_BEFORE.waypointId}"
    Then Operator verifies that "{KEY_DELIVERY_B_AFTER.waypointId}" equals "{KEY_DELIVERY_B_BEFORE.waypointId}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify Delivery transaction on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_DELIVERY_B_AFTER.id}          |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_DELIVERY_B_AFTER.waypointId}  |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_DELIVERY_B_AFTER.waypointId}  |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId           | {ninja-driver-id}                     |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And API Driver - Driver read routes:
      | driverId           | {ninja-driver-id}                     |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify Delivery transaction on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And DB Core - verify transactions record:
      | id      | {KEY_DELIVERY_A_AFTER.id}          |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And DB Core - verify waypoints record:
      | id      | {KEY_DELIVERY_A_AFTER.waypointId}  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | seqNo   | not null                           |
      | status  | Routed                             |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_DELIVERY_A_AFTER.waypointId}  |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_DELIVERY_A_AFTER.waypointId}  |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
