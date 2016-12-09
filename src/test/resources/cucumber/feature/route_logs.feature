@RouteLogs @selenium
Feature: Route Groups

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveRoute
  Scenario: Operator 'Edit Details' on Operator V2 - Route Logs menu
    Given Operator V1 create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"(Edit Details) This route is created for testing 'Operator V2 - Routing - Route Logs' menu. Ignore this route. Created at {{created_date}}."} |
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Route Logs in Routing
    Then take screenshot with delay 1s
    When op select route date filter and click 'Load Selection'
    Then take screenshot with delay 1s
    When op click 'Edit Details'
    Then take screenshot with delay 1s
    When op edit 'Assigned Driver' to driver 'OpV2 No.2' and edit 'Comments'
    Then take screenshot with delay 1s
    Then route's driver must be changed to 'OpV2 No.2' in table list
    Then take screenshot with delay 1s

  @ArchiveRoute
  Scenario: Operator 'Add New Tag' on Operator V2 - Route Logs menu
    Given Operator V1 create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"(Add New Tag) This route is created for testing 'Operator V2 - Routing - Route Logs' menu. Ignore this route. Created at {{created_date}}."} |
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Route Logs in Routing
    When op select route date filter and click 'Load Selection'
    When op add tag 'CDS'
    Then route's tag must contain 'CDS'

  @ArchiveRoute
  Scenario: Operator 'Delete Route' on Operator V2 - Route Logs menu
    Given Operator V1 create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"(Delete Route) This route is created for testing 'Operator V2 - Routing - Route Logs' menu. Ignore this route. Created at {{created_date}}."} |
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Route Logs in Routing
    When op select route date filter and click 'Load Selection'
    When op delete route on Operator V2
    Then route must be deleted successfully

    @ArchiveRoute
  Scenario: Operator 'Edit Route' on Operator V2 - Route Logs menu
    Given Operator V1 create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"(Edit Route) This route is created for testing 'Operator V2 - Routing - Route Logs' menu. Ignore this route. Created at {{created_date}}."} |
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Route Logs in Routing
    When op select route date filter and click 'Load Selection'
    When op click 'Edit Route' and then click 'Load Waypoints of Selected Route(s) Only'
    Then op redirect to this page 'https://operator-qa.ninjavan.co/sg/ng#/zonal_routing_edit?fetch_unrouted_waypoints=false&to_cluster=true&id={{route_id}}'
    Then op close Edit Routes dialog

  @KillBrowser
  Scenario: Kill Browser
