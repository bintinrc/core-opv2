@OperatorV2 @Core @Routing @RouteLogs @happy-path
Feature: Route Logs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Edit Details of a Single Route on Route Logs Page (uid:2a2ab038-88aa-45be-b2a4-f651da5023e7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator edits details of created route using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}        |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name}                             |
      | hub        | {hub-name}                              |
      | driverName | {ninja-driver-2-name}                   |
      | vehicle    | {vehicle-name}                          |
      | comments   | Route has been edited by automated test |
    Then Operator verify route details on Route Logs page using data below:
      | date           | {gradle-current-date-yyyy-MM-dd}        |
      | id             | {KEY_CREATED_ROUTE_ID}                  |
      | status         | PENDING                                 |
      | driverName     | {ninja-driver-2-name}                   |
      | hub            | {hub-name}                              |
      | zone           | {zone-name}                             |
      | driverTypeName | {driver-type-name-2}                    |
      | comments       | Route has been edited by automated test |
      | tags           | {route-tag-name}                        |

  @DeleteOrArchiveRoute
  Scenario: Operator Archive Multiple Routes from Route Logs Page (uid:161bdba2-5816-446e-988d-56889e3103c9)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator verify routes details on Route Logs page using data below:
      | id                                | status   |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | ARCHIVED |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | ARCHIVED |

  @DeleteOrArchiveRoute
  Scenario: Operator Merge Transactions of Multiple Routes from Route Logs Page (uid:647f207b-ca4b-4e6e-89d3-817f88d301a5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 4                                                                                                                                                                                                                                                                                                                                |
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                          |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator add multiple parcels to multiple routes using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator merge transactions of created routes
    Then Operator verifies that info toast displayed:
      | top    | Transactions within 2 Routes Merged                                        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]}, {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Create a Single Route from Route Logs Page (uid:31070e4b-b30d-4323-8ea0-96be44488282)
    Given Operator go to menu Routing -> Route Logs
    When Operator create new route using data below:
      | date       | {gradle-current-date-yyyy-MM-dd} |
      | tags       | {route-tag-name}                 |
      | zone       | {zone-name}                      |
      | hub        | {hub-name}                       |
      | driverName | {ninja-driver-name}              |
      | vehicle    | {vehicle-name}                   |
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    Then Operator verify route details on Route Logs page using data below:
      | date           | {gradle-current-date-yyyy-MM-dd} |
      | id             | {KEY_CREATED_ROUTE_ID}           |
      | driverName     | {ninja-driver-name}              |
      | hub            | {hub-name}                       |
      | zone           | {zone-name}                      |
      | driverTypeName | {default-driver-type-name}       |
      | comments       | {KEY_CREATED_ROUTE.comments}     |
      | tags           | {route-tag-name}                 |
    And DB Operator verifies created dummy waypoints

  @DeleteOrArchiveRoute
  Scenario: Operator Unarchive Multiple Archived Routes from Route Logs Page (uid:613d5782-5aa0-4519-ac39-50a59ca0a208)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator archives routes:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator unarchive routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verify routes details on Route Logs page using data below:
      | id                                | status      |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | IN_PROGRESS |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | IN_PROGRESS |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op