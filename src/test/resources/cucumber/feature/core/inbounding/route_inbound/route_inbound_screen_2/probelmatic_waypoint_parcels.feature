@OperatorV2 @Core @Inbounding @RouteInbound @ProblematicWaypoints
Feature: Problematic Waypoints/Parcels

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: View Problematic Parcels (uid:d3e91af7-2cac-416f-8194-ecb28e289859)
    Given Operator go to menu Shipper Support -> Blocked Dates
    # Create 1st order - Return
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    # Create 2nd order - Parcel
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    # Create 3rd order - Parcel
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    # Create 4th order - Return
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator start the route
    And API Driver failed the C2C/Return order pickup using data below:
      | orderNumber            | 1           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    Then API Operator wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | PICKUP_FAIL                                |
      | granularStatus | PICKUP_FAIL                                |
    And API Driver failed the delivery of the created parcel using data below:
      | orderNumber            | 2           |
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    Then API Operator wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | status         | DELIVERY_FAIL                              |
      | granularStatus | PENDING_RESCHEDULE                         |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | driverName  | {ninja-driver-name}               |
      | hubName     | {hub-name}                        |
      | routeDate   | GET_FROM_CREATED_ROUTE            |
      | wpPending   | 2                                 |
      | wpPartial   | 0                                 |
      | wpFailed    | 2                                 |
      | wpCompleted | 0                                 |
      | wpTotal     | 4                                 |
    And Operator verifies that Problematic Parcels table exactly contains records:
      | trackingId                                 | shipperName       | location                                              | type              | issue                                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildFromAddressString} | Pick Up (Return)  | Cannot Make It (CMI)                                  |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString}   | Delivery (Normal) | I had insufficient time to complete all my deliveries |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString}   | Delivery (Normal) | Pending                                               |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildFromAddressString} | Pick Up (Return)  | Pending                                               |

  @DeleteOrArchiveRoute
  Scenario: View Problematic Waypoints (uid:cc9a6c2b-62a8-4c7b-a7bd-666100e85223)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | driverName  | {ninja-driver-name}               |
      | hubName     | {hub-name}                        |
      | routeDate   | GET_FROM_CREATED_ROUTE            |
      | wpPending   | 1                                 |
      | wpPartial   | 0                                 |
      | wpFailed    | 1                                 |
      | wpCompleted | 0                                 |
      | wpTotal     | 2                                 |
    And Operator verifies that Problematic Waypoints table exactly contains records:
      | shipperName       | location                                                            | type                  | issue                |
      | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ADDRESSES[2].to1LineAddressWithSpaceDelimiter} | Pick Up (Reservation) | Cannot Make It (CMI) |
      | {shipper-v4-name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithSpaceDelimiter} | Pick Up (Reservation) | Pending              |
