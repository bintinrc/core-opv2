@OperatorV2 @Core @Routing @RouteLogs
Feature: Route Logs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Create a Single Route from Route Logs Page (uid:76362592-6316-4521-a835-dbe10a1b2f12)
    Given Operator go to menu Routing -> Route Logs
    When Operator create new route using data below:
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify the new route is created successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Create Multiple Routes by Duplicate Current Route on Route Logs Page (uid:82caf88b-3814-4768-ac98-8cc063346b1b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                                |
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is created successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Edit Multiple Routes Details from Route Logs Page (uid:037e90a7-f324-4ce2-9cff-ff198ac9365b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                                |
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is created successfully
    When Operator bulk edit details multiple routes using data below:
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-2-name}            |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is bulk edited successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Merge Transactions of Multiple Routes from Route Logs Page (uid:b4768f8e-befb-44d6-a7f4-0ffc9d77e7c9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                                |
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is created successfully
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 4                                                                                                                                                                                                                                                                                                                                |
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                          |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator add multiple parcels to multiple routes using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator merge transactions of multiple routes
    Then Operator verify transactions of multiple routes is merged successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Optimise Multiple Routes from Route Logs Page (uid:03e47864-aa13-4dc3-8775-27f07257320b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                                |
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is created successfully
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 4                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator add multiple parcels to multiple routes using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator optimise multiple routes
    Then Operator verify multiple routes is optimised successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Print Passwords of Multiple Routes from Route Logs Page (uid:25552c52-3a03-4110-8b33-628b65785b37)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                                |
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is created successfully
    When Operator print passwords of multiple routes
    Then Operator verify printed passwords of selected routes info is correct

  @DeleteOrArchiveRoute
  Scenario: Operator Print Multiple Routes Details from Route Logs Page (uid:1a53a8cd-1499-4135-9171-5435bf397469)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                                |
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is created successfully
    When Operator print multiple routes
    Then Operator verify multiple routes is printed successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Archive Multiple Routes from Route Logs Page (uid:885b74a1-bcc4-48a7-a9df-fb5392e92971)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                                |
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is created successfully
    When Operator archive multiple routes
    Then Operator verify multiple routes is archived successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Unarchive Multiple Archived Routes from Route Logs Page (uid:ca9a74b2-4a72-4939-a4d2-f49c44a192cc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                                |
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is created successfully
    When Operator archive multiple routes
    Then Operator verify multiple routes is archived successfully
    When Operator unarchive multiple routes
    Then Operator verify multiple routes is unarchived successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Delete Multiple Routes from Route Logs Page (uid:8839e88d-7873-4bb8-8143-8de7de657624)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                                |
      | routeDate       | {gradle-current-date-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]               |
      | zoneName        | {zone-name}                      |
      | hubName         | {hub-name}                       |
      | ninjaDriverName | {ninja-driver-name}              |
      | vehicleName     | {vehicle-name}                   |
    Then Operator verify multiple routes is created successfully
    When Operator delete multiple routes
    Then Operator verify multiple routes is deleted successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Edit Details of a Single Route on Route Logs Page (uid:5aa174fa-7978-490f-8a45-a1c2c2a764dc)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator click 'Edit Details'
    When Operator edit 'Assigned Driver' to driver '{ninja-driver-2-name}' and edit 'Comments'
    Then Operator verify route's driver must be changed to '{ninja-driver-2-name}' in table list

  @DeleteOrArchiveRoute
  Scenario: Operator Add Tag to a Single Route on Route Logs Page (uid:47e4dfc2-b5e3-470a-a832-b99c85905f8a)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator add tag '{route-tag-name}'
    Then Operator verify route's tag must contain '{route-tag-name}'

  @DeleteOrArchiveRoute
  Scenario: Operator Delete a Single Route on Route Logs Page (uid:9d2ef35c-fceb-466b-ab93-13cd9d98807b)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator delete route on Operator V2
    Then Operator verify route must be deleted successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Redirected to Edit Route Page from Route Logs (uid:f07cd3bd-e0a4-4117-a92f-e4005e3d5c6a)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    When Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route(s) Only'
    Then Operator redirect to this page 'https://operatorv2-qa.ninjavan.co/#/sg/zonal-routing/edit?ids={{route_id}}&unrouted=false&cluster=true'
    Then Operator close Edit Routes dialog

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op