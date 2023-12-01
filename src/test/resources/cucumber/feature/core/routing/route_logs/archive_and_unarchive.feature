@OperatorV2 @Core @Routing @RouteLogs @ArchiveAndUnarchive
Feature: Route Logs - Archive & Unarchive

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @happy-path @HighPriority
  Scenario: Operator Archive Multiple Routes from Route Logs Page
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator archive routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verifies that success react notification displayed:
      | top                | 2 Route(s) Archived |
      | waitUntilInvisible | true                |
    Then Operator verify routes details on Route Logs page using data below:
      | id                                 | status   |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | ARCHIVED |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} | ARCHIVED |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Unarchive Single Archived Route from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
      | archiveRoutes | show       |
    When Operator unarchive routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 Route(s) Unarchived                    |
      | bottom             | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | waitUntilInvisible | true                                     |
    And Operator verify routes details on Route Logs page using data below:
      | id                                 | status      |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | IN_PROGRESS |

  @ArchiveRouteCommonV2 @happy-path @HighPriority
  Scenario: Operator Unarchive Multiple Archived Routes from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
      | archiveRoutes | show       |
    When Operator unarchive routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verifies that success react notification displayed:
      | top                | 2 Route(s) Unarchived                                                       |
      | bottom             | Route {KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | waitUntilInvisible | true                                                                        |
    Then Operator verify routes details on Route Logs page using data below:
      | id                                 | status      |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | IN_PROGRESS |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} | IN_PROGRESS |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Unarchive Single NON-archived Route from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator select "Unarchive selected" for given routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verify "Unarchive" process data in Selection Error dialog on Route Logs page:
      | routeId                            | reason                   |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Invalid status to change |
    When Operator clicks 'Continue' button in Selection Error dialog on Route Logs page
    Then Operator verifies that error react notification displayed:
      | top    | Unable to apply actions |
      | bottom | No valid selection      |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Unarchive Multiple NON-Archived Routes from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator select "Unarchive selected" for given routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verify "Unarchive" process data in Selection Error dialog on Route Logs page:
      | routeId                            | reason                   |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Invalid status to change |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} | Invalid status to change |
    When Operator clicks 'Continue' button in Selection Error dialog on Route Logs page
    Then Operator verifies that error react notification displayed:
      | top    | Unable to apply actions |
      | bottom | No valid selection      |
