@OperatorV2 @Core @Routing @RouteLogs @RouteLogsPart1
Feature: Route Logs

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path @HighPriority
  Scenario: Operator Create a Single Route from Route Logs Page
    Given Operator go to menu Routing -> Route Logs
    When Operator create new route using data below:
      | date       | {date: 0 days next, yyyy-MM-dd} |
      | tags       | {route-tag-name}                |
      | zone       | {zone-name}                     |
      | hub        | {hub-name}                      |
      | driverName | {ninja-driver-name}             |
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    Then Operator verify route details on Route Logs page using data below:
      | date           | {date: 0 days next, yyyy-MM-dd}          |
      | id             | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
      | driverName     | {ninja-driver-name}                      |
      | hub            | {hub-name}                               |
      | zone           | {zone-name}                              |
      | driverTypeName | {default-driver-type-name}               |
      | comments       | {KEY_LIST_OF_CREATED_ROUTES[1].comments} |
      | tags           | {route-tag-name}                         |

  @HighPriority
  Scenario: Operator Create Multiple Routes by Duplicate Current Route on Route Logs Page
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute | 2                               |
      | date          | {date: 0 days next, yyyy-MM-dd} |
      | tags          | {route-tag-name}                |
      | zone          | {zone-name}                     |
      | hub           | {hub-name}                      |
      | driverName    | {ninja-driver-name}             |
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    Then Operator verify routes details on Route Logs page using data below:
      | date                            | id                                 | driverName          | hub        | zone        | driverTypeName             | comments                                 | tags             |
      | {date: 0 days next, yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-name} | {hub-name} | {zone-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[1].comments} | {route-tag-name} |
      | {date: 0 days next, yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {ninja-driver-name} | {hub-name} | {zone-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[2].comments} | {route-tag-name} |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Bulk Edit Multiple Routes Details from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator bulk edits details of created routes using data below:
      | date       | {date: 0 days next, yyyy-MM-dd}         |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name-2}                           |
      | hub        | {hub-name-2}                            |
      | driverName | {ninja-driver-2-name}                   |
      | comments   | Route has been edited by automated test |
    Then Operator verifies that success react notification displayed:
      | top                | 2 Route(s) Updated |
      | waitUntilInvisible | true               |
    Then Operator verify routes details on Route Logs page using data below:
      | date                            | id                                 | driverName            | zone          | hub          | comments                                | tags             |
      | {date: 0 days next, yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-2-name} | {zone-name-2} | {hub-name-2} | Route has been edited by automated test | {route-tag-name} |
      | {date: 0 days next, yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {ninja-driver-2-name} | {zone-name-2} | {hub-name-2} | Route has been edited by automated test | {route-tag-name} |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Optimise Multiple Routes from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                               |
      | numberOfOrder       | 4                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id-2}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[2].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[4].id} |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY    |
      | routeDateTo   | TODAY        |
      | hubName       | {hub-name-2} |
    And Operator optimise created routes
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verifies created routes are optimised successfully
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Print Passwords of Multiple Routes from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator save data of created routes on Route Logs page
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator print passwords of created routes
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verifies that success react notification displayed:
      | top | Downloaded file routes_password.pdf... |
    Then Operator verify printed passwords of selected routes info is correct

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Print Multiple Routes Details With Empty Waypoints from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator print created routes:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that success react notification displayed:
      | top | Downloaded file route_printout.pdf... |
    And Operator verifies created routes are printed successfully

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Delete Multiple Routes from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator delete routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verifies that success react notification displayed:
      | top    | 2 route(s) deleted                                                           |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id}, {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verify routes are deleted successfully:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |

  @ArchiveRouteCommonV2 @happy-path @HighPriority
  Scenario: Operator Edit Details of a Single Route on Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator edits details of created route using data below:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}      |
      | date       | {date: 0 days next, yyyy-MM-dd}         |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name-2}                           |
      | hub        | {hub-name-2}                            |
      | driverName | {ninja-driver-2-name}                   |
      | comments   | Route has been edited by automated test |
    Then Operator verifies that success react notification displayed:
      | top | 1 Route(s) Updated |
    Then Operator verify route details on Route Logs page using data below:
      | date       | {date: 0 days next, yyyy-MM-dd}         |
      | id         | {KEY_LIST_OF_CREATED_ROUTES[1].id}      |
      | status     | PENDING                                 |
      | driverName | {ninja-driver-2-name}                   |
      | hub        | {hub-name-2}                            |
      | zone       | {zone-name-2}                           |
      | comments   | Route has been edited by automated test |
      | tags       | {route-tag-name}                        |
