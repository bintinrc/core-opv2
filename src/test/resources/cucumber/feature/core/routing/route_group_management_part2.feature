@OperatorV2 @Core @Routing @RoutingJob1 @RouteGroupManagement @RouteGroupManagementPart2
Feature: Route Group Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroups
  Scenario: Clear Transaction of Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG8-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | PICKUP   |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator clear selected route groups on Route Group Management page:
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
    Then Operator verifies that success react notification displayed:
      | top | 1 Route Group(s) Cleared |
    And Operator verifies "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group was cleared on Route Group Management page

  @DeleteRouteGroups
  Scenario: Filter Route Groups Based on Creation Date
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Route Group:
      | name        | ARG9-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator apply filters on Route Group Management page:
      | fromDate | {gradle-current-date-yyyy-MM-dd} |
      | toDate   | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies route groups table is filtered by "^{gradle-current-date-yyyy-MM-dd}.*" date on Route Group Management page

  @DeleteRouteGroups
  Scenario: Download CSV File of Transactions of a Route Group
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG10-{gradle-current-date-yyyyMMddHHmmsss}                                                                  |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | PICKUP   |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator download jobs of "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group on Edit Route Group modal on Route Group Management page
    Then Operator verify route group jobs CSV file on Route Group Management page

  @DeleteRouteGroups
  Scenario: Delete Reservations From Route Group
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new Route Group:
      | name        | ARG11-{gradle-current-date-yyyyMMddHHmmsss}                                                                  |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add Reservation to Route Group with ID = "{KEY_CREATED_ROUTE_GROUP.id}"
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete transaction from route group:
      | name | {KEY_CREATED_ROUTE_GROUP.name} |
      | id   | {KEY_CREATED_RESERVATION_ID}   |
    Then Operator verifies that success react notification displayed:
      | top    | Id: {KEY_CREATED_ROUTE_GROUP.id} |
      | bottom | 1 Route Group Updated            |
    When Operator open Edit Rout Group dialog for "{KEY_CREATED_ROUTE_GROUP.name}" route group
    Then Operator verify there is no "{KEY_CREATED_RESERVATION_ID}" transaction in Edit Rout Group dialog
    And DB Route - verify route_groups_references record:
      | routeGroupId | {KEY_CREATED_ROUTE_GROUP.id} |
      | referenceId  | {KEY_CREATED_RESERVATION_ID} |
      | deletedAt    | not null                     |

  @DeleteRouteGroups
  Scenario: Clear Reservations of Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new Route Group:
      | name        | ARG12-{gradle-current-date-yyyyMMddHHmmsss}                                                                  |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add Reservation to Route Group with ID = "{KEY_CREATED_ROUTE_GROUP.id}"
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator clear selected route groups on Route Group Management page:
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
    Then Operator verifies that success react notification displayed:
      | top | 1 Route Group(s) Cleared |
    And Operator verifies "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group was cleared on Route Group Management page
    And DB Route - verify route_groups_references record:
      | routeGroupId | {KEY_CREATED_ROUTE_GROUP.id} |
      | referenceId  | {KEY_CREATED_RESERVATION_ID} |
      | deletedAt    | not null                     |

  @DeleteRouteGroups
  Scenario: Operator Deletes Route Group with Transaction & Reservation Assigned
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new Route Group:
      | name        | ARG13-{gradle-current-date-yyyyMMddHHmmsss}                                                                  |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
    And API Operator add Reservation to Route Group with ID = "{KEY_CREATED_ROUTE_GROUP.id}"
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete "{KEY_CREATED_ROUTE_GROUP.name}" route group on Route Group Management page
    Then Operator verifies that success react notification displayed:
      | top    | {KEY_CREATED_ROUTE_GROUP.name} |
      | bottom | 1 Route Group Deleted          |
    Then Operator verify "{KEY_CREATED_ROUTE_GROUP.name}" route group was deleted on Route Group Management page
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Route - verify route_groups record:
      | id        | {KEY_CREATED_ROUTE_GROUP.id} |
      | deletedAt | not null                     |
    And DB Route - verify route_groups_references record:
      | routeGroupId | {KEY_CREATED_ROUTE_GROUP.id} |
      | referenceId  | {KEY_CREATED_RESERVATION_ID} |
      | deletedAt    | not null                     |
    And DB Route - verify route_groups_references record:
      | routeGroupId | {KEY_CREATED_ROUTE_GROUP.id} |
      | referenceId  | {KEY_TRANSACTION.id}         |
      | deletedAt    | not null                     |

  #TODO will uncomment this scenario if first mile team has fix the PA job search endpoint
#  @DeleteRouteGroupsV2 @DeletePickupAppointmentJob
#  Scenario: Operator View Route Group with PA Job Tag
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Shipper - Operator create new shipper address using data below:
#      | shipperId       | {shipper-v4-paj-id} |
#      | generateAddress | RANDOM              |
#    When API Control - Operator create pickup appointment job with data below:
#      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
#    And DB Control - get pickup tag id for tag name = "{tag-name-1}"
#    When API Control - Operator add tags pickup appointment job with data below:
#      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id}        |
#      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
#    Given API Shipper - Operator create new shipper address using data below:
#      | shipperId       | {shipper-v4-paj-id} |
#      | generateAddress | RANDOM              |
#    When API Control - Operator create pickup appointment job with data below:
#      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[2].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
#    And DB Control - get pickup tag id for tag name = "{tag-name-2}"
#    When API Control - Operator add tags pickup appointment job with data below:
#      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[2].id}        |
#      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[2].id}]} |
#    When API Route - create route group:
#      | name        | ARG-{uniqueString}                                                                  |
#      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
#    When API Route - add references to Route Group:
#      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                                              |
#      | requestBody  | {"pickupAppointmentJobIds":[{KEY_CONTROL_CREATED_PA_JOBS[1].id},{KEY_CONTROL_CREATED_PA_JOBS[2].id}]} |
#    Given Operator go to menu Routing -> 2. Route Group Management
#    And Route Groups Management page is loaded
#    Then Operator verify route group on Route Groups Management page:
#      | name           | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
#      | noPaJobs       | 2                                          |
#      | noRoutedPaJobs | 0                                          |
#    When Operator open Edit Rout Group dialog for "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group
#    Then Operator verify job record in Edit Route Group modal on Route Group Management page:
#      | id      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
#      | type    | Pickup Appointment Job              |
#      | jobTags | {tag-name-1}                        |
#    Then Operator verify job record in Edit Route Group modal on Route Group Management page:
#      | id      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
#      | type    | Pickup Appointment Job              |
#      | jobTags | {tag-name-2}                        |
#    When Operator filter job records in Edit Route Group modal on Route Group Management page:
#      | jobTags | {tag-name-1} |
#    Then Operator verify only job records presented in Edit Route Group modal on Route Group Management page:
#      | jobTags      |
#      | {tag-name-1} |
#    When Operator filter job records in Edit Route Group modal on Route Group Management page:
#      | jobTags | {tag-name-2} |
#    Then Operator verify only job records presented in Edit Route Group modal on Route Group Management page:
#      | jobTags      |
#      | {tag-name-2} |
#    When Operator clear jobs table filters in Edit Route Group modal on Route Group Management page
#    Then Operator verify only job records presented in Edit Route Group modal on Route Group Management page:
#      | jobTags      |
#      | {tag-name-1} |
#      | {tag-name-2} |

  @DeleteRouteGroupsV2 @DeletePickupAppointmentJob
  Scenario: Operator Filters Total PA Job of Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[2].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    When API Route - create route group:
      | name        | ARG-{uniqueString}                                                                                           |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                                              |
      | requestBody  | {"pickupAppointmentJobIds":[{KEY_CONTROL_CREATED_PA_JOBS[1].id},{KEY_CONTROL_CREATED_PA_JOBS[2].id}]} |
    Given Operator go to menu Routing -> 2. Route Group Management
    And Route Groups Management page is loaded
    When Operator filter route groups table on Route Group Management page:
      | noPaJobs | 2 |
    Then Operator verify only route groups records presented on Route Group Management page:
      | noPaJobs |
      | ^\d*2\d* |

  @DeleteRouteGroupsV2 @DeletePickupAppointmentJob @DeleteRoutes
  Scenario: Operator Filters Total Routed PAJ of Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[2].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[2].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Route - create route group:
      | name        | ARG-{uniqueString}                                                                                           |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                                              |
      | requestBody  | {"pickupAppointmentJobIds":[{KEY_CONTROL_CREATED_PA_JOBS[1].id},{KEY_CONTROL_CREATED_PA_JOBS[2].id}]} |
    Given Operator go to menu Routing -> 2. Route Group Management
    And Route Groups Management page is loaded
    When Operator filter route groups table on Route Group Management page:
      | noRoutedPaJobs | 2 |
    Then Operator verify only route groups records presented on Route Group Management page:
      | noRoutedPaJobs |
      | ^\d*2\d*       |

  @DeleteRouteGroupsV2
  Scenario:Operator Filters Total Reservation of Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Route - create route group:
      | name        | ARG-{uniqueString}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                                               |
      | requestBody  | {"reservationIds":[{KEY_LIST_OF_CREATED_RESERVATIONS[1].id},{KEY_LIST_OF_CREATED_RESERVATIONS[2].id}]} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Route Groups Management page is loaded
    When Operator filter route groups table on Route Group Management page:
      | noReservations | 2 |
    Then Operator verify only route groups records presented on Route Group Management page:
      | noReservations |
      | ^\d*2\d*       |

  @DeleteRouteGroupsV2 @DeleteRoutes
  Scenario:Operator Filters Total Routed Reservation of Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When API Route - create route group:
      | name        | ARG-{uniqueString}                                                                |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                                               |
      | requestBody  | {"reservationIds":[{KEY_LIST_OF_CREATED_RESERVATIONS[1].id},{KEY_LIST_OF_CREATED_RESERVATIONS[2].id}]} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Route Groups Management page is loaded
    When Operator filter route groups table on Route Group Management page:
      | noRoutedReservations | 2 |
    Then Operator verify only route groups records presented on Route Group Management page:
      | noRoutedReservations |
      | ^\d*2\d*             |
