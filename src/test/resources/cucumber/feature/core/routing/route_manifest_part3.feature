@OperatorV2 @Core @Routing @RoutingJob1 @RouteManifest @RouteManifestPart3
Feature: Route Manifest

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator View POP for Pending Reservation on Route Manifest
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}" waypoint details on Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | waypointStatus  | Pending                                          |
      | highestPriority | NP                                               |
      | serviceTypes    | Reservation                                      |
      | addressee       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].name}       |
      | contact         | -                                                |
      | recipient       | -                                                |
      | relationship    | -                                                |
    And Operator verify reservation record in Waypoint Details dialog on Route Manifest page:
      | id            | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}           |
      | status        | Pending                                            |
      | expectedNo    | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} |
      | collectedNo   | 0                                                  |
      | failureReason | -                                                  |
    And Operator verify 'View POP' button is disabled for "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" reservation in Waypoint Details dialog on Route Manifest page

  @HighPriority
  Scenario: Operator View POP for Success Reservation on Route Manifest
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                    |
      | jobType    | RESERVATION                                                                                                          |
      | jobAction  | SUCCESS                                                                                                              |
      | jobMode    | PICK_UP                                                                                                              |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}" waypoint details on Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | waypointStatus  | Success                                          |
      | highestPriority | NP                                               |
      | serviceTypes    | Reservation                                      |
      | addressee       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].name}       |
      | contact         | -                                                |
      | recipient       | -                                                |
      | relationship    | -                                                |
    And Operator verify reservation record in Waypoint Details dialog on Route Manifest page:
      | id            | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}           |
      | status        | Success                                            |
      | expectedNo    | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} |
      | collectedNo   | 1                                                  |
      | failureReason | -                                                  |
    And Operator click 'View POP' button for "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" reservation in Waypoint Details dialog on Route Manifest page
    Then Operator verify POP details on Route Manifest page:
      | reservationId  | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}      |
      | shipper        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].name}    |
      | phone          | {KEY_LIST_OF_CREATED_RESERVATIONS[1].contact} |
      | status         | Success                                       |
      | pickupQuantity | 1                                             |
      | trackingIds    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}         |
    And Operator is able to download signature in POP details dialog on Route Manifest page

  @HighPriority
  Scenario: Operator View POP for Fail Reservation on Route Manifest
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                  |
      | routes          | KEY_DRIVER_ROUTES                                                                                                 |
      | jobType         | RESERVATION                                                                                                       |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | jobAction       | FAIL                                                                                                              |
      | jobMode         | PICK_UP                                                                                                           |
      | failureReasonId | 112                                                                                                               |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}" waypoint details on Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | waypointStatus  | Fail                                             |
      | highestPriority | NP                                               |
      | serviceTypes    | Reservation                                      |
      | addressee       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].name}       |
      | contact         | -                                                |
      | recipient       | -                                                |
      | relationship    | -                                                |
    And Operator verify reservation record in Waypoint Details dialog on Route Manifest page:
      | id            | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}           |
      | status        | Fail                                               |
      | expectedNo    | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} |
      | collectedNo   | 1                                                  |
      | failureReason | 9, Cannot Make It (CMI)                            |
    And Operator click 'View POP' button for "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}" reservation in Waypoint Details dialog on Route Manifest page
    Then Operator verify POP details on Route Manifest page:
      | reservationId  | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}      |
      | shipper        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].name}    |
      | phone          | {KEY_LIST_OF_CREATED_RESERVATIONS[1].contact} |
      | status         | Fail                                          |
      | pickupQuantity | 1                                             |
      | trackingIds    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}         |
    And Operator is able to download signature in POP details dialog on Route Manifest page

  @MediumPriority
  Scenario: Operator View POP for Pending Pickup Appointment Job on Route Manifest
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And DB Route - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_WAYPOINT_ID}" waypoint details on Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_WAYPOINT_ID}                        |
      | waypointStatus  | Pending                                  |
      | highestPriority | NP                                       |
      | serviceTypes    | Pickup appointment job                   |
      | addressee       | {KEY_CONTROL_CREATED_PA_JOBS[1].name}    |
      | contact         | {KEY_CONTROL_CREATED_PA_JOBS[1].contact} |
      | recipient       | -                                        |
      | relationship    | -                                        |
    And Operator verify pickup appointment job record in Waypoint Details dialog on Route Manifest page:
      | id            | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                 |
      | status        | Pending                                             |
      | expectedNo    | {KEY_CONTROL_CREATED_PA_JOBS[1].pickupApproxVolume} |
      | collectedNo   | 0                                                   |
      | failureReason | -                                                   |
    And Operator verify 'View POP' button is disabled for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" pickup appointment job in Waypoint Details dialog on Route Manifest page

  @HighPriority
  Scenario: Operator View POP for Success Pickup Appointment Job on Route Manifest
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And DB Route - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                               |
      | waypointId | {KEY_WAYPOINT_ID}                                                                |
      | routes     | KEY_DRIVER_ROUTES                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS"}] |
      | jobType    | PICKUP_APPOINTMENT                                                               |
      | jobAction  | SUCCESS                                                                          |
      | jobMode    | PICK_UP                                                                          |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_WAYPOINT_ID}" waypoint details on Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_WAYPOINT_ID}                        |
      | waypointStatus  | Success                                  |
      | highestPriority | NP                                       |
      | serviceTypes    | Pickup appointment job                   |
      | addressee       | {KEY_CONTROL_CREATED_PA_JOBS[1].name}    |
      | contact         | {KEY_CONTROL_CREATED_PA_JOBS[1].contact} |
      | recipient       | -                                        |
      | relationship    | -                                        |
    And Operator verify pickup appointment job record in Waypoint Details dialog on Route Manifest page:
      | id            | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                 |
      | status        | Success                                             |
      | expectedNo    | {KEY_CONTROL_CREATED_PA_JOBS[1].pickupApproxVolume} |
      | collectedNo   | 1                                                   |
      | failureReason | -                                                   |
    And Operator click 'View POP' button for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" reservation in Waypoint Details dialog on Route Manifest page
    Then Operator verify POP details on Route Manifest page:
      | pickupAppointmentJobId | {KEY_CONTROL_CREATED_PA_JOBS[1].id}      |
      | shipper                | {KEY_CONTROL_CREATED_PA_JOBS[1].name}    |
      | phone                  | {KEY_CONTROL_CREATED_PA_JOBS[1].contact} |
      | status                 | Success                                  |
      | pickupQuantity         | 1                                        |
      | trackingIds            | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}    |
    And Operator is able to download signature in POP details dialog on Route Manifest page

  @HighPriority
  Scenario: Operator View POP for Fail Pickup Appointment Job on Route Manifest
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And DB Route - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                            |
      | waypointId      | {KEY_WAYPOINT_ID}                                                             |
      | routes          | KEY_DRIVER_ROUTES                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "FAIL"}] |
      | jobType         | PICKUP_APPOINTMENT                                                            |
      | jobAction       | FAIL                                                                          |
      | jobMode         | PICK_UP                                                                       |
      | failureReasonId | 112                                                                           |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_WAYPOINT_ID}" waypoint details on Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_WAYPOINT_ID}                        |
      | waypointStatus  | Fail                                     |
      | highestPriority | NP                                       |
      | serviceTypes    | Pickup appointment job                   |
      | addressee       | {KEY_CONTROL_CREATED_PA_JOBS[1].name}    |
      | contact         | {KEY_CONTROL_CREATED_PA_JOBS[1].contact} |
      | recipient       | -                                        |
      | relationship    | -                                        |
    And Operator verify pickup appointment job record in Waypoint Details dialog on Route Manifest page:
      | id            | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                 |
      | status        | Fail                                                |
      | expectedNo    | {KEY_CONTROL_CREATED_PA_JOBS[1].pickupApproxVolume} |
      | collectedNo   | 1                                                   |
      | failureReason | 9, Cannot Make It (CMI)                             |
    And Operator click 'View POP' button for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" reservation in Waypoint Details dialog on Route Manifest page
    Then Operator verify POP details on Route Manifest page:
      | pickupAppointmentJobId | {KEY_CONTROL_CREATED_PA_JOBS[1].id}      |
      | shipper                | {KEY_CONTROL_CREATED_PA_JOBS[1].name}    |
      | phone                  | {KEY_CONTROL_CREATED_PA_JOBS[1].contact} |
      | status                 | Fail                                     |
      | pickupQuantity         | 1                                        |
      | trackingIds            | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}    |
    And Operator is able to download signature in POP details dialog on Route Manifest page

  @MediumPriority
  Scenario: Operator View POP for Pending Return Pickup on Route Manifest
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}" waypoint details on Route Manifest page
    And Operator unmask Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | waypointStatus  | Pending                                                    |
      | highestPriority | NP                                                         |
      | serviceTypes    | Pickup                                                     |
      | addressee       | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                   |
      | contact         | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}                |
      | recipient       | -                                                          |
      | relationship    | -                                                          |
    And Operator verify pickup record in Waypoint Details dialog on Route Manifest page:
      | trackingId    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status        | Pending                               |
      | failureReason | -                                     |
    And Operator verify 'View POP' button is disabled for "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" pickup in Waypoint Details dialog on Route Manifest page

  @HighPriority
  Scenario: Operator View POP for Success Return Pickup on Route Manifest
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                      |
      | routes     | KEY_DRIVER_ROUTES                                                               |
      | jobType    | TRANSACTION                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS"}] |
      | jobAction  | SUCCESS                                                                         |
      | jobMode    | PICK_UP                                                                         |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}" waypoint details on Route Manifest page
    And Operator unmask Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | waypointStatus  | Success                                                    |
      | highestPriority | NP                                                         |
      | serviceTypes    | Pickup                                                     |
      | addressee       | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                   |
      | contact         | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}                |
      | recipient       | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                   |
      | relationship    | -                                                          |
    And Operator verify pickup record in Waypoint Details dialog on Route Manifest page:
      | trackingId    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status        | Success                               |
      | failureReason | -                                     |
    And Operator click 'View POP' button for "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" pickup in Waypoint Details dialog on Route Manifest page
    Then Operator verify POP details on Route Manifest page:
      | trackingId      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}       |
      | phone           | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact} |
      | email           | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}   |
      | status          | Success                                     |
      | receivedFrom    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}    |
      | relationship    | -                                           |
      | receiptDateTime | {gradle-current-date-yyyy-MM-dd}            |
      | pickupQuantity  | 1                                           |
    And Operator is able to download signature in POP details dialog on Route Manifest page

  @HighPriority
  Scenario: Operator View POP for Fail Return Pickup on Route Manifest
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                            |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                    |
      | routes          | KEY_DRIVER_ROUTES                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "FAIL"}] |
      | jobType         | TRANSACTION                                                                   |
      | jobAction       | FAIL                                                                          |
      | jobMode         | PICK_UP                                                                       |
      | failureReasonId | 112                                                                           |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}" waypoint details on Route Manifest page
    And Operator unmask Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | waypointStatus  | Fail                                                       |
      | highestPriority | NP                                                         |
      | serviceTypes    | Pickup                                                     |
      | addressee       | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                   |
      | contact         | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}                |
      | recipient       | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                   |
      | relationship    | -                                                          |
    And Operator verify pickup record in Waypoint Details dialog on Route Manifest page:
      | trackingId    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status        | Fail                                  |
      | failureReason | 9, Cannot Make It (CMI)               |
    And Operator click 'View POP' button for "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" pickup in Waypoint Details dialog on Route Manifest page
    Then Operator verify POP details on Route Manifest page:
      | trackingId      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}       |
      | phone           | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact} |
      | email           | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}   |
      | status          | Fail                                        |
      | receivedFrom    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}    |
      | relationship    | -                                           |
      | receiptDateTime | {gradle-current-date-yyyy-MM-dd}            |
      | pickupQuantity  | 1                                           |
    And Operator is able to download signature in POP details dialog on Route Manifest page

  @MediumPriority
  Scenario: Operator View POD for Pending Normal Delivery on Route Manifest
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}" waypoint details on Route Manifest page
    And Operator unmask Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | waypointStatus  | Pending                                                    |
      | highestPriority | NP                                                         |
      | serviceTypes    | Delivery                                                   |
      | addressee       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}                     |
      | contact         | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}                  |
      | recipient       | -                                                          |
      | relationship    | -                                                          |
    And Operator verify delivery record in Waypoint Details dialog on Route Manifest page:
      | trackingId    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status        | Pending                               |
      | codCollected  | No COD                                |
      | failureReason | -                                     |
    And Operator verify 'View POD' button is disabled for "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" delivery in Waypoint Details dialog on Route Manifest page

  @HighPriority
  Scenario: Operator View POD for Success Normal Delivery on Route Manifest
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
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

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}" waypoint details on Route Manifest page
    And Operator unmask Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | waypointStatus  | Success                                                    |
      | highestPriority | NP                                                         |
      | serviceTypes    | Delivery                                                   |
      | addressee       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}                     |
      | contact         | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}                  |
      | recipient       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}                     |
      | relationship    | -                                                          |
    And Operator verify delivery record in Waypoint Details dialog on Route Manifest page:
      | trackingId    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status        | Success                               |
      | codCollected  | No COD                                |
      | failureReason | -                                     |
    And Operator click 'View POD' button for "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" delivery in Waypoint Details dialog on Route Manifest page
    Then Operator verify POD details on Route Manifest page:
      | trackingId       | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}     |
      | phone            | {KEY_LIST_OF_CREATED_ORDERS[1].toContact} |
      | email            | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}   |
      | status           | Success                                   |
      | receivedBy       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}    |
      | relationship     | -                                         |
      | code             | -                                         |
      | hiddenLocation   | -                                         |
      | receiptDateTime  | {gradle-current-date-yyyy-MM-dd}          |
      | deliveryQuantity | 1                                         |
    And Operator is able to download signature in POD details dialog on Route Manifest page

  @HighPriority
  Scenario: Operator View POD for Success Normal Delivery with COD on Route Manifest
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":3000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                          |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                  |
      | routes     | KEY_DRIVER_ROUTES                                                                           |
      | jobType    | TRANSACTION                                                                                 |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS", "cod":3000}] |
      | jobAction  | SUCCESS                                                                                     |
      | jobMode    | DELIVERY                                                                                    |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}" waypoint details on Route Manifest page
    And Operator unmask Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | waypointStatus  | Success                                                    |
      | highestPriority | NP                                                         |
      | serviceTypes    | Delivery                                                   |
      | addressee       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}                     |
      | contact         | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}                  |
      | recipient       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}                     |
      | relationship    | -                                                          |
    And Operator verify delivery record in Waypoint Details dialog on Route Manifest page:
      | trackingId    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status        | Success                               |
      | codCollected  | 3000 of 3000                          |
      | failureReason | -                                     |
    And Operator click 'View POD' button for "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" delivery in Waypoint Details dialog on Route Manifest page
    Then Operator verify POD details on Route Manifest page:
      | trackingId       | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}     |
      | phone            | {KEY_LIST_OF_CREATED_ORDERS[1].toContact} |
      | email            | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}   |
      | status           | Success                                   |
      | receivedBy       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}    |
      | relationship     | -                                         |
      | code             | -                                         |
      | hiddenLocation   | -                                         |
      | receiptDateTime  | {gradle-current-date-yyyy-MM-dd}          |
      | deliveryQuantity | 1                                         |
    And Operator is able to download signature in POD details dialog on Route Manifest page

  @HighPriority
  Scenario: Operator View POD for Fail Normal Delivery on Route Manifest
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                            |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                    |
      | routes          | KEY_DRIVER_ROUTES                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "FAIL"}] |
      | jobType         | TRANSACTION                                                                   |
      | jobAction       | FAIL                                                                          |
      | jobMode         | DELIVERY                                                                      |
      | failureReasonId | 112                                                                           |

    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}" waypoint details on Route Manifest page
    And Operator unmask Route Manifest page
    Then Operator verify waypoint details on Route Manifest page:
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | waypointStatus  | Fail                                                       |
      | highestPriority | NP                                                         |
      | serviceTypes    | Delivery                                                   |
      | addressee       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}                     |
      | contact         | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}                  |
      | recipient       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}                     |
      | relationship    | -                                                          |
    And Operator verify delivery record in Waypoint Details dialog on Route Manifest page:
      | trackingId    | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status        | Fail                               |
      | codCollected  | No COD                                |
      | failureReason | 9, Cannot Make It (CMI)               |
    And Operator click 'View POD' button for "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" delivery in Waypoint Details dialog on Route Manifest page
    Then Operator verify POD details on Route Manifest page:
      | trackingId       | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}     |
      | phone            | {KEY_LIST_OF_CREATED_ORDERS[1].toContact} |
      | email            | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}   |
      | status           | Fail                                      |
      | receivedBy       | {KEY_LIST_OF_CREATED_ORDERS[1].toName}    |
      | relationship     | -                                         |
      | code             | -                                         |
      | hiddenLocation   | -                                         |
      | receiptDateTime  | {gradle-current-date-yyyy-MM-dd}          |
      | deliveryQuantity | 1                                         |
    And Operator is able to download signature in POD details dialog on Route Manifest page
