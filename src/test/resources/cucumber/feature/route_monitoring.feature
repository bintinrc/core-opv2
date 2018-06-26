@OperatorV2 @RouteMonitoring
Feature: Route Monitoring

  @LaunchBrowser @ShouldAlwaysRun @EnableClearCache
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteViaDb
  Scenario: Operator is able to load routes according to filters (uid:bff81d2d-1c2a-4da6-a0e7-469a6882cd4a)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    #Note: Tag ZZZ = 250
    Given API Operator set tags of the new created route to [250]
    Given Operator go to menu Routing -> Route Monitoring
    When Operator filter Route Monitoring using data below and then load selection:
      | routeDate | {current-date-yyyy-MM-dd} |
      | routeTags | [ZZZ]                     |
      | hubs      | [30JKB]                   |
    Then Operator verify the created route is exist and has correct info

  @ArchiveRouteViaDb
  Scenario: Operator verify the route is contains 1 Total Wp, 0% Complete, 1 Pending, 0 Success, 0 Valid Failed, 0 Invalid Failed (uid:d7ef288f-e914-4d98-8325-32225e2c6a35)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
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
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Monitoring
    When Operator click on 'Load Selection' Button on Route Monitoring Page
    Then Operator verify the created route monitoring params:
      | totalWaypoint        | 1 |
      | completionPercentage | 0 |
      | pendingCount         | 1 |
      | successCount         | 0 |
      | failedCount          | 0 |
      | cmiCount             | 0 |

  @ArchiveRouteViaDb
  Scenario: Operator verify the route is contains 1 Total Wp, 100% Complete, 0 Pending, 1 Success, 0 Valid Failed, 0 Invalid Failed (uid:e7a88ac5-2019-4396-bf6f-041e3dad71be)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
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
    Given Operator go to menu Routing -> Route Monitoring
    When Operator click on 'Load Selection' Button on Route Monitoring Page
    Then Operator verify the created route monitoring params:
      | totalWaypoint        | 1   |
      | completionPercentage | 100 |
      | pendingCount         | 0   |
      | successCount         | 1   |
      | failedCount          | 0   |
      | cmiCount             | 0   |

  @ArchiveRouteViaDb
  Scenario: Operator verify the route is contains 1 Total Wp, 100% Complete, 0 Pending, 0 Success, 1 Valid Failed, 0 Invalid Failed (uid:8c18582a-b2d9-49fb-b785-292db5093b0f)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
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
    And API Driver failed the delivery of the created parcel
    When Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Routing -> Route Monitoring
    And Operator click on 'Load Selection' Button on Route Monitoring Page
    Then Operator verify the created route monitoring params:
      | totalWaypoint        | 1   |
      | completionPercentage | 100 |
      | pendingCount         | 0   |
      | successCount         | 0   |
      | failedCount          | 1   |
      | cmiCount             | 0   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
