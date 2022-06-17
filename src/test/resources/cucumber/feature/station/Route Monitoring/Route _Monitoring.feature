@StationManagement @StationRouteMonitoring
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
    And Operator enters routeID in the Route filter
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
    And Operator enters routeID in the Route filter
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
    And Operator enters routeID in the Route filter
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
    And Operator enters routeID in the Route filter
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
    And Operator enters routeID in the Route filter
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
    And Operator enters routeID in the Route filter
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
    And Operator enters routeID in the Route filter
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
    And Operator enters routeID in the Route filter
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
    And Operator fail waypoint from Route Manifest page with following details
      | Failure Reason          | Failure due to customer/shipper - Normal                  |
      | Failure Reason Detail 1 | Address is correct but customer is not available - Normal |
      | Failure Reason Detail 2 | Residential address, but no one to receive - Normal       |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID in the Route filter
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
    And Operator fail waypoint from Route Manifest page with following details
      | Failure Reason          | Parcel Unattempted - Normal                                    |
      | Failure Reason Detail 1 | I had insufficient time to complete all my deliveries - Normal |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID in the Route filter
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
    And Operator fail waypoint from Route Manifest page with following details
      | Failure Reason | No parcels to pick up at all - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID in the Route filter
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
    And Operator fail waypoint from Route Manifest page with following details
      | Failure Reason | Cannot Make It (CMI) - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID in the Route filter
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
    And Operator fails reservation with failure Reason
      | Failure Reason | No parcels to pick up at all - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID in the Route filter
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
    And Operator fails reservation with failure Reason
      | Failure Reason | Cannot Make It (CMI) - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID in the Route filter
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
    And Operator enters routeID in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies Invalid Failed WP pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    Then Operator verifies Invalid Failed WP pop up modal is showing No Results Found
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
    And Operator fails reservation with failure Reason
      | Failure Reason | Cannot Make It (CMI) - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies Invalid Failed WP pop up modal is showing correct total parcels
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
    Then Operator verify value in the "Invalid Failed Reservations" table for the "ADDRESS" column value is equal to "{KEY_SHIPPER_ADDRESS}"
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
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And Operator fail waypoint from Route Manifest page with following details
      | Failure Reason | Cannot Make It (CMI) - ODP |
    And Operator fail waypoint from Route Manifest page with following details
      | Failure Reason | Cannot Make It (CMI) - ODP |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 2
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies Invalid Failed WP pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 2 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    When Operator Filters the records in the "Invalid Failed Pickups" by applying the following filters:
      | Reservation ID                  | Pickup Name        |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_SHIPPER_NAME} |
    And Operator selects the timeslot "3pm - 6pm" in the table
    Then Operator verify value in the "Invalid Failed Pickups" table for the Tags column value is equal to "PRIOR"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "RESERVATION_ID" column value is equal to "{KEY_CREATED_ORDER_TRACKING_ID}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "PICKUP_NAME" column value is equal to "{KEY_SHIPPER_NAME}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "ADDRESS" column value is equal to "{KEY_SHIPPER_ADDRESS}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "TIME_SLOT" column value is equal to "3pm - 6pm"
    And Operator verifies that Edit Order page is opened on clicking tracking id in table "Invalid Failed Pickups"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op