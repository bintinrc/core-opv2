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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance           |
      | failureReasonCodeId    | <failureReasonCodeId> |
      | failureReasonIndexMode | FIRST                 |
    When Operator go to menu Inbounding -> Global Inbound
    And Operator refresh page
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId | {hub-id-3} |
      | type  | 2          |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
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
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API DP lodge in an order to DP with ID = "{dp-id}" and Shipper Legacy ID = "{shipper-v4-legacy-id}"
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId   | {hub-id-3}                                 |
      | orderId | {KEY_CREATED_ORDER_ID}                     |
      | scan    | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | type    | 2                                          |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    And DB Operator verify dp_qa_gl.dp_job_orders record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | SUCCESS                                    |
    And DB Operator verify dp_qa_gl.dp_jobs record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | COMPLETED                                  |
    And DB Operator verify dp_qa_gl.dp_reservations record using data below:
      | trackingId  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | barcode     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status      | RELEASED                                   |
      | releasedTo  | DRIVER                                     |
      | collectedAt | {gradle-current-date-yyyy-MM-dd}           |
      | releasedAt  | {gradle-current-date-yyyy-MM-dd}           |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound parcel picked up from DP - pickup succeed (uid:e24608b8-20b0-412f-83ba-af0ecafb7f3d)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":true, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API DP lodge in an order to DP with ID = "{dp-id}" and Shipper Legacy ID = "{shipper-v4-legacy-id}"
    Given DB Operator gets the Order ID by Tracking ID
    Given DB Operator gets Reservation ID based on Order ID from order pickups table
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add pickup reservation based on Address ID to route
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get Reservation Job
    Given DB Operator get DP job id
    And API Operator do the DP Success for To Driver Flow
    And API Driver success Reservation by scanning created parcel
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub}         |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo | {KEY_CREATED_ORDER.rackSector} |
      | color    | #f7f7f7                        |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    And DB Operator verify dp_qa_gl.dp_job_orders record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | SUCCESS                                    |
    And DB Operator verify dp_qa_gl.dp_jobs record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | COMPLETED                                  |
    And DB Operator verify dp_qa_gl.dp_reservations record using data below:
      | trackingId  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | barcode     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status      | RELEASED                                   |
      | releasedTo  | DRIVER                                     |
      | collectedAt | {gradle-current-date-yyyy-MM-dd}           |
      | releasedAt  | {gradle-current-date-yyyy-MM-dd}           |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN                   |
      | hubName | {KEY_CREATED_ORDER.destinationHub} |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Inbound Arrived at Distribution Point Order (uid:6213841e-2cb4-434b-bd6b-020aea8833ba)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with DPMS ID = "{dpms-id}"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator pulled out parcel "DELIVERY" from route
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    When API Operator refresh created order data
    And Operator go to menu Inbounding -> Global Inbound
    And Operator refresh page
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    And Operator verifies DP tag is displayed
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op