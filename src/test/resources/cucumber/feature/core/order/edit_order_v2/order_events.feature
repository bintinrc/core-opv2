@OperatorV2 @Core @EditOrderV2 @OrderEvents
Feature: Order Events

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Hub Inbound Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | HUB INBOUND SCAN |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Add to Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Driver Inbound Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | On Vehicle for Delivery |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | DRIVER INBOUND SCAN |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Delivery Success
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                      |
      | routes     | KEY_DRIVER_ROUTES                                                               |
      | jobType    | TRANSACTION                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                         |
      | jobMode    | DELIVERY                                                                        |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Completed |
      | granularStatus | Completed |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | SUCCESS                            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DELIVERY SUCCESS                   |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Delivery Failure
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DELIVERY FAILURE                   |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Pickup Failure
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pickup fail |
      | granularStatus | Pickup fail |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PICKUP FAILURE                     |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Pull Out of Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> Pull from Route on Edit Order V2 page
    And Operator pull out parcel from route on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top                | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} has been pulled from route {KEY_LIST_OF_CREATED_ROUTES[1].id} successfully |
      | waitUntilInvisible | true                                                                                                             |
    Then Operator verify order event on Edit Order V2 page using data below:
      | name | PULL OUT OF ROUTE |

  @HighPriority
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Assigned to DP
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator tags order to "{dpms-id}" DP on Edit Order V2 page
    Then Operator verify order event on Edit Order V2 page using data below:
      | name | ASSIGNED TO DP |

  @HighPriority
  Scenario: Edit Order Event Table Showing Correctly for Order Event - Added to Reservation
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - get reservation id from order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name        | ADDED TO RESERVATION                             |
      | description | Reservation ID: {KEY_LIST_OF_RESERVATION_IDS[1]} |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Applies Filter on Events Table
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And DB Core - get reservation id from order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_RESERVATION_IDS[1]}   |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                         |
      | fetchBy      | FETCH_BY_ROUTE_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on Route Inbound page
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator tags order to "{dpms-id}" DP on Edit Order V2 page
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order V2 page
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnPickup | yes    |
      | amount       | 100.00 |
    Then Operator verifies that success react notification displayed:
      | top                | Update cash collection successfully |
      | waitUntilInvisible | true                                |
    And Operator update order status on Edit Order V2 page:
      | granularStatus | Pending Pickup                      |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success react notification displayed:
      | top                | Status updated |
      | waitUntilInvisible | true           |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator click Delivery -> Pull from Route on Edit Order V2 page
    And Operator pull out parcel from route on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top                | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} has been pulled from route {KEY_LIST_OF_CREATED_ROUTES[1].id} successfully |
      | waitUntilInvisible | true                                                                                                             |
    And Operator click Order Settings -> Manually Complete Order on Edit Order V2 page
    And Operator confirm manually complete order on Edit Order V2 page:
      | reason          | Others (fill in below)                                |
      | reasonForChange | Completed by AT {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that success react notification displayed:
      | top                | The order has been completed |
      | waitUntilInvisible | true                         |
    When Operator selects "All events" in Events Filter menu on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | tags               | name                 |
      | SYSTEM ACTION      | PRICING CHANGE       |
      | MANUAL ACTION      | FORCED SUCCESS       |
      | COD, MANUAL ACTION | UPDATE CASH          |
      | MANUAL ACTION      | PULL OUT OF ROUTE    |
      | MANUAL ACTION      | UPDATE STATUS        |
      | MANUAL ACTION      | ADD TO ROUTE         |
      | MANUAL ACTION      | UPDATE ADDRESS       |
      | DP                 | ASSIGNED TO DP       |
      | SCAN, DELIVERY     | ROUTE INBOUND SCAN   |
      | SCAN, DELIVERY     | DRIVER INBOUND SCAN  |
      | SORT, SCAN         | HUB INBOUND SCAN     |
      | PICKUP             | ADDED TO RESERVATION |
    When Operator selects "System action only" in Events Filter menu on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | tags          | name           |
      | SYSTEM ACTION | PRICING CHANGE |
    When Operator selects "Manual action only" in Events Filter menu on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | tags               | name              |
      | MANUAL ACTION      | FORCED SUCCESS    |
      | COD, MANUAL ACTION | UPDATE CASH       |
      | MANUAL ACTION      | PULL OUT OF ROUTE |
      | MANUAL ACTION      | UPDATE STATUS     |
      | MANUAL ACTION      | ADD TO ROUTE      |
      | MANUAL ACTION      | UPDATE ADDRESS    |
    When Operator selects "Scans only" in Events Filter menu on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | tags           | name                |
      | SORT, SCAN     | HUB INBOUND SCAN    |
      | SCAN, DELIVERY | DRIVER INBOUND SCAN |
      | SCAN, DELIVERY | ROUTE INBOUND SCAN  |
    When Operator selects "Pickups only" in Events Filter menu on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | tags   | name                 |
      | PICKUP | ADDED TO RESERVATION |
    When Operator selects "Sorts only" in Events Filter menu on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | tags       | name             |
      | SORT, SCAN | HUB INBOUND SCAN |
    When Operator selects "Deliveries only" in Events Filter menu on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | tags           | name                |
      | SCAN, DELIVERY | DRIVER INBOUND SCAN |
      | SCAN, DELIVERY | ROUTE INBOUND SCAN  |
    When Operator selects "CODs only" in Events Filter menu on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | tags               | name        |
      | COD, MANUAL ACTION | UPDATE CASH |
    When Operator selects "DPs only" in Events Filter menu on Edit Order V2 page
    Then Operator verify order events on Edit Order V2 page using data below:
      | tags | name           |
      | DP   | ASSIGNED TO DP |
