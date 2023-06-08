@OperatorV2 @Core @AllOrders @RoutingModules @RoutingModulesAllOrders
Feature: All Orders - Add To Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Add Parcel to Route Using Tag Filter on All Orders Page (uid:a5f2f56b-2484-4401-bb65-f713c85e6017)
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
    When Operator add multiple orders to route on All Orders page:
      | trackingIds | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]},{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
      | tag         | {KEY_CREATED_ROUTE_TAG.name}                                                          |
    Then Operator verifies that info toast displayed:
      | top    | 2 order(s) updated |
      | bottom | add to route       |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE           |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[3]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE           |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |

  @DeleteOrArchiveRoute @routing-refactor @happy-path
  Scenario: Operator Add Multiple Orders to Route on All Orders Page (uid:1e20a4ff-0254-47c8-8453-948097da2946)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator get order details
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator add multiple orders to route on All Orders page:
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verifies that info toast displayed:
      | top    | 3 order(s) updated |
      | bottom | add to route       |
    And API Operator verify multiple delivery orders is added to route
    When Operator get multiple "Delivery" transactions with status "Pending"
    And DB Operator verifies all transactions routed to new route id
    And DB Operator verifies all waypoints status is "ROUTED"
    And DB Operator verifies all waypoints.route_id & seq_no is populated correctly

    And DB Operator verifies all route_monitoring_data records

    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    Then Verify that waypoints are shown on driver "{ninja-driver-id}" list route correctly

  @DeleteOrArchiveRoute
  Scenario: Operator Add Partial Multiple Orders to Route on All Orders Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator add multiple orders to route on All Orders page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} \| Delivery is already routed to {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator close Errors dialog on All Orders page
    Then Operator verifies that warning toast displayed:
      | top    | 1 order(s) failed to update |
      | bottom | Add To Route                |
    And Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | Add To Route       |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                           |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    When API Operator get order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute
  Scenario: Block Add to Route for Cancelled Order on All Orders Page
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    And API Operator cancel created order
    When Operator add multiple orders to route on All Orders page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} \| Order is Cancelled and cannot be added to route |
    When Operator close Errors dialog on All Orders page
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | add to route       |

  @DeleteOrArchiveRoute
  Scenario: Block Add to Route for On Hold Order on All Orders Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Recovery - Create ticket for tracking id: "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    And Operator add multiple orders to route on All Orders page:
      | trackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]},{KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} \| Order is On Hold and cannot be added to route |
    When Operator close Errors dialog on All Orders page
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | add to route       |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op