@OperatorV2 @Core @Routing @MaskRouteManifestInfo
Feature: Mask Route Manifest Info

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @MediumPriority
  Scenario: Operator View Mask Order for Normal Delivery on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{to-address}} |
    When API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                                                                 |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                              |
      | contact     | Click to reveal (tracked)4435                                                           |
      | address     | Click to reveal (tracked)D MANDAI SQUARE 116 Click to reveal (tracked)g Timur 308412 SG |
    When Operator reveals masked information
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                                   |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | contact     | +9727894435                                               |
      | address     | 49 MANDALAY ROAD MANDAI SQUARE 116 Kilang Timur 308412 SG |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario: Operator View Mask Order for DP Delivery on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{to-address}} |
    When API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{dp-id-2},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                                                        |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | contact     | Click to reveal (tracked)4435                                                  |
      | address     | Click to reveal (tracked)AD, SG, 238880 Click to reveal (tracked) SG 238880 SG |
    When Operator reveals masked information
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                        |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}     |
      | contact     | +9727894435                                    |
      | address     | 501, ORCHARD ROAD, SG, 238880 3-4 SG 238880 SG |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario: Operator View Mask Order for Return Pickup on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{to-address}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                                              |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                           |
      | contact     | Click to reveal (tracked)4434                                        |
      | address     | Click to reveal (tracked) Click to reveal (tracked)g Barat 308402 SG |
    When Operator reveals masked information
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                    |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | contact     | +9727894434                                |
      | address     | Keng Lee Rd Kilang Barat 308402 SG         |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario: Operator View Unmask Order for Reservation on Route Manifest
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verify waypoint at Route Manifest using data below:
      | status  | Pending                                                                                                                                                                        |
      | address | {KEY_LIST_OF_CREATED_ADDRESSES[1].address1} {KEY_LIST_OF_CREATED_ADDRESSES[1].address2} {KEY_LIST_OF_CREATED_ADDRESSES[1].postcode} {KEY_LIST_OF_CREATED_ADDRESSES[1].country} |

  @deletePickupJob @ArchiveRouteCommonV2 @DeleteOrArchiveRoute @MediumPriority
  Scenario: Operator View Unmask Order for PA Job on Route Manifest
    Given API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-paj-id}      |
      | addressId | {shipper-address-paj-id} |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId":{shipper-address-paj-id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verify waypoint at Route Manifest using data below:
      | status  | Pending                                                                                                                                                                        |
      | address | {KEY_LIST_OF_CREATED_ADDRESSES[1].address1} {KEY_LIST_OF_CREATED_ADDRESSES[1].address2} {KEY_LIST_OF_CREATED_ADDRESSES[1].postcode} {KEY_LIST_OF_CREATED_ADDRESSES[1].country} |
