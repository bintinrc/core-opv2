@OperatorV2 @RouteLogs
Feature: Route Logs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveAndDeleteRouteViaDb
  Scenario: Operator create new route from page Route Logs (uid:fe58af45-de7f-4dff-aced-8bf7521666e3)
    Given Operator go to menu Routing -> Route Logs
    When Operator create new route using data below:
      | routeDate       | {current-date-yyyy-MM-dd} |
      | routeTags       | [FLT]                     |
      | zoneName        | {zone-name}               |
      | hubName         | {hub-name}                |
      | ninjaDriverName | {ninja-driver-name}       |
      | vehicleName     | {vehicle-name}            |
    Then Operator verify the new route is created successfully

  @ArchiveAndDeleteRouteViaDb
  Scenario: Operator create multiple route from page Route Logs
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                         |
      | routeDate       | {current-date-yyyy-MM-dd} |
      | routeTags       | [FLT]                     |
      | zoneName        | {zone-name}               |
      | hubName         | {hub-name}                |
      | ninjaDriverName | {ninja-driver-name}       |
      | vehicleName     | {vehicle-name}            |
    Then Operator verify multiple routes is created successfully

  @ArchiveRouteViaDb
  Scenario: Operator 'Edit Details' on Operator V2 - Route Logs menu (uid:d735938c-f87e-47c1-9a6a-61d31850e0cb)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator select route date filter and click 'Load Selection'
    When Operator click 'Edit Details'
    When Operator edit 'Assigned Driver' to driver 'OpV2 No.2' and edit 'Comments'
    Then Operator verify route's driver must be changed to 'OpV2 No.2' in table list

  @ArchiveRouteViaDb
  Scenario: Operator 'Add New Tag' on Operator V2 - Route Logs menu (uid:24ef3b76-c582-42da-b6d8-cf867aeec8e9)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator select route date filter and click 'Load Selection'
    When Operator add tag 'CDS'
    Then Operator verify route's tag must contain 'CDS'

  @ArchiveRouteViaDb
  Scenario: Operator 'Delete Route' on Operator V2 - Route Logs menu (uid:ff70c3c0-73bc-4cde-9ce7-c340769560cb)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator select route date filter and click 'Load Selection'
    When Operator delete route on Operator V2
    Then Operator verify route must be deleted successfully

  @ArchiveRouteViaDb
  Scenario: Operator 'Edit Route' on Operator V2 - Route Logs menu (uid:0ea01bbb-0651-4186-84b4-0b3f4a522d3e)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator select route date filter and click 'Load Selection'
#    When Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route(s) Only'
#    Then Operator redirect to this page 'https://operator-qa.ninjavan.co/sg/ng#/zonal_routing_edit?fetch_unrouted_waypoints=false&to_cluster=true&id={{route_id}}'
#    Then Operator close Edit Routes dialog

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
