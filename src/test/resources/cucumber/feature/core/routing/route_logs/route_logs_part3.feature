@OperatorV2 @Core @Routing @RouteLogs @RouteLogsPart3
Feature: Route Logs

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @CloseNewWindows @HighPriority
  Scenario: Operator Redirected to Route Manifest from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest V2 page of route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" from Route Logs page
    Then Operator verifies route details on Route Manifest page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2 @DeletePickupAppointmentJob @HighPriority
  Scenario: Operator Print Multiple Routes Details With Multiple Waypoints from Route Logs Page
    # RETURN & NORMAL ORDER
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    # RESERVATION
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {shipper-v4-id}                                                                                                                                                                                                                                                                |
      | generateAddress       | RANDOM                                                                                                                                                                                                                                                                         |
      | shipperAddressRequest | {"name":"{shipper-v4-name}","contact":"{shipper-v4-contact}","email":"{shipper-v4-email}","address1":"address1","address2":"address2","country":"SG","latitude":1.27,"longitude":103.27,"postcode":"159363","milkrun_settings":[],"no_of_reservation":1}],"is_milk_run":false} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    # PICKUP APPOINTMENT JOB
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-paj-id}      |
      | addressId | {shipper-address-paj-id} |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId":{shipper-address-paj-id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{date: 0 days next, yyyy-MM-dd}T09:00:00+08:00","latest":"{date: 0 days next, yyyy-MM-dd}T18:00:00+08:00"}} |
    # ADD TO ROUTES
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator print created routes:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that success react notification displayed:
      | top | Downloaded file route_printout.pdf... |
    And Operator verifies created routes are printed successfully

  @ArchiveRouteCommonV2 @DeletePickupAppointmentJob @HighPriority
  Scenario: Operator Delete Routes with Reservation & PA Job on Route Logs
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    # RESERVATION
    And API Shipper - Operator create new shipper address using data below:
      | shipperId             | {shipper-v4-id}                                                                                                                                                                                                                                                                |
      | generateAddress       | RANDOM                                                                                                                                                                                                                                                                         |
      | shipperAddressRequest | {"name":"{shipper-v4-name}","contact":"{shipper-v4-contact}","email":"{shipper-v4-email}","address1":"address1","address2":"address2","country":"SG","latitude":1.27,"longitude":103.27,"postcode":"159363","milkrun_settings":[],"no_of_reservation":1}],"is_milk_run":false} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    # PICKUP APPOINTMENT JOB
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[2].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator deletes created route id "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top    | 1 Route(s) Deleted                       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify routes are deleted successfully:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify route_logs record:
      | legacyId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | deletedAt | not null                           |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | seqNo    | null                                             |
      | routeId  | null                                             |
    And DB Core - verify shipper_pickup_search record:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | null                                     |
    And DB Events - verify pickup_events record:
      | pickupId   | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}        |
      | userId     | 397                                             |
      | userName   | AUTOMATION EDITED                               |
      | userEmail  | qa@ninjavan.co                                  |
      | type       | 3                                               |
      | pickupType | 1                                               |
      | data       | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}} |
    And DB Events - verify pickup_events record:
      | pickupId   | {KEY_CONTROL_CREATED_PA_JOBS[1].id}             |
      | userId     | 397                                             |
      | userName   | AUTOMATION EDITED                               |
      | userEmail  | qa@ninjavan.co                                  |
      | type       | 3                                               |
      | pickupType | 2                                               |
      | data       | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}} |
