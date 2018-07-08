@OperatorV2Disabled @RouteInbound @Saas
Feature: Route Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRoute
  Scenario Outline: Operator get route details by Route ID/Tracking ID/Driver (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
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
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}     |
      | fetchBy      | <fetchBy>      |
      | fetchByValue | <fetchByValue> |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    Examples:
      | Note                 | hiptest-uid                              | fetchBy              | fetchByValue           |
      | FETCH_BY_ROUTE_ID    | uid:78b7f331-22b8-4ba4-926b-48fee23ca396 | FETCH_BY_ROUTE_ID    | GET_FROM_CREATED_ROUTE |
      | FETCH_BY_TRACKING_ID | uid:1254810b-984b-41e0-826d-de3a0a70efec | FETCH_BY_TRACKING_ID | GET_FROM_CREATED_ROUTE |
      | FETCH_BY_DRIVER      | uid:d8922f44-3b18-4243-84ce-fd2f13adb663 | FETCH_BY_DRIVER      | {ninja-driver-name}    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
