@OperatorV2 @Core @Routing @RoutingJob1 @RouteLogs
Feature: Route Logs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Create a Single Route from Route Logs Page (uid:76362592-6316-4521-a835-dbe10a1b2f12)
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
  Scenario: Operator Create Multiple Routes by Duplicate Current Route on Route Logs Page (uid:82caf88b-3814-4768-ac98-8cc063346b1b)
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute | 2                                |
      | date          | {gradle-current-date-yyyy-MM-dd} |
      | tags          | {route-tag-name}                 |
      | zone          | {zone-name}                      |
      | hub           | {hub-name}                       |
      | driverName    | {ninja-driver-name}              |
      | vehicle       | {vehicle-name}                   |
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    Then Operator verify routes details on Route Logs page using data below:
      | date                             | id                                | driverName          | hub        | zone        | driverTypeName             | comments                                 | tags             |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {ninja-driver-name} | {hub-name} | {zone-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[1].comments} | {route-tag-name} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {ninja-driver-name} | {hub-name} | {zone-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[2].comments} | {route-tag-name} |

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Edit Multiple Routes Details from Route Logs Page (uid:037e90a7-f324-4ce2-9cff-ff198ac9365b)
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
    And Operator bulk edits details of created routes using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}        |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name}                             |
      | hub        | {hub-name}                              |
      | driverName | {ninja-driver-2-name}                   |
      | vehicle    | {vehicle-name}                          |
      | comments   | Route has been edited by automated test |
    Then Operator verifies that success react notification displayed:
      | top                | 2 Route(s) Updated |
      | waitUntilInvisible | true               |
    Then Operator verify routes details on Route Logs page using data below:
      | date                             | id                                | driverName            | hub        | driverTypeName       | comments                                | tags             |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {ninja-driver-2-name} | {hub-name} | {driver-type-name-2} | Route has been edited by automated test | {route-tag-name} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {ninja-driver-2-name} | {hub-name} | {driver-type-name-2} | Route has been edited by automated test | {route-tag-name} |

  @DeleteOrArchiveRoute
  Scenario: Operator Optimise Multiple Routes from Route Logs Page (uid:03e47864-aa13-4dc3-8775-27f07257320b)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 4                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add multiple parcels to multiple routes using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator optimise created routes
    Then Operator verifies created routes are optimised successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Print Passwords of Multiple Routes from Route Logs Page (uid:25552c52-3a03-4110-8b33-628b65785b37)
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
    And Operator save data of created routes on Route Logs page
    And Operator print passwords of created routes
    Then Operator verifies that success react notification displayed:
      | top | Downloaded file routes_password.pdf... |
    Then Operator verify printed passwords of selected routes info is correct

  @DeleteOrArchiveRoute
  Scenario: Operator Print Multiple Routes Details from Route Logs Page (uid:1a53a8cd-1499-4135-9171-5435bf397469)
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
    And Operator print created routes
    Then Operator verifies that success react notification displayed:
      | top | Downloaded file route_printout.pdf... |
    And Operator verifies created routes are printed successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Delete Multiple Routes from Route Logs Page (uid:8839e88d-7873-4bb8-8143-8de7de657624)
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
    When Operator delete routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verifies that success react notification displayed:
      | top                | 2 Route(s) Deleted |
      | waitUntilInvisible | true               |
    Then Operator verify routes are deleted successfully:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Edit Details of a Single Route on Route Logs Page (uid:5aa174fa-7978-490f-8a45-a1c2c2a764dc)
    Given Operator go to menu Utilities -> QRCode Printing
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
      | hub        | {hub-name-2}                            |
      | driverName | {ninja-driver-2-name}                   |
      | comments   | Route has been edited by automated test |
    Then Operator verifies that success react notification displayed:
      | top                | 1 Route(s) Updated |
      | waitUntilInvisible | true               |
    Then Operator verify route details on Route Logs page using data below:
      | date           | {gradle-current-date-yyyy-MM-dd}        |
      | id             | {KEY_CREATED_ROUTE_ID}                  |
      | status         | PENDING                                 |
      | driverName     | {ninja-driver-2-name}                   |
      | hub            | {hub-name-2}                            |
      | zone           | {zone-name}                             |
      | driverTypeName | {driver-type-name-2}                    |
      | comments       | Route has been edited by automated test |
      | tags           | {route-tag-name}                        |

  @DeleteOrArchiveRoute
  Scenario: Operator Add Tag to a Single Route on Route Logs Page (uid:47e4dfc2-b5e3-470a-a832-b99c85905f8a)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator adds tag "{route-tag-name}" to created route
    Then Operator verifies that success react notification displayed:
      | top                | 1 Route(s) Tagged |
      | waitUntilInvisible | true              |
    Then Operator verify route details on Route Logs page using data below:
      | id   | {KEY_CREATED_ROUTE_ID} |
      | tags | {route-tag-name}       |

  @DeleteOrArchiveRoute
  Scenario: Operator Delete a Single Route on Route Logs Page (uid:9d2ef35c-fceb-466b-ab93-13cd9d98807b)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator deletes created route on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top                | 1 Route(s) Deleted |
      | waitUntilInvisible | true               |
    And Operator verify routes are deleted successfully:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Redirected to Edit Route Page from Route Logs - Load Waypoints of Selected Route(s) only (uid:f07cd3bd-e0a4-4117-a92f-e4005e3d5c6a)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route(s) Only'
    Then Operator is redirected to this page "/sg/zonal-routing/edit?cluster=true&ids={KEY_CREATED_ROUTE_ID}&unrouted=false"

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Route by Route Id on Route Logs Page (uid:273b5063-c85e-47a1-bada-f50d3f755541)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    Then Operator verify route details on Route Logs page using data below:
      | date           | {gradle-current-date-yyyy-MM-dd} |
      | id             | {KEY_CREATED_ROUTE_ID}           |
      | status         | PENDING                          |
      | driverName     | {ninja-driver-name}              |
      | hub            | {hub-name}                       |
      | zone           | {zone-name}                      |
      | driverTypeName | {default-driver-type-name}       |

  @DeleteOrArchiveRoute
  Scenario: Operator Remove Tag of a Single Route on Route Logs Page (uid:54eb6cae-5061-4559-994d-cead31ef5d1f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id},{route-tag-id-2}]
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator removes tag "{route-tag-name-2}" from created route
    Then Operator verify route details on Route Logs page using data below:
      | id   | {KEY_CREATED_ROUTE_ID} |
      | tags | {route-tag-name}       |

  @DeleteOrArchiveRoute
  Scenario: Operator Address Verify Route on Route Logs Page (uid:1e689de9-9f65-4447-8532-a775abbd9574)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of Delivery Transaction waypoint of created order
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator verifies address of "{KEY_CREATED_ROUTE_ID}" route on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top                | Address verification successful for selected route |
      | waitUntilInvisible | true                                               |
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order:
      | archived | score |
      | 1        | 1.0   |
      | 0        | 0.5   |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Filters Multiple Routes by Comma Separated Route Ids on Route Logs Page - <Note> (<hiptest-uid >)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-2}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "<Search>" Route ID on Route Logs page
    Then Operator verify route details on Route Logs page using data below:
      | date           | {gradle-current-date-yyyy-MM-dd}  |
      | id             | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | status         | PENDING                           |
      | driverName     | {ninja-driver-name}               |
      | hub            | {hub-name}                        |
      | zone           | {zone-name}                       |
      | driverTypeName | {default-driver-type-name}        |
    And Operator verify route details on Route Logs page using data below:
      | date           | {gradle-current-date-yyyy-MM-dd}  |
      | id             | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
      | status         | PENDING                           |
      | driverName     | {ninja-driver-name}               |
      | hub            | {hub-name-2}                      |
      | zone           | {zone-name-2}                     |
      | driverTypeName | {default-driver-type-name}        |
    Examples:
      | Note          | Search                                                               | hiptest-uid                              |
      | With Space    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}, {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | uid:1751c03a-218b-479b-867c-388129348954 |
      | With No Space | {KEY_LIST_OF_CREATED_ROUTE_ID[1]},{KEY_LIST_OF_CREATED_ROUTE_ID[2]}  | uid:b3fead8a-ca6e-4922-b8c7-1c90fb76a0e4 |

  @DeleteOrArchiveRoute
  Scenario: Operator Optimise Single Route from Route Logs Page (uid:9f9943a6-918d-4388-a19a-7650cdbcba18)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator opens Optimize Selected Route dialog for "{KEY_CREATED_ROUTE_ID}" route on Route Logs page
    Then Optimize Selected Route dialog contains message on Route Logs page:
      | This route originally contained: 2 waypoint(s)                             |
      | Route Optimise did NOT drop any waypoint(s)!                               |
      | Are you sure you want to proceed to optimise this route to 2 waypoints(s)? |
    When Operator clicks Optimize Route button in Optimize Selected Route dialog on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top    | 1 Route Optimised            |
      | bottom | Route {KEY_CREATED_ROUTE_ID} |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Redirected to Route Manifest from Route Logs Page (uid:dba06f34-649b-4314-a089-7c13acde1234)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    Then Operator verifies route details on Route Manifest page:
      | routeId | {KEY_CREATED_ROUTE_ID} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op