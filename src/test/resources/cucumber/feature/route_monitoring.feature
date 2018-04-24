@OperatorV2 @RouteMonitoring
Feature: Route Monitoring

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteViaDb
  Scenario: Operator is able to load routes according to filters (uid:bff81d2d-1c2a-4da6-a0e7-469a6882cd4a)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    #Note: Tag ZZZ = 250
    Given Operator set tags of the new created route to [250]
    Given Operator go to menu Routing -> Route Monitoring
    When Operator filter Route Monitoring using data below and then load selection:
      | routeDate | {current-date-yyyy-MM-dd} |
      | routeTags | [ZZZ]                     |
      | hubs      | [30JKB]                   |
    Then Operator verify the created route is exist and has correct info

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
