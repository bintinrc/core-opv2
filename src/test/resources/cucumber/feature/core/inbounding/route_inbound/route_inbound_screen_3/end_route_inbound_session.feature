@OperatorV2 @Core @Inbounding @RouteInbound @EndRouteInboundSession
Feature: End Route Inbound Session

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario Outline: End a Route Inbound Session : Incomplete Scans (uid:f288852c-7a4a-4d5e-8267-a83778233ad0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cashOnDelivery>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver deliver the created parcel successfully
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify 'Money to collect' value is "<cashOnDelivery>" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    Then Operator verify 'Expected Total' value is "<cashOnDelivery>" on Money Collection dialog
    And Operator verify 'Outstanding amount' value is "<cashOnDelivery>" on Money Collection dialog
    When Operator submit following values on Money Collection dialog:
      | cashCollected | <cashCollected> |
    Then Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_CREATED_ROUTE_ID}" on Route Inbound page
    Examples:
      | cashCollected | cashOnDelivery |
      | 23.57         | 23.57          |

  @DeleteOrArchiveRoute @happy-path
  Scenario Outline: End a Route Inbound Session : Completed Scans (uid:9c6ea453-4162-4571-80f7-333381c202a9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cashOnDelivery>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver deliver the created parcel successfully
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                      |
      | fetchBy      | FETCH_BY_TRACKING_ID            |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify Waypoint Scans record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | reason     | Order completed                            |
    Then Operator verify 'Money to collect' value is "<cashOnDelivery>" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    Then Operator verify 'Expected Total' value is "<cashOnDelivery>" on Money Collection dialog
    And Operator verify 'Outstanding amount' value is "<cashOnDelivery>" on Money Collection dialog
    When Operator submit following values on Money Collection dialog:
      | cashCollected | <cashCollected> |
    Then Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_CREATED_ROUTE_ID}" on Route Inbound page
    Examples:
      | cashCollected | cashOnDelivery |
      | 23.57         | 23.57          |
