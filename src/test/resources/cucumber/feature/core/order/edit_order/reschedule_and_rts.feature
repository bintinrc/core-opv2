@OperatorV2 @Core @Order @EditOrder @RescheduleAndRTS
Feature: Reschedule & RTS

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Pickup (uid:c1962397-8060-4485-9221-47cb46803ddf)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail pickup waypoint from Route Manifest page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Pickup on Edit Order Page
      | senderName     | test sender name          |
      | senderContact  | +9727894434               |
      | senderEmail    | test@mail.com             |
      | internalNotes  | test internalNotes        |
      | pickupDate     | {{next-1-day-yyyy-MM-dd}} |
      | pickupTimeslot | 9AM - 12PM                |
      | country        | Singapore                 |
      | city           | Singapore                 |
      | address1       | 116 Keng Lee Rd           |
      | address2       | 15                        |
      | postalCode     | 308402                    |
    Then DB Operator verifies pickup info is updated in order record
    And DB Operator verify Pickup waypoint record for Pending transaction
    And DB Operator verifies orders record using data below:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And DB Operator verifies transactions after reschedule pickup
      | old_pickup_status | Fail    |
      | new_pickup_status | Pending |
      | new_pickup_type   | PP      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Delivery (uid:af4f96cb-5ed1-4035-8a29-650ac5013aae)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail delivery waypoint from Route Manifest page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Delivery on Edit Order Page
      | recipientName    | test recipient name       |
      | recipientContact | +9727894434               |
      | recipientEmail   | test@mail.com             |
      | internalNotes    | test internalNotes        |
      | deliveryDate     | {{next-1-day-yyyy-MM-dd}} |
      | deliveryTimeslot | 9AM - 12PM                |
      | country          | Singapore                 |
      | city             | Singapore                 |
      | address1         | 116 Keng Lee Rd           |
      | address2         | 15                        |
      | postalCode       | 308402                    |
    Then DB Operator verifies delivery info is updated in order record
    And DB Operator verify Delivery waypoint record for Pending transaction
    And DB Operator verifies orders record using data below:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And DB Operator verifies transactions after reschedule
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Unrouted (uid:2ce27a02-460b-40f3-91f4-e42981a6eb96)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn   | 2       |
      | delivery_status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Routed (uid:d66b5b2a-a59e-4e74-b001-5605489da68a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Pending Reschedule, Latest Scan = Driver Inbound Scan (uid:d56ee23a-ca14-4d91-9942-4ae1c71a49b9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | DRIVER INBOUND SCAN        |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Pending Reschedule, Latest Scan = Hub Inbound Scan (uid:5bae8c76-b67d-4cfd-9d7e-2af0d0fe0db9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
      | expectedStatus       | DELIVERY_FAIL        |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | HUB INBOUND SCAN           |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Delivery - Latest Scan = Hub Inbound Scan (uid:6a7a2f76-f033-4637-b2e0-e1973d080026)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
      | expectedStatus       | DELIVERY_FAIL        |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    When Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Delivery on Edit Order Page
      | recipientName    | test recipient name       |
      | recipientContact | +9727894434               |
      | recipientEmail   | test@mail.com             |
      | internalNotes    | test internalNotes        |
      | deliveryDate     | {{next-1-day-yyyy-MM-dd}} |
      | deliveryTimeslot | 9AM - 12PM                |
      | country          | Singapore                 |
      | city             | Singapore                 |
      | address1         | 116 Keng Lee Rd           |
      | address2         | 15                        |
      | postalCode       | 308402                    |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies transactions after reschedule
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Delivery - Latest Scan = Driver Inbound Scan (uid:066c5598-129c-4fe0-bd9a-0af449703f33)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    When Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Delivery on Edit Order Page
      | recipientName    | test recipient name       |
      | recipientContact | +9727894434               |
      | recipientEmail   | test@mail.com             |
      | internalNotes    | test internalNotes        |
      | deliveryDate     | {{next-1-day-yyyy-MM-dd}} |
      | deliveryTimeslot | 9AM - 12PM                |
      | country          | Singapore                 |
      | city             | Singapore                 |
      | address1         | 116 Keng Lee Rd           |
      | address2         | 15                        |
      | postalCode       | 308402                    |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies transactions after reschedule
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute
  Scenario: Operator Reschedule Fail Pickup - Edit Pickup Address
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the C2C/Return order pickup using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pickup Fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | FAIL |
    When Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION_BEFORE"
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Pickup on Edit Order Page
      | senderName     | test sender name          |
      | senderContact  | +9727894434               |
      | senderEmail    | test@mail.com             |
      | internalNotes  | test internalNotes        |
      | pickupDate     | {{next-1-day-yyyy-MM-dd}} |
      | pickupTimeslot | 9AM - 12PM                |
      | country        | Singapore                 |
      | city           | Singapore                 |
      | address1       | 116 Keng Lee Rd           |
      | address2       | 15                        |
      | postalCode     | 308402                    |
    And Operator refresh page
    Then Operator verify order events on Edit order page using data below:
      | name           |
      | RESCHEDULE     |
      | UPDATE ADDRESS |
      | UPDATE AV      |
    When API Operator get order details
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | PP                                  |
      | status     | Fail                                |
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | PP                                 |
      | status     | Pending                            |
      | routeId    | null                               |
      | address1   | 116 Keng Lee Rd                    |
      | address2   | 15                                 |
      | postcode   | 308402                             |
      | city       | Singapore                          |
      | country    | Singapore                          |
      | name       | test sender name                   |
      | email      | test@mail.com                      |
      | contact    | +9727894434                        |
    And DB Operator verifies core_qa_sg.waypoints record:
      | id     | {KEY_TRANSACTION_BEFORE.waypointId} |
      | status | Fail                                |
    And DB Operator verifies core_qa_sg.waypoints record:
      | id       | {KEY_TRANSACTION_AFTER.waypointId} |
      | status   | Pending                            |
      | routeId  | null                               |
      | seqNo    | null                               |
      | address1 | 116 Keng Lee Rd                    |
      | address2 | 15                                 |
      | postcode | 308402                             |
      | city     | Singapore                          |
      | country  | Singapore                          |

  @DeleteOrArchiveRoute
  Scenario: Operator Reschedule Fail Delivery - Edit Delivery Address
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_BEFORE"
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Delivery on Edit Order Page
      | recipientName    | test recipient name       |
      | recipientContact | +9727894434               |
      | recipientEmail   | test@mail.com             |
      | internalNotes    | test internalNotes        |
      | deliveryDate     | {{next-1-day-yyyy-MM-dd}} |
      | deliveryTimeslot | 9AM - 12PM                |
      | country          | Singapore                 |
      | city             | Singapore                 |
      | address1         | 116 Keng Lee Rd           |
      | address2         | 15                        |
      | postalCode       | 308402                    |
    And Operator refresh page
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | name           |
      | RESCHEDULE     |
      | UPDATE ADDRESS |
      | UPDATE AV      |
    When API Operator get order details
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | DD                                  |
      | status     | Fail                                |
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
      | routeId    | null                               |
      | address1   | 116 Keng Lee Rd                    |
      | address2   | 15                                 |
      | postcode   | 308402                             |
      | city       | Singapore                          |
      | country    | Singapore                          |
      | name       | test recipient name                |
      | email      | test@mail.com                      |
      | contact    | +9727894434                        |
    And DB Operator verifies core_qa_sg.waypoints record:
      | id     | {KEY_TRANSACTION_BEFORE.waypointId} |
      | status | Fail                                |
    And DB Operator verifies core_qa_sg.waypoints record:
      | id       | {KEY_TRANSACTION_AFTER.waypointId} |
      | status   | Pending                            |
      | routeId  | null                               |
      | seqNo    | null                               |
      | address1 | 116 Keng Lee Rd                    |
      | address2 | 15                                 |
      | postcode | 308402                             |
      | city     | Singapore                          |
      | country  | Singapore                          |

  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Unrouted - Edit Delivery Address
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_BEFORE"
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
      | country      | Singapore                      |
      | city         | Singapore                      |
      | address1     | 116 Keng Lee Rd                |
      | address2     | 15                             |
      | postalCode   | 308402                         |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    When API Operator get order details
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies core_qa_sg.transactions record:
      | id         | {KEY_TRANSACTION_BEFORE.id}        |
      | orderId    | null                               |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
      | routeId    | null                               |
      | address1   | 116 Keng Lee Rd                    |
      | address2   | 15                                 |
      | postcode   | 308402                             |
      | city       | Singapore                          |
      | country    | Singapore                          |
    And DB Operator verifies core_qa_sg.waypoints record:
      | id       | {KEY_TRANSACTION_AFTER.waypointId} |
      | status   | Pending                            |
      | routeId  | null                               |
      | seqNo    | null                               |
      | address1 | 116 Keng Lee Rd                    |
      | address2 | 15                                 |
      | postcode | 308402                             |
      | city     | Singapore                          |
      | country  | Singapore                          |

  @DeleteOrArchiveRoute
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Routed - Edit Delivery Address
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_BEFORE"
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
      | country      | Singapore                      |
      | city         | Singapore                      |
      | address1     | 116 Keng Lee Rd                |
      | address2     | 15                             |
      | postalCode   | 308402                         |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    When API Operator get order details
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | DD                                  |
      | status     | Fail                                |
    Then DB Operator verifies core_qa_sg.transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
      | routeId    | null                               |
      | address1   | 116 Keng Lee Rd                    |
      | address2   | 15                                 |
      | postcode   | 308402                             |
      | city       | Singapore                          |
      | country    | Singapore                          |
    And DB Operator verifies core_qa_sg.waypoints record:
      | id     | {KEY_TRANSACTION_BEFORE.waypointId} |
      | status | Routed                              |
    And DB Operator verifies core_qa_sg.waypoints record:
      | id       | {KEY_TRANSACTION_AFTER.waypointId} |
      | status   | Pending                            |
      | routeId  | null                               |
      | seqNo    | null                               |
      | address1 | 116 Keng Lee Rd                    |
      | address2 | 15                                 |
      | postcode | 308402                             |
      | city     | Singapore                          |
      | country  | Singapore                          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op