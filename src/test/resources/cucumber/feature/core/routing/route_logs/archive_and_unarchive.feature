@OperatorV2 @Core @Routing @RouteLogs @ArchiveAndUnarchive
Feature: Route Logs - Archive & Unarchive

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @happy-path @HighPriority
  Scenario: Operator Archive Multiple Routes from Route Logs Page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator archive routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verifies that success react notification displayed:
      | top                | 2 Route(s) Archived |
      | waitUntilInvisible | true                |
    Then Operator verify routes details on Route Logs page using data below:
      | id                                | status   |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | ARCHIVED |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | ARCHIVED |

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Operator Unarchive Single Archived Route from Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
      | archiveRoutes | show       |
    When Operator unarchive routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 Route(s) Unarchived                   |
      | bottom             | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | waitUntilInvisible | true                                    |
    And Operator verify routes details on Route Logs page using data below:
      | id                                | status      |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | IN_PROGRESS |

  @DeleteOrArchiveRoute @happy-path @HighPriority
  Scenario: Operator Unarchive Multiple Archived Routes from Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
      | archiveRoutes | show       |
    When Operator unarchive routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verifies that success react notification displayed:
      | top                | 2 Route(s) Unarchived                                                     |
      | bottom             | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]},{KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
      | waitUntilInvisible | true                                                                      |
    Then Operator verify routes details on Route Logs page using data below:
      | id                                | status      |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | IN_PROGRESS |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | IN_PROGRESS |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario: Operator Unarchive Single NON-archived Route from Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator select "Unarchive selected" for given routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    Then Operator verify "Unarchive" process data in Selection Error dialog on Route Logs page:
      | routeId                           | reason                   |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | Invalid status to change |
    When Operator clicks 'Continue' button in Selection Error dialog on Route Logs page
    Then Operator verifies that error react notification displayed:
      | top    | Unable to apply actions |
      | bottom | No valid selection      |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario: Operator Unarchive Multiple NON-Archived Routes from Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator select "Unarchive selected" for given routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verify "Unarchive" process data in Selection Error dialog on Route Logs page:
      | routeId                           | reason                   |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | Invalid status to change |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | Invalid status to change |
    When Operator clicks 'Continue' button in Selection Error dialog on Route Logs page
    Then Operator verifies that error react notification displayed:
      | top    | Unable to apply actions |
      | bottom | No valid selection      |
