@OperatorV2 @Core @Routing @RouteLogs
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
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Operator bulk edits details of created routes using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}        |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name}                             |
      | hub        | {hub-name}                              |
      | driverName | {ninja-driver-2-name}                   |
      | vehicle    | {vehicle-name}                          |
      | comments   | Route has been edited by automated test |
    Then Operator verify routes details on Route Logs page using data below:
      | date                             | id                                | driverName            | hub        | driverTypeName       | comments                                | tags             |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {ninja-driver-2-name} | {hub-name} | {driver-type-name-2} | Route has been edited by automated test | {route-tag-name} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {ninja-driver-2-name} | {hub-name} | {driver-type-name-2} | Route has been edited by automated test | {route-tag-name} |

  @DeleteOrArchiveRoute
  Scenario: Operator Merge Transactions of Multiple Routes from Route Logs Page (uid:b4768f8e-befb-44d6-a7f4-0ffc9d77e7c9)
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
  Scenario: Operator Optimise Multiple Routes from Route Logs Page (uid:03e47864-aa13-4dc3-8775-27f07257320b)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Operator save data of created routes on Route Logs page
    And Operator print passwords of created routes
    Then Operator verify printed passwords of selected routes info is correct

  @DeleteOrArchiveRoute
  Scenario: Operator Print Multiple Routes Details from Route Logs Page (uid:1a53a8cd-1499-4135-9171-5435bf397469)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator print created routes
    Then Operator verifies created routes are printed successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Archive Multiple Routes from Route Logs Page (uid:885b74a1-bcc4-48a7-a9df-fb5392e92971)
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
  Scenario: Operator Delete Multiple Routes from Route Logs Page (uid:8839e88d-7873-4bb8-8143-8de7de657624)
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
    When Operator delete routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verify routes are deleted successfully:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Edit Details of a Single Route on Route Logs Page (uid:5aa174fa-7978-490f-8a45-a1c2c2a764dc)
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
  Scenario: Operator Add Tag to a Single Route on Route Logs Page (uid:47e4dfc2-b5e3-470a-a832-b99c85905f8a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator adds tag "{route-tag-name}" to created route
    Then Operator verify route details on Route Logs page using data below:
      | id   | {KEY_CREATED_ROUTE_ID} |
      | tags | {route-tag-name}       |

  @DeleteOrArchiveRoute
  Scenario: Operator Delete a Single Route on Route Logs Page (uid:9d2ef35c-fceb-466b-ab93-13cd9d98807b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator deletes created route on Route Logs page
    Then Operator verify routes are deleted successfully:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Redirected to Edit Route Page from Route Logs (uid:f07cd3bd-e0a4-4117-a92f-e4005e3d5c6a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route(s) Only'
    Then Operator is redirected to this page "/sg/zonal-routing/edit?ids={KEY_CREATED_ROUTE_ID}&unrouted=false&cluster=true"

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Route by Route Id on Route Logs Page (uid:273b5063-c85e-47a1-bada-f50d3f755541)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
  Scenario: Operator Unarchive Single Archived Route from Route Logs Page (uid:dd0d09ab-c2bd-4d0f-b327-51dfff8c2eb0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator archives routes:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator unarchive routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    Then Operator verify routes details on Route Logs page using data below:
      | id                                | status      |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | IN_PROGRESS |

  @DeleteOrArchiveRoute
  Scenario: Operator Unarchive Multiple Archived Routes from Route Logs Page (uid:ca9a74b2-4a72-4939-a4d2-f49c44a192cc)
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

  @DeleteOrArchiveRoute
  Scenario: Operator Unarchive Single NON-archived Route from Route Logs Page (uid:157cc929-d7c5-4fff-9345-66112ee327a7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator select "Unarchive Selected" for given routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    Then Operator verify "Unarchive" process data in Selection Error dialog on Route Logs page:
      | routeId                           | reason                   |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | Invalid status to change |
    When Operator clicks 'Continue' button in Selection Error dialog on Route Logs page
    Then Operator verifies that error toast displayed:
      | top    | Unable to apply actions |
      | bottom | No valid selection      |

  @DeleteOrArchiveRoute
  Scenario: Operator Unarchive Multiple NON-Archived Routes from Route Logs Page (uid:d295adcf-ffa0-450a-9711-05b4b27de9cf)
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
    And Operator select "Unarchive Selected" for given routes on Route Logs page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verify "Unarchive" process data in Selection Error dialog on Route Logs page:
      | routeId                           | reason                   |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | Invalid status to change |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | Invalid status to change |
    When Operator clicks 'Continue' button in Selection Error dialog on Route Logs page
    Then Operator verifies that error toast displayed:
      | top    | Unable to apply actions |
      | bottom | No valid selection      |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op