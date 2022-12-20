@StationManagement @StationRouteMonitoring @Run
Feature: Route Monitoring V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Delivery
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Pickup
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Reservation
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending Reservation From Route
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {shipper-v4-name}                |
    And Operator removes the route from the created reservation
    And DB Operator verifies "{KEY_CREATED_RESERVATION.waypointId}" waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |


  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Delivery
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver pickup the created parcel successfully
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Pickup
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver pickup the created parcel successfully
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Reservation
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Delivery - Valid Failed
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason          | Failure due to customer/shipper - Normal                  |
      | Failure Reason Detail 1 | Address is correct but customer is not available - Normal |
      | Failure Reason Detail 2 | Residential address, but no one to receive - Normal       |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |


  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Delivery - Invalid Failed
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason          | Parcel Unattempted - Normal                                    |
      | Failure Reason Detail 1 | I had insufficient time to complete all my deliveries - Normal |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Pickup - Valid Failed
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason | No parcels to pick up at all - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Pickup - Invalid Failed
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason | Cannot Make It (CMI) - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Reservation - Valid Fail
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {shipper-v4-legacy-id}           |
      | status      | ROUTED                           |
    And Operator fails reservation with failure Reason for the ReservationID "{KEY_CREATED_RESERVATION_ID}"
      | Failure Reason | No parcels to pick up at all - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |


  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Reservation - Invalid Fail
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {shipper-v4-legacy-id}           |
      | status      | ROUTED                           |
    And Operator fails reservation with failure Reason for the ReservationID "{KEY_CREATED_RESERVATION_ID}"
      | Failure Reason | Cannot Make It (CMI) - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       | failureReasonCodeId |
      | {hub-id-15} | {hub-name-15} | 112                 |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed on NON-Failed Waypoints
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    Then Operator verifies pop up modal is showing No Results Found
      | INVALID_FAILED_DELIVERIES   | YES |
      | INVALID_FAILED_PICKUPS      | YES |
      | INVALID_FAILED_RESERVATIONS | YES |

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @@ForceSuccessOrder @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Reservation
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {shipper-v4-legacy-id}           |
      | status      | ROUTED                           |
    And Operator fails reservation with failure Reason for the ReservationID "{KEY_CREATED_RESERVATION_ID}"
      | Failure Reason | Cannot Make It (CMI) - Hyperlocal |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 1 |
    When Operator Filters the records in the "Invalid Failed Reservations" by applying the following filters:
      | Reservation ID               | Pickup Name        |
      | {KEY_CREATED_RESERVATION_ID} | {KEY_SHIPPER_NAME} |
#      | Reservation ID               | Pickup Name        | Address               | Contact              |
#      | {KEY_CREATED_RESERVATION_ID} | {KEY_SHIPPER_NAME} | {KEY_SHIPPER_ADDRESS} | {KEY_SHIPPER_CONTACT} |
    And Operator selects the timeslot "3pm - 6pm" in the table
    Then Operator verify value in the "Invalid Failed Reservations" table for the "RESERVATION_ID" column value is equal to "{KEY_CREATED_RESERVATION_ID}"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "PICKUP_NAME" column value is equal to "{KEY_SHIPPER_NAME}"
#    Then Operator verify value in the "Invalid Failed Reservations" table for the "ADDRESS" column value is equal to "{KEY_SHIPPER_ADDRESS}"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "TIME_SLOT" column value is equal to "3pm - 6pm"
#    Then Operator verify value in the "Invalid Failed Reservations" table for the "CONTACT" column contains "{KEY_SHIPPER_CONTACT}"
    And Operator verifies that Shipper Pickup page is opened on clicking Reservation ID "{KEY_CREATED_RESERVATION_ID}" table "Invalid Failed Reservations"

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order Has PRIOR Tag
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | orderTag | {order-tag-prior-id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason | Cannot Make It (CMI) - ODP |
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}"
      | Failure Reason | Cannot Make It (CMI) - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 2
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 2 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    When Operator Filters the records in the "Invalid Failed Pickups" by applying the following filters:
      | Tracking ID                                | Customer Name                                     | Order Tags | Address                                     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]} | PRIOR      | {KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]} |
    Then Operator verify value in the "Invalid Failed Pickups" table for the Tags column value is equal to "PRIOR"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]}"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" in table "Invalid Failed Pickups"
    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order with NO Tags
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason | Cannot Make It (CMI) - ODP |
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}"
      | Failure Reason | Cannot Make It (CMI) - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 2
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 2 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    When Operator Filters the records in the "Invalid Failed Pickups" by applying the following filters:
      | Tracking ID                                | Customer Name                                     | Address                                     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]} | {KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]} |
    Then Operator verify value in the "Invalid Failed Pickups" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]}"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" in table "Invalid Failed Pickups"

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels on NON-PRIOR Waypoints
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    When Operator clicks on the "PENDING_PRIORITY_PARCELS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | PENDING_PRIORITY_DELIVERIES | 0 |
      | PENDING_PRIORITY_PICKUPS    | 0 |
    Then Operator verifies pop up modal is showing No Results Found
      | PENDING_PRIORITY_DELIVERIES | YES |
      | PENDING_PRIORITY_PICKUPS    | YES |

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Delivery
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | orderTag | {order-tag-prior-id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 2
    When Operator clicks on the "PENDING_PRIORITY_PARCELS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | PENDING_PRIORITY_DELIVERIES | 2 |
      | PENDING_PRIORITY_PICKUPS    | 0 |
    When Operator Filters the records in the "Pending Priority Deliveries" by applying the following filters:
      | Tracking ID                                | Customer Name                                   | Order Tags | Address                                   |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[1]} | PRIOR      | {KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[1]} |
    Then Operator verify value in the "Pending Priority Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[1]}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[1]}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the Tags column value is equal to "PRIOR"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" in table "Pending Priority Deliveries"

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | orderTag | {order-tag-prior-id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 2
    When Operator clicks on the "PENDING_PRIORITY_PARCELS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | PENDING_PRIORITY_DELIVERIES | 0 |
      | PENDING_PRIORITY_PICKUPS    | 2 |
    When Operator Filters the records in the "Pending Priority Pickup" by applying the following filters:
      | Tracking ID                                | Customer Name                                     | Order Tags | Address                                     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]} | PRIOR      | {KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]} |
    Then Operator verify value in the "Pending Priority Pickup" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
    Then Operator verify value in the "Pending Priority Pickup" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]}"
    Then Operator verify value in the "Pending Priority Pickup" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]}"
    Then Operator verify value in the "Pending Priority Pickup" table for the Tags column value is equal to "PRIOR"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" in table "Pending Priority Pickup"

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup & Delivery Under the Same Route
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | orderTag | {order-tag-prior-id} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 2
    When Operator clicks on the "PENDING_PRIORITY_PARCELS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | PENDING_PRIORITY_DELIVERIES | 1 |
      | PENDING_PRIORITY_PICKUPS    | 1 |
    When Operator Filters the records in the "Pending Priority Pickup" by applying the following filters:
      | Tracking ID                                | Customer Name                                     | Order Tags | Address                                     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]} | PRIOR      | {KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]} |
    Then Operator verify value in the "Pending Priority Pickup" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
    Then Operator verify value in the "Pending Priority Pickup" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]}"
    Then Operator verify value in the "Pending Priority Pickup" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]}"
    Then Operator verify value in the "Pending Priority Pickup" table for the Tags column value is equal to "PRIOR"
    When Operator Filters the records in the "Pending Priority Deliveries" by applying the following filters:
      | Tracking ID                                | Customer Name                                   | Order Tags | Address                                   |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[2]} | PRIOR      | {KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[2]} |
    Then Operator verify value in the "Pending Priority Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[2]}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[2]}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the Tags column value is equal to "PRIOR"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" in table "Pending Priority Deliveries"


    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order Has PRIOR Tag
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Shipper tags multiple parcels as per the below tag
      | orderTag | {order-tag-prior-id} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason          | I didn't attempt the delivery - Ninja Point Waypoint |
      | Failure Reason Detail 1 | Cannot Make It (CMI) - Ninja Point Waypoint          |
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}"
      | Failure Reason          | I didn't attempt the delivery - Ninja Point Waypoint |
      | Failure Reason Detail 1 | Cannot Make It (CMI) - Ninja Point Waypoint          |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 2
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 2 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    When Operator Filters the records in the "Invalid Failed Deliveries" by applying the following filters:
      | Tracking ID                                | Customer Name                                   | Order Tags | Address                                   |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[1]} | PRIOR      | {KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[1]} |
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[1]}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[1]}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the Tags column value is equal to "PRIOR"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" in table "Invalid Failed Deliveries"

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order with NO Tags
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason          | I didn't attempt the delivery - Ninja Point Waypoint |
      | Failure Reason Detail 1 | Cannot Make It (CMI) - Ninja Point Waypoint          |
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}"
      | Failure Reason          | I didn't attempt the delivery - Ninja Point Waypoint |
      | Failure Reason Detail 1 | Cannot Make It (CMI) - Ninja Point Waypoint          |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 2
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 2 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    When Operator Filters the records in the "Invalid Failed Deliveries" by applying the following filters:
      | Tracking ID                                | Customer Name                                   | Address                                   |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[1]} | {KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[1]} |
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[1]}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[1]}"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" in table "Invalid Failed Deliveries"

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Waypoints - Pickup, Delivery & Reservation Under the Same Route
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {shipper-v4-legacy-id}           |
      | status      | ROUTED                           |
    And Operator fails reservation with failure Reason for the ReservationID "{KEY_CREATED_RESERVATION_ID}"
      | Failure Reason | Cannot Make It (CMI) - ODP |
    When Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason | Cannot Make It (CMI) - ODP |
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}"
      | Failure Reason          | I didn't attempt the delivery - Ninja Point Waypoint |
      | Failure Reason Detail 1 | Cannot Make It (CMI) - Ninja Point Waypoint          |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 3
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 1 |
      | INVALID_FAILED_PICKUPS      | 1 |
      | INVALID_FAILED_RESERVATIONS | 1 |
    When Operator Filters the records in the "Invalid Failed Pickups" by applying the following filters:
      | Tracking ID                                | Customer Name                                     | Address                                     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]} | {KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]} |
    Then Operator verify value in the "Invalid Failed Pickups" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]}"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" in table "Invalid Failed Pickups"
    When Operator Filters the records in the "Invalid Failed Deliveries" by applying the following filters:
      | Tracking ID                                | Customer Name                                   | Address                                   |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[2]} | {KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[2]} |
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[2]}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[2]}"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]}" in table "Invalid Failed Deliveries"
    When Operator Filters the records in the "Invalid Failed Reservations" by applying the following filters:
      | Reservation ID               | Pickup Name        |
      | {KEY_CREATED_RESERVATION_ID} | {KEY_SHIPPER_NAME} |
    And Operator selects the timeslot "3pm - 6pm" in the table
    Then Operator verify value in the "Invalid Failed Reservations" table for the "RESERVATION_ID" column value is equal to "{KEY_CREATED_RESERVATION_ID}"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "PICKUP_NAME" column value is equal to "{KEY_SHIPPER_NAME}"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "TIME_SLOT" column value is equal to "3pm - 6pm"
    And Operator verifies that Shipper Pickup page is opened on clicking Reservation ID "{KEY_CREATED_RESERVATION_ID}" table "Invalid Failed Reservations"


    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |


  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Reservation
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Single Transaction
    Given Operator loads Operator portal home page
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |


  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Multiple Transactions
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 3

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline:Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery Transactions
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "Station","phone_number": "+6595557073 ","email": "Station@ninjatest.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    And API Operator merge route transactions
    And API Operator get order details
    And API Operator verifies that each "Delivery" transaction of created orders has the same waypoint_id
    And API Operator gets orphaned "Delivery" transaction waypoint ids of created orders
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 2
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Pickup Transactions
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "Station","phone_number": "+6595557073 ","email": "Station@ninjatest.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator get order details
    And API Operator gets "Pickup" transaction waypoint ids of created orders
    And API Operator merge route transactions
    And API Operator get order details
    And API Operator verifies that each "Pickup" transaction of created orders has the same waypoint_id
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 2
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery & Pickup Transactions
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "Station","phone_number": "+6595557073 ","email": "Station@ninjatest.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep multiple parcels in the hub
      | hubId | <HubId> |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "Station","phone_number": "+6595557073 ","email": "Station@ninjatest.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | { "type":"PP" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | { "type":"PP" }         |
    And API Operator get order details
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    And API Operator gets "Pickup" transaction waypoint ids of created orders
    And API Operator merge route transactions
    And API Operator get order details
    And API Operator verifies that each "Delivery" transaction of orders has the same waypoint_id:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And API Operator verifies that each "Pickup" transaction of orders has the same waypoint_id:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} |
    And DB Operator verifies there are 2 route_monitoring_data records for route "KEY_CREATED_ROUTE_ID"
    And DB Operator verifies there are 2 route_waypoint records for route "KEY_CREATED_ROUTE_ID"
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 4
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 2
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 2

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |


  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Empty Route
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver
  Scenario Outline: Show Updated Driver Name in Route Monitoring V2 (uid:88878587-9c53-482f-80c2-a98f4376ac0b)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"+6589011608"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by Automation Test for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":<HubId>,"hub":"<HubName>","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep multiple parcels in the hub
      | hubId | <HubId> |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "DRIVER_NAME" column is equal to "{ninja-driver-name}"
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY |
      | routeDateTo   | TODAY     |
      | hubName       | <HubName> |
    And Operator edits details of created route using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}        |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name}                             |
      | hub        | <HubName>                               |
      | driverName | {KEY_CREATED_DRIVER_INFO.getFullName}   |
      | comments   | Route has been edited by automated test |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "DRIVER_NAME" column is equal to "{KEY_CREATED_DRIVER_INFO.getFullName}"


    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @Debug
  Scenario Outline: View Pickup Appointment Job in Route Monitoring - Add Multiple PA Jobs to Route
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @Debug
  Scenario Outline: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending PA Job From Route
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    And API Operator removes Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @Debug
  Scenario Outline: Show Updated Route Id & Driver Name of Routed PA Job in Route Monitoring
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    And Operator saves old route
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"+6589011608"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by Automation Test for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":<HubId>,"hub":"<HubName>","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_ID} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_OLD_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "DRIVER_NAME" column is equal to "{KEY_CREATED_DRIVER_INFO.getFullName}"
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @Debug
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - PA Job
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    And API Operator success Pickup Appointment job
      | pa_Id | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @Debug
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed PA Job
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                   |
      | requestBody | {"status":"failed","failure_reason_id":63,"failure_reason_code_id":9,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @Debug
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Valid Failed PA Job
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                        |
      | requestBody | {"status":"failed","failure_reason_id":1476,"failure_reason_code_id":1476,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @Debug
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Valid Failed PA Job
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                   |
      | requestBody | {"status":"failed","failure_reason_id":63,"failure_reason_code_id":9,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 1 |
    When Operator Filters the records in the "Invalid Failed Reservations" by applying the following filters:
      | Reservation ID      | Pickup Name | Contact   |
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} | <Name>      | <Contact> |
    And Operator selects the timeslot "9am - 6pm" in the table
    Then Operator verify value in the "Invalid Failed Reservations" table for the "RESERVATION_ID" column value is equal to "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "PICKUP_NAME" column value is equal to "<Name>"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "ADDRESS" column value is equal to "<Address>"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "TIME_SLOT" column value is equal to "9am - 6pm"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "CONTACT" column value is equal to "<Contact>"
    And Operator verifies that Shipper Pickup page is opened on clicking Reservation ID "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" table "Invalid Failed Reservations"

    Examples:
      | HubId       | HubName       | Name                        | Address                 | Contact                 |
      | {hub-id-15} | {hub-name-15} | {PA_shipper-v4-pickup-name} | {PA_shipper-v4-address} | {PA_shipper-v4-contact} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased @Debug
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending & Late PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased @Debug
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Success & Late PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    And API Operator success Pickup Appointment job
      | pa_Id | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased @Debug
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Failed & Late PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                   |
      | requestBody | {"status":"failed","failure_reason_id":63,"failure_reason_code_id":9,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased @Debug
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Success & Early PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    And API Operator success Pickup Appointment job
      | pa_Id | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased @Debug
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Failed & Early PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1275084}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator assigns Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                   |
      | requestBody | {"status":"failed","failure_reason_id":63,"failure_reason_code_id":9,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op