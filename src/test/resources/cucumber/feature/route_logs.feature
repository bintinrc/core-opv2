@OperatorV2 @RouteLogs
Feature: Route Logs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveRouteViaDb
  Scenario: Operator 'Edit Details' on Operator V2 - Route Logs menu (uid:d735938c-f87e-47c1-9a6a-61d31850e0cb)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When op select route date filter and click 'Load Selection'
    When op click 'Edit Details'
    When op edit 'Assigned Driver' to driver 'OpV2 No.2' and edit 'Comments'
    Then route's driver must be changed to 'OpV2 No.2' in table list

  @ArchiveRouteViaDb
  Scenario: Operator 'Add New Tag' on Operator V2 - Route Logs menu (uid:24ef3b76-c582-42da-b6d8-cf867aeec8e9)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When op select route date filter and click 'Load Selection'
    When op add tag 'CDS'
    Then route's tag must contain 'CDS'

  @ArchiveRouteViaDb
  Scenario: Operator 'Delete Route' on Operator V2 - Route Logs menu (uid:ff70c3c0-73bc-4cde-9ce7-c340769560cb)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When op select route date filter and click 'Load Selection'
    When op delete route on Operator V2
    Then route must be deleted successfully

  @ArchiveRouteViaDb
  Scenario: Operator 'Edit Route' on Operator V2 - Route Logs menu (uid:0ea01bbb-0651-4186-84b4-0b3f4a522d3e)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When op select route date filter and click 'Load Selection'
#    When op click 'Edit Route' and then click 'Load Waypoints of Selected Route(s) Only'
#    Then op redirect to this page 'https://operator-qa.ninjavan.co/sg/ng#/zonal_routing_edit?fetch_unrouted_waypoints=false&to_cluster=true&id={{route_id}}'
#    Then op close Edit Routes dialog

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
