@OperatorV2 @Core @RoutingID @AddOrderToRouteID @RoutingModulesID
Feature: Add Order To Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @routing-refactor
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
      | top | Order {KEY_CREATED_ORDER.requestedTrackingId} added to route {KEY_CREATED_ROUTE_ID} |
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

  @DeleteOrArchiveRoute @routing-refactor
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

  @DeleteOrArchiveRoute @routing-refactor
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

  @DeleteOrArchiveRoute @routing-refactor
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

#  @DeleteOrArchiveRoute @routing-refactor
#  Scenario: Not Allowed to Add Pickup Routed Order to a New Route - New Route Date and Hub Same to Existing Route
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
#      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator get order details
#    And API Core - Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    And API Core - Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Given API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"PP" } |
#    When Operator go to menu Routing -> Add Order to Route
#    And Operator set "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" route id on Add Order to Route page
#    And Operator set "Pickup" transaction type on Add Order to Route page
#    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
#    Then Operator verifies that error toast displayed:
#      | top    | Network Request Error                                                                       |
#      | bottom | ^.*Error Code: 103042.*Error Message: New route does not have the same route date and hub.* |
#    Then Operator verifies that "New route does not have the same route date and hub" error toast message is displayed
#    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
#    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify order event on Edit Order V2 page using data below:
#      | name    | ADD TO ROUTE                      |
#      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
#    And Operator verify Delivery transaction on Edit Order V2 page using data below:
#      | status  | PENDING                           |
#      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
#    And DB Operator verify Delivery waypoint of the created order using data below:
#      | status | ROUTED |
#    And DB Operator verifies transaction routed to new route id
#    And DB Operator verifies waypoint status is "ROUTED"
#    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
#    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute @routing-refactor
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

  @DeleteOrArchiveRoute @routing-refactor
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
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                   |
      | bottom | ^.*Error Code: 103088.*Error Message: Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} has the status ARCHIVED.* |
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

  @DeleteOrArchiveRoute @routing-refactor @wip
  Scenario: Not Allowed to Add Delivery Routed Order to a New Route - Hub Id is not Whitelisted
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator waits for 20 seconds
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                   |
      | bottom | ^.*Error Code: 103024.*Error Message: Delivery is already routed to {KEY_LIST_OF_CREATED_ROUTE_ID[2]}.* |
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

  @DeleteRoutes
  Scenario: Add Merged Pickup Routed Order to a New Route - New Route Date and Hub Same to Existing Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo          | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
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
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route id on Add Order to Route page
    And Operator set "Pickup" transaction type on Add Order to Route page
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" tracking id on Add Order to Route page
    Then Operator verifies that success toast displayed:
      | top | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} added to route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verifies the last scanned tracking id is "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | latestRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | latestRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId           | {ninja-driver-id}                                                           |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                          |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
