@OperatorV2 @OperatorV2Part2 @RouteLogs @Saas
Feature: Route Logs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator create new route from page Route Logs (uid:fe58af45-de7f-4dff-aced-8bf7521666e3)
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create new route using data below:
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify the new route is created successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator create multiple route from page Route Logs (uid:63f576e1-cc66-465d-9875-091b7c398daa)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create multiple routes using data below:
#      | numberOfRoute   | 2                         |
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is created successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator bulk edit details multiple routes from page Route Logs (uid:62505b98-3c5d-436a-9ddd-51586af5ff75)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create multiple routes using data below:
#      | numberOfRoute   | 2                         |
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is created successfully
#    When Operator bulk edit details multiple routes using data below:
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-2-name}     |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is bulk edited successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator edit driver type of multiple routes from page Route Logs (uid:62941cfd-9c85-429e-879d-a4fdd68f9c13)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create multiple routes using data below:
#      | numberOfRoute   | 2                         |
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is created successfully
#    When Operator edit driver type of multiple routes using data below:
#      | driverTypeId   | {driver-type-id}   |
#      | driverTypeName | {driver-type-name} |
#    Then DB Operator verify driver types of multiple routes is updated successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator merge transactions of multiple routes from page Route Logs (uid:05d7e9a9-8b8f-4f34-8165-deba4a21029c)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create multiple routes using data below:
#      | numberOfRoute   | 2                         |
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is created successfully
#    Given API Shipper create multiple Order V2 Parcel using data below:
#      | numberOfOrder  | 4       |
#      | generateFrom   | INDEX-0 |
#      | generateTo     | INDEX-1 |
#      | v2OrderRequest | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
#    Given API Operator Global Inbound multiple parcels using data below:
#      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
#    Given API Operator add multiple parcels to multiple routes using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    When Operator merge transactions of multiple routes
#    Then Operator verify transactions of multiple routes is merged successfully
#
#  @ArchiveAndDeleteRouteViaDb
  Scenario: Operator optimise multiple routes from page Route Logs (uid:1d9cf7fa-f3ae-4d45-b36c-11065c73ee18)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute   | 2                         |
      | routeDate       | {current-date-yyyy-MM-dd} |
      | routeTags       | [FLT]                     |
      | zoneName        | {zone-name}               |
      | hubName         | DJPH-02-HUB               |
      | ninjaDriverName | {ninja-driver-name}       |
      | vehicleName     | {vehicle-name}            |
    Then Operator verify multiple routes is created successfully
    Given API Shipper create multiple Order V2 Parcel using data below:
      | numberOfOrder     | 4      |
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":4714 } |
    Given API Operator add multiple parcels to multiple routes using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
#    When Operator optimise multiple routes
#    Then Operator verify multiple routes is optimised successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator print passwords of multiple routes from page Route Logs (uid:ed38f555-878d-4001-b36b-00581f92ae48)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create multiple routes using data below:
#      | numberOfRoute   | 2                         |
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is created successfully
#    When Operator print passwords of multiple routes
#    Then Operator verify printed passwords of selected routes info is correct
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator print multiple routes from page Route Logs (uid:8ef03526-1856-434b-b7c7-65ebc6ff0b22)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create multiple routes using data below:
#      | numberOfRoute   | 2                         |
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is created successfully
#    When Operator print multiple routes
#    Then Operator verify multiple routes is printed successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator archive multiple routes from page Route Logs (uid:1135446b-bc71-4d33-a9a7-eb4d06ea8df2)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create multiple routes using data below:
#      | numberOfRoute   | 2                         |
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is created successfully
#    When Operator archive multiple routes
#    Then Operator verify multiple routes is archived successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator unarchive multiple routes from page Route Logs (uid:53db032a-9532-4c24-8de5-254e50619989)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create multiple routes using data below:
#      | numberOfRoute   | 2                         |
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is created successfully
#    When Operator archive multiple routes
#    Then Operator verify multiple routes is archived successfully
#    When Operator unarchive multiple routes
#    Then Operator verify multiple routes is unarchived successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator delete multiple routes from page Route Logs (uid:daed3228-f924-4c79-8a11-4863f8b3df40)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator create multiple routes using data below:
#      | numberOfRoute   | 2                         |
#      | routeDate       | {current-date-yyyy-MM-dd} |
#      | routeTags       | [FLT]                     |
#      | zoneName        | {zone-name}               |
#      | hubName         | {hub-name}                |
#      | ninjaDriverName | {ninja-driver-name}       |
#      | vehicleName     | {vehicle-name}            |
#    Then Operator verify multiple routes is created successfully
#    When Operator delete multiple routes
#    Then Operator verify multiple routes is deleted successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator 'Edit Details' on Operator V2 - Route Logs menu (uid:d735938c-f87e-47c1-9a6a-61d31850e0cb)
#    Given API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator set filter using data below and click 'Load Selection'
#      | routeDateFrom | YESTERDAY  |
#      | routeDateTo   | TODAY      |
#      | hubName       | {hub-name} |
#    When Operator click 'Edit Details'
#    When Operator edit 'Assigned Driver' to driver '{ninja-driver-2-name}' and edit 'Comments'
#    Then Operator verify route's driver must be changed to '{ninja-driver-2-name}' in table list
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator 'Add New Tag' on Operator V2 - Route Logs menu (uid:24ef3b76-c582-42da-b6d8-cf867aeec8e9)
#    Given API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator set filter using data below and click 'Load Selection'
#      | routeDateFrom | YESTERDAY  |
#      | routeDateTo   | TODAY      |
#      | hubName       | {hub-name} |
#    When Operator add tag '{route-tag-name}'
#    Then Operator verify route's tag must contain '{route-tag-name}'
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator 'Delete Route' on Operator V2 - Route Logs menu (uid:ff70c3c0-73bc-4cde-9ce7-c340769560cb)
#    Given API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator set filter using data below and click 'Load Selection'
#      | routeDateFrom | YESTERDAY  |
#      | routeDateTo   | TODAY      |
#      | hubName       | {hub-name} |
#    When Operator delete route on Operator V2
#    Then Operator verify route must be deleted successfully
#
#  @ArchiveAndDeleteRouteViaDb
#  Scenario: Operator 'Edit Route' on Operator V2 - Route Logs menu (uid:0ea01bbb-0651-4186-84b4-0b3f4a522d3e)
#    Given API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Routing -> Route Logs
#    When Operator set filter using data below and click 'Load Selection'
#      | routeDateFrom | YESTERDAY  |
#      | routeDateTo   | TODAY      |
#      | hubName       | {hub-name} |
#    When Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route(s) Only'
#    Then Operator redirect to this page 'https://operator-qa.ninjavan.co/sg/ng#/zonal_routing_edit?fetch_unrouted_waypoints=false&to_cluster=true&id={{route_id}}'
#    Then Operator close Edit Routes dialog

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
