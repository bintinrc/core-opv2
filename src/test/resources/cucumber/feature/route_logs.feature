@OperatorV2 @Routing @OperatorV2Part2 @RouteLogs @Saas
Feature: Route Logs

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator create new route from page Route Logs (uid:fe58af45-de7f-4dff-aced-8bf7521666e3)
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
  Scenario: Operator create multiple route from page Route Logs (uid:63f576e1-cc66-465d-9875-091b7c398daa)
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
  Scenario: Operator bulk edit details multiple routes from page Route Logs (uid:62505b98-3c5d-436a-9ddd-51586af5ff75)
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
  Scenario: Operator edit driver type of multiple routes from page Route Logs (uid:62941cfd-9c85-429e-879d-a4fdd68f9c13)
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
    When Operator edit driver type of multiple routes using data below:
      | driverTypeId   | {driver-type-id}   |
      | driverTypeName | {driver-type-name} |
    Then DB Operator verify driver types of multiple routes is updated successfully

  @DeleteOrArchiveRoute
  Scenario: Operator merge transactions of multiple routes from page Route Logs (uid:05d7e9a9-8b8f-4f34-8165-deba4a21029c)
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
  Scenario: Operator optimise multiple routes from page Route Logs (uid:1d9cf7fa-f3ae-4d45-b36c-11065c73ee18)
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
  Scenario: Operator print passwords of multiple routes from page Route Logs (uid:ed38f555-878d-4001-b36b-00581f92ae48)
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
  Scenario: Operator print multiple routes from page Route Logs (uid:8ef03526-1856-434b-b7c7-65ebc6ff0b22)
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
  Scenario: Operator archive multiple routes from page Route Logs (uid:1135446b-bc71-4d33-a9a7-eb4d06ea8df2)
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
  Scenario: Operator unarchive multiple routes from page Route Logs (uid:53db032a-9532-4c24-8de5-254e50619989)
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
  Scenario: Operator delete multiple routes from page Route Logs (uid:daed3228-f924-4c79-8a11-4863f8b3df40)
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
  Scenario: Operator 'Edit Details' on Operator V2 - Route Logs menu (uid:d735938c-f87e-47c1-9a6a-61d31850e0cb)
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
  Scenario: Operator 'Add New Tag' on Operator V2 - Route Logs menu (uid:24ef3b76-c582-42da-b6d8-cf867aeec8e9)
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
  Scenario: Operator 'Delete Route' on Operator V2 - Route Logs menu (uid:ff70c3c0-73bc-4cde-9ce7-c340769560cb)
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
  Scenario: Operator 'Edit Route' on Operator V2 - Route Logs menu (uid:0ea01bbb-0651-4186-84b4-0b3f4a522d3e)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
#    When Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route(s) Only'
#    Then Operator redirect to this page 'https://operator-qa.ninjavan.co/sg/ng#/zonal_routing_edit?fetch_unrouted_waypoints=false&to_cluster=true&id={{route_id}}'
#    Then Operator close Edit Routes dialog

  @DeleteOrArchiveRoute
  Scenario: Trigger Force Finish a pending waypoint (Reservation/Transaction) from route manifest - Failed Reservation (uid:cdb4aefa-8ddc-4859-b2d5-7d4a56187aee)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    When Operator fail reservation waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status             | Fail                       |
      | deliveriesCount    | 0                          |
      | pickupsCount       | 0                          |
      | reservation.id     | KEY_CREATED_RESERVATION_ID |
      | reservation.status | Fail                       |

  @DeleteOrArchiveRoute
  Scenario: Operator Trigger Force Finish a pending waypoint (Reservation/Transaction) from route manifest - Success Reservation (uid:cde1674e-43f0-4ebc-94fc-008720179133)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    When Operator success reservation waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status             | Success                    |
      | deliveriesCount    | 0                          |
      | pickupsCount       | 0                          |
      | reservation.id     | KEY_CREATED_RESERVATION_ID |
      | reservation.status | Success                    |

  @DeleteOrArchiveRoute
  Scenario: Operator Trigger Force Finish a pending waypoint (Reservation/Transaction) from route manifest - Failed Transaction PP (uid:60418fe1-7c3c-497e-ae95-7b966df157d3)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    When Operator fail pickup waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status               | Fail                          |
      | deliveriesCount      | 0                             |
      | pickupsCount         | 1                             |
      | trackingIds          | KEY_CREATED_ORDER_TRACKING_ID |
      | comments             | KEY_FAILURE_REASON            |
      | pickup.trackingId    | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.status        | Fail                          |
      | pickup.failureReason | 9                             |

  @DeleteOrArchiveRoute
  Scenario: Operator Trigger Force Finish a pending waypoint (Reservation/Transaction) from route manifest - Success Transaction PP (uid:a13591f4-84c7-4b80-88a0-05c293ddb13a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    When Operator success pickup waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status            | Success                       |
      | deliveriesCount   | 0                             |
      | pickupsCount      | 1                             |
      | trackingIds       | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.trackingId | KEY_CREATED_ORDER_TRACKING_ID |
      | pickup.status     | Success                       |

  @DeleteOrArchiveRoute
  Scenario: Operator Trigger Force Finish a pending waypoint (Reservation/Transaction) from route manifest - Failed Transaction DD (uid:3bc55101-8da8-4127-a14e-ac38f7908949)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    When Operator fail delivery waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status                 | Fail                          |
      | deliveriesCount        | 1                             |
      | pickupsCount           | 0                             |
      | comments               | KEY_FAILURE_REASON            |
      | trackingIds            | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.trackingId    | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.status        | Fail                          |
      | delivery.failureReason | 1                             |

  @DeleteOrArchiveRoute
  Scenario: Operator Trigger Force Finish a pending waypoint (Reservation/Transaction) from route manifest - Success Transaction DD (uid:8f755436-4f6f-4461-9bb8-2675efbd3806)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver failed the delivery of the created parcel
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    When Operator success delivery waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status              | Success                       |
      | deliveriesCount     | 1                             |
      | pickupsCount        | 0                             |
      | trackingIds         | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.trackingId | KEY_CREATED_ORDER_TRACKING_ID |
      | delivery.status     | Success                       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
