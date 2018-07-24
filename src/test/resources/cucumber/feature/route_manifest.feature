@OperatorV2 @OperatorV2Part2 @RouteManifest @Saas
Feature: Route Manifest

  @LaunchBrowser @EnableClearCache @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteViaDb
  Scenario: Operator is able to load routes manifest and verify 1 delivery is success (uid:de99c52c-060c-4951-906f-a489754abafc)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    Given Operator go to menu Routing -> Route Monitoring
    When Operator filter Route Monitoring using data below and then load selection:
      | routeDate | {gradle-current-date-yyyy-MM-dd} |
      | routeTags | [{route-tag-name}]               |
      | hubs      | [{hub-name}]                     |
    Then Operator verify the created route is exist and has correct info
    Then Operator verify 1 delivery success at Route Manifest

  @ArchiveRouteViaDb
  Scenario: Operator is able to load routes manifest and verify 1 delivery is failed (uid:0139c8ab-cd38-4389-b0e0-0546504cd5a1)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator get order details
    Given Operator go to menu Routing -> Route Monitoring
    When Operator filter Route Monitoring using data below and then load selection:
      | routeDate | {gradle-current-date-yyyy-MM-dd} |
      | routeTags | [{route-tag-name}]               |
      | hubs      | [{hub-name}]                     |
    Then Operator verify the created route is exist and has correct info
    Then Operator verify 1 delivery fail at Route Manifest

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
