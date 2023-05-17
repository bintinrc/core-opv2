@OperatorV2 @Core @Routing @RouteLogs @EditRouteDetails
Feature: Route Logs - Edit Route Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Do Not Allow to Edit Details of a Single Route When Status is Archived
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator archives routes:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    Then Operator verify Edit Details button is disabled on Route Logs page

  @DeleteOrArchiveRoute
  Scenario: Do Not Allow to Bulk Edit Multiple Routes Details When Status is Archived
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator archives routes:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
      | archiveRoutes | true                             |
    And Operator bulk edits details of created routes using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}        |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name-2}                           |
      | hub        | {hub-name-2}                            |
      | driverName | {ninja-driver-2-name}                   |
      | comments   | Route has been edited by automated test |
    Then Operator verifies errors in Bulk Edit Details dialog on Route Logs page:
      | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} is already archived ! |
      | Route {KEY_LIST_OF_CREATED_ROUTE_ID[2]} is already archived ! |
    And Operator click Cancel in Bulk Edit Details dialog on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top | 0 Route(s) Updated |
    Then Operator verify routes details on Route Logs page using data below:
      | date                             | id                                | driverName          | zone        | hub        |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {ninja-driver-name} | {zone-name} | {hub-name} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {ninja-driver-name} | {zone-name} | {hub-name} |

  @DeleteOrArchiveRoute
  Scenario: Partial Edit Multiple Routes Details from Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
    And Operator archive routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator bulk edits details of created routes using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}        |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name-2}                           |
      | hub        | {hub-name-2}                            |
      | driverName | {ninja-driver-2-name}                   |
      | comments   | Route has been edited by automated test |
    Then Operator verifies errors in Bulk Edit Details dialog on Route Logs page:
      | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} is already archived ! |
    And Operator click Cancel in Bulk Edit Details dialog on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top | 1 Route(s) Updated |
    Then Operator verify routes details on Route Logs page using data below:
      | date                             | id                                | driverName            | zone          | hub          |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {ninja-driver-name}   | {zone-name}   | {hub-name}   |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {ninja-driver-2-name} | {zone-name-2} | {hub-name-2} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op