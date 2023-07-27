@Sort @Inbounding @GlobalInbound @GlobalInboundPart5 @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Inbound invalid tracking ID (uid:af756fa4-6695-40e2-8632-6de0055c0083)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3} |
      | trackingId | INVALID      |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | INVALID  |
      | rackInfo       | RECOVERY |
      | color          | #fa002c  |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Inbound failed delivery - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Sort - Operator global inbound
      | hubName              | {hub-name-3}                          |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | { "hubId":{hub-id-3} }                |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                     |
      | jobAction       | FAIL                                                                                  |
      | failureReasonId | <failureReasonCodeId>                                                                 |
    When Operator go to menu Inbounding -> Global Inbound
    And Operator refresh page
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id-3}                         |
      | type    | 2                                  |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | FAIL     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |

    Examples:
      | Note                       | hiptest-uid                              | failureReasonCodeId | rackColor | dataset_name               |
      | failure_reason_code_id = 1 | uid:cf4d5066-8706-43d4-8eaa-6ff0f6664648 | 1                   | #90EE90   | failure_reason_code_id = 1 |
      | failure_reason_code_id = 2 | uid:e1e5fc32-05bb-46a3-81e8-b5d6e9235e7f | 2                   | #FFFFED   | failure_reason_code_id = 2 |
      | failure_reason_code_id = 3 | uid:e0789546-619e-47ef-bcff-8b362da04d80 | 3                   | #D8BFD8   | failure_reason_code_id = 3 |
      | failure_reason_code_id = 5 | uid:93e4b151-b514-4f4d-8580-bc92f1120319 | 13                  | #90EE90   | failure_reason_code_id = 5 |
      | failure_reason_code_id = 6 | uid:6f91726d-ba39-462b-ac0e-e7533d00bd5e | 6                   | #9999FF   | failure_reason_code_id = 6 |

  @CloseNewWindows
  Scenario: Inbound parcel picked up from DP - pickup pending (uid:69c149a5-468c-4f1e-97a5-f54a7a33ab56)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{dp-id}"
    And API DP - DP lodge in order:
      | lodgeInRequest | {"dp_id":{dp-id},"reservations":[{"shipper_id":{shipper-v4-legacy-id},"tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"}]} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id-3}                         |
      | type    | 2                                  |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |
    And DB DP - DP user get Order Details
      | searchParameter | TRACKING_ID                           |
      | value           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And DB DP - get DP Reservation using barcode "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And DB DP - get DP job order with order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" and status "SUCCESS"
    And DB DP - get DP jobs using ID "{KEY_DP_LIST_OF_DP_JOB_ORDERS[1].dpJobId}"
    And Operator verify multiple Key details with data below:
      | key                                             | expectedValue                    |
      | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].status}      | RELEASED                         |
      | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].releasedTo}  | DRIVER                           |
      | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].collectedAt} | {gradle-current-date-yyyy-MM-dd} |
      | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].releasedAt}  | {gradle-current-date-yyyy-MM-dd} |
      | {KEY_DP_LIST_OF_DP_JOB_ORDERS[1].status}        | SUCCESS                          |
      | {KEY_DP_LIST_OF_DP_JOBS[1].status}              | COMPLETED                        |
      | {KEY_LIST_DP_ORDER_DETAILS[1].status}           | Transit                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows
  Scenario: Inbound parcel picked up from DP - pickup succeed (uid:e24608b8-20b0-412f-83ba-af0ecafb7f3d)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{dp-id}"
    And API DP - DP lodge in order:
      | lodgeInRequest | {"dp_id":{dp-id},"reservations":[{"shipper_id":{shipper-v4-legacy-id},"tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"}]} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And DB Core - get reservation id from order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And DB Core - get waypoint Id from reservation id "{KEY_LIST_OF_RESERVATION_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_RESERVATION_IDS[1]}   |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB DP - get DP job order with order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" and status "PENDING"
    And DB DP - get DP jobs using ID "{KEY_DP_LIST_OF_DP_JOB_ORDERS[1].dpJobId}"
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_WAYPOINT_ID}                                                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
      | jobType    | RESERVATION                                                                           |
      | jobAction  | SUCCESS                                                                               |
      | jobMode    | PICK_UP                                                                               |
      | dpId       | {dp-id}                                                                               |
    And API DP - DP success parcel:
      | request | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "job_id": {KEY_DP_LIST_OF_DP_JOBS[1].id}, "released_to": "DRIVER" }] |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | hubName  | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color    | #f06c00                                        |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |
    And DB DP - DP user get Order Details
      | searchParameter | TRACKING_ID                           |
      | value           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And DB DP - get DP Reservation using barcode "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And DB DP - get DP job order with order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" and status "SUCCESS"
    And DB DP - get DP jobs using ID "{KEY_DP_LIST_OF_DP_JOB_ORDERS[1].dpJobId}"
    And Operator verify multiple Key details with data below:
      | key                                             | expectedValue                    |
      | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].status}      | RELEASED                         |
      | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].releasedTo}  | DRIVER                           |
      | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].collectedAt} | {gradle-current-date-yyyy-MM-dd} |
      | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].releasedAt}  | {gradle-current-date-yyyy-MM-dd} |
      | {KEY_DP_LIST_OF_DP_JOB_ORDERS[2].status}        | SUCCESS                          |
      | {KEY_DP_LIST_OF_DP_JOBS[2].status}              | COMPLETED                        |
      | {KEY_LIST_DP_ORDER_DETAILS[1].status}           | Transit                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Inbound Arrived at Distribution Point Order (uid:6213841e-2cb4-434b-bd6b-020aea8833ba)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with DPMS ID = "{dpms-id}" and tracking id = "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id-3}                            |
      | globalInboundRequest | { "hubId":{hub-id-3} }                |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then API Core - Operator pull order from route:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | DELIVERY                           |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
      | jobType    | TRANSACTION                                                                           |
      | jobAction  | SUCCESS                                                                               |
      | jobMode    | DELIVERY                                                                              |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator refresh page
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    And Operator verifies DP tag is displayed
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op