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

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - <transaction_type> Transactions - <note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>",    "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"<type>" } |
    Given Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator merge transactions of created routes
    Then Operator verifies that info toast displayed:
      | top    | Transactions within 1 Routes Merged     |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator verifies <transaction_type> transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    Examples:
      | note                                            | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2         | phone_number_1 | phone_number_2 | is_pickup_required | hiptest-uid                              |
      | Same address, Email & Phone Number              | Pickup           | PP   | Return       | from      | generateTo      | binti@test.co | binti@test.co   | +6595557073    | +6595557073    | true               | uid:05fc0970-5666-4b38-a0c2-5625fd481688 |
      | Same address, Email & Phone Number              | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co   | +6595557073    | +6595557073    | false              | uid:43d402e0-3439-4076-8c7a-ff2f79b4e6a3 |
      | Same Address & Email But Different Phone Number | Pickup           | PP   | Return       | from      | generateTo      | binti@test.co | binti@test.co   | +6595557073    | +6595557074    | true               | uid:1293cc94-0be1-4dfa-8a0c-ee049a008eb4 |
      | Same Address & Email But Different Phone Number | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co   | +6595557073    | +6595557074    | false              | uid:de3a73fa-5deb-4390-b5bf-7344473f59ec |
      | Same Address & Phone Number But Different Email | Pickup           | PP   | Return       | from      | generateTo      | binti@test.co | another@test.co | +6595557073    | +6595557073    | true               | uid:22d6a084-2967-4f1b-949f-9f7ee8d19d99 |
      | Same Address & Phone Number But Different Email | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | another@test.co | +6595557073    | +6595557073    | false              | uid:c1d930e3-2a56-4a33-b065-6db26a8396fb |

  @DeleteOrArchiveRoute
  Scenario: Operator Merge Multiple Transactions of Single Route - Pickup and Delivery Transactions - Same address, Email & Phone Number (uid:9d3895d6-7837-4ca0-9d7a-41a4d2789337)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} | { "type":"PP" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} | { "type":"PP" }         |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | { "type":"DD" }         |
    Given Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator merge transactions of created routes
    Then Operator verifies that info toast displayed:
      | top    | Transactions within 1 Routes Merged     |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator verifies Pickup transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And API Operator verifies Delivery transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} |

  @DeleteOrArchiveRoute
  Scenario: Operator Merge Multiple Transactions of Multiple Route - Delivery Transactions - Same address, Email & Phone Number (uid:3d5d62f0-c95b-4e13-b05f-746d2ec18790)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} | { "type":"DD" }         |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | { "type":"DD" }         |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator merge transactions of created routes
    Then Operator verifies that info toast displayed:
      | top    | Transactions within 2 Routes Merged                                        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]}, {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And API Operator verifies Delivery transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And API Operator verifies Delivery transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} |

  @DeleteFilterTemplate
  Scenario: Operator Save A New Preset on Route Logs Page (uid:f259e5b1-5e98-4672-9b9f-ebf34bd3470f)
    Given Operator go to menu Routing -> Route Logs
    And Operator set filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-1-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-current-date-dd/MM/yyyy}   |
      | hub            | {hub-name}                         |
      | driver         | {ninja-driver-name}                |
      | archivedRoutes | true                               |
    And Operator selects "Save Current As Preset" preset action on Route Logs page
    Then Operator verifies Save Preset dialog on Route Logs page contains filters:
      | Route Date: {gradle-previous-1-day-yyyy-MM-dd} to {gradle-current-date-yyyy-MM-dd} |
      | Hub: (1) {hub-name}                                                                |
      | Driver: (1) {ninja-driver-name}                                                    |
      | Archived Routes: Show                                                              |
    And Operator verifies Preset Name field in Save Preset dialog on Route Logs page is required
    And Operator verifies Cancel button in Save Preset dialog on Route Logs page is enabled
    And Operator verifies Save button in Save Preset dialog on Route Logs page is disabled
    When Operator enters "PRESET {gradle-current-date-yyyyMMddHHmmsss}" Preset Name in Save Preset dialog on Route Logs page
    Then Operator verifies Preset Name field in Save Preset dialog on Route Logs page has green checkmark on it
    And Operator verifies Save button in Save Preset dialog on Route Logs page is enabled
    When Operator clicks Save button in Save Preset dialog on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top                | 1 filter preset created                |
      | bottom             | Name: {KEY_ROUTES_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                   |
    And Operator verifies selected Filter Preset name is "{KEY_ROUTES_FILTERS_PRESET_NAME}" on Route Logs page
    And DB Operator verifies filter preset record:
      | id        | {KEY_ROUTES_FILTERS_PRESET_ID}   |
      | namespace | routes                           |
      | name      | {KEY_ROUTES_FILTERS_PRESET_NAME} |
    When Operator refresh page
    And Operator selects "{KEY_ROUTES_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    Then Operator verifies selected filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-1-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-current-date-dd/MM/yyyy}   |
      | hub            | {hub-name}                         |
      | driver         | {ninja-driver-name}                |
      | archivedRoutes | true                               |

  @DeleteFilterTemplate
  Scenario: Operator Apply Filter Preset on Route Logs Page (uid:6707eccc-3717-43d4-8f5f-a582ee833507)
    Given  API Operator creates new Routes Filter Template using data below:
      | name            | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.startDate | {gradle-previous-1-day-dd/MM/yyyy}           |
      | value.endDate   | {gradle-current-date-dd/MM/yyyy}             |
      | value.hubIds    | {hub-id}                                     |
      | value.driverIds | {ninja-driver-id}                            |
      | value.zoneIds   | {zone-id}                                    |
      | value.archived  | true                                         |
    When Operator go to menu Routing -> Route Logs
    And Operator selects "{KEY_ROUTES_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    Then Operator verifies selected filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-1-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-current-date-dd/MM/yyyy}   |
      | hub            | {hub-name}                         |
      | driver         | {ninja-driver-name}                |
      | archivedRoutes | true                               |
      | zone           | {zone-name}                        |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset on Route Logs Page (uid:d2232710-301a-4be4-ad8c-06c00507ec5b)
    Given  API Operator creates new Routes Filter Template using data below:
      | name            | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.startDate | {gradle-previous-1-day-dd/MM/yyyy}           |
      | value.endDate   | {gradle-current-date-dd/MM/yyyy}             |
      | value.hubIds    | {hub-id}                                     |
      | value.driverIds | {ninja-driver-id}                            |
      | value.zoneIds   | {zone-id}                                    |
      | value.archived  | false                                        |
    When Operator go to menu Routing -> Route Logs
    And Operator selects "{KEY_ROUTES_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    And Operator set filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-2-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-previous-1-day-dd/MM/yyyy} |
      | hub            | {hub-name-2}                       |
      | driver         | {ninja-driver-2-name}              |
      | archivedRoutes | true                               |
    And Operator selects "Save Current As Preset" preset action on Route Logs page
    Then Operator verifies Save Preset dialog on Route Logs page contains filters:
      | Route Date: {gradle-previous-2-day-yyyy-MM-dd} to {gradle-previous-1-day-yyyy-MM-dd} |
      | Hub: (1) {hub-name-2}                                                                |
      | Driver: (1) {ninja-driver-2-name}                                                    |
      | Archived Routes: Show                                                                |
    When Operator enters "{KEY_ROUTES_FILTERS_PRESET_NAME}" Preset Name in Save Preset dialog on Route Logs page
    Then Operator verifies help text "This name is already taken. Click update to overwrite the preset?" is displayed in Save Preset dialog on Route Logs page
    When Operator clicks Update button in Save Preset dialog on Rout Logs page
    Then Operator verifies that success react notification displayed:
      | top                | 1 filter preset updated                |
      | bottom             | Name: {KEY_ROUTES_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                   |
    When Operator refresh page
    And Operator selects "{KEY_ROUTES_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    Then Operator verifies selected filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-2-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-previous-1-day-dd/MM/yyyy} |
      | hub            | {hub-name-2}                       |
      | driver         | {ninja-driver-2-name}              |
      | archivedRoutes | true                               |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on Route Logs Page (uid:c5baeef5-610b-4f1c-af63-61206cacd78d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given  API Operator creates new Routes Filter Template using data below:
      | name            | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.startDate | {gradle-previous-1-day-dd/MM/yyyy}           |
      | value.endDate   | {gradle-current-date-dd/MM/yyyy}             |
      | value.hubIds    | {hub-id}                                     |
      | value.driverIds | {ninja-driver-id}                            |
      | value.zoneIds   | {zone-id}                                    |
      | value.archived  | false                                        |
    When Operator go to menu Routing -> Route Logs
    And Operator selects "{KEY_ROUTES_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    And Operator selects "Delete Preset" preset action on Route Logs page
    Then Operator verifies Cancel button in Delete Preset dialog on Route Logs page is enabled
    And Operator verifies Delete button in Delete Preset dialog on Route Logs page is enabled
    When Operator verifies "{KEY_ROUTES_FILTERS_PRESET_NAME}" preset is selected in Delete Preset dialog on Route Logs page
    Then Operator verifies "Preset {KEY_ROUTES_FILTERS_PRESET_NAME} will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on Route Logs page
    When Operator clicks Delete button in Delete Preset dialog on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top    | 1 filter preset deleted            |
      | bottom | ID: {KEY_ROUTES_FILTERS_PRESET_ID} |
    And DB Operator verifies "{KEY_ROUTES_FILTERS_PRESET_ID}" filter preset is deleted

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op