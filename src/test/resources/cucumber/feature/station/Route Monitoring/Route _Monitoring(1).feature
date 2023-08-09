@StationManagement @StationRouteMonitoringPart1
Feature: Route Monitoring V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Pending Waypoint - Reservation
    Given Operator loads Operator portal home page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending Reservation From Route
    Given Operator loads Operator portal home page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    When API Core - Operator remove reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" from route
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Delivery
    Given Operator loads Operator portal home page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Pickup
    Given Operator loads Operator portal home page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - Reservation
    Given Operator loads Operator portal home page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobType    | RESERVATION                                                                                                               |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Delivery - Valid Failed
    Given Operator loads Operator portal home page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 11                                                                                                                     |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Delivery - Invalid Failed
    Given Operator loads Operator portal home page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason          | Parcel Unattempted - Normal                                    |
      | Failure Reason Detail 1 | I had insufficient time to complete all my deliveries - Normal |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Pickup - Valid Failed
    Given Operator loads Operator portal home page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | PICK_UP                                                                                                                |
      | failureReasonId | 131                                                                                                                    |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Pickup - Invalid Failed
    Given Operator loads Operator portal home page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}"
      | Failure Reason          | I didn't attempt the pick up - Normal |
      | Failure Reason Detail 1 | Cannot Make It (CMI) - Normal         |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Reservation - Valid Fail
    Given Operator loads Operator portal home page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP","cash_on_delivery": 100, "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{date: 0 days next, YYYY-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, YYYY-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                 |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                   |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                  |
      | jobType         | RESERVATION                                                                        |
      | jobAction       | FAIL                                                                               |
      | jobMode         | PICK_UP                                                                            |
      | failureReasonId | 121                                                                                |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Failed Waypoint - Reservation - Invalid Fail
    Given Operator loads Operator portal home page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP","cash_on_delivery": 100, "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{date: 0 days next, YYYY-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, YYYY-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                 |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                   |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                  |
      | jobType         | RESERVATION                                                                        |
      | jobAction       | FAIL                                                                               |
      | jobMode         | PICK_UP                                                                            |
      | failureReasonId | 63                                                                                 |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       | failureReasonCodeId |
      | {hub-id-15} | {hub-name-15} | 112                 |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed on NON-Failed Waypoints
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
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

  @@ForceSuccessOrder @ArchiveRouteCommonV2 @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Reservation
    Given Operator loads Operator portal home page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP","cash_on_delivery": 100, "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{date: 0 days next, YYYY-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, YYYY-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                 |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                   |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                  |
      | jobType         | RESERVATION                                                                        |
      | jobAction       | FAIL                                                                               |
      | jobMode         | PICK_UP                                                                            |
      | failureReasonId | 63                                                                                 |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 1 |
    When Operator Filters the records in the "Invalid Failed Reservations" by applying the following filters:
      | Reservation ID                           | Pickup Name   |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {pickup-name} |
    #      | Reservation ID               | Pickup Name        | Address               | Contact              |
    #      | {KEY_CREATED_RESERVATION_ID} | {KEY_SHIPPER_NAME} | {KEY_SHIPPER_ADDRESS} | {KEY_SHIPPER_CONTACT} |
    And Operator selects the timeslot "3pm - 6pm" in the table
    Then Operator verify value in the "Invalid Failed Reservations" table for the "RESERVATION_ID" column value is equal to "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "PICKUP_NAME" column value is equal to "{pickup-name}"
    #    Then Operator verify value in the "Invalid Failed Reservations" table for the "ADDRESS" column value is equal to "{KEY_SHIPPER_ADDRESS}"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "TIME_SLOT" column value is equal to "3pm - 6pm"
    #    Then Operator verify value in the "Invalid Failed Reservations" table for the "CONTACT" column contains "{KEY_SHIPPER_CONTACT}"
    And Operator verifies that Shipper Pickup page is opened on clicking Reservation ID "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" table "Invalid Failed Reservations"

    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op