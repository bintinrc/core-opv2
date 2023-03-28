@OperatorV2 @Core @EditOrder @Reschedule @EditOrder2
Feature: Reschedule

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @routing-refactor @happy-path
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
    And DB Operator verifies that number of transactions is correct after new transactions created
      | order_id               | {KEY_CREATED_ORDER_ID}              |
      | number_of_transactions | 3                                   |
      | number_of_pickup_txn   | 2                                   |
      | pickup_address         | 116 Keng Lee Rd 15 308402 Singapore |
      | number_of_delivery_txn | 1                                   |

  @DeleteOrArchiveRoute @routing-refactor @happy-path
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

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Delivery - Latest Scan = Hub Inbound Scan
    Given Operator go to menu Utilities -> QRCode Printing
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
    Given Operator go to menu Utilities -> QRCode Printing
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

  @DeleteOrArchiveRoute @happy-path
  Scenario: Operator Reschedule Fail Pickup - Edit Pickup Address (uid:037cbbf0-9f33-4044-866e-78367d2805c7)
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
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | PP                                  |
      | status     | Fail                                |
    Then DB Operator verifies transactions record:
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
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION_BEFORE.waypointId} |
      | status | Fail                                |
    And DB Operator verifies waypoints record:
      | id       | {KEY_TRANSACTION_AFTER.waypointId} |
      | status   | Pending                            |
      | routeId  | null                               |
      | seqNo    | null                               |
      | address1 | 116 Keng Lee Rd                    |
      | address2 | 15                                 |
      | postcode | 308402                             |
      | city     | Singapore                          |
      | country  | Singapore                          |

  @DeleteOrArchiveRoute @happy-path
  Scenario: Operator Reschedule Fail Delivery - Edit Delivery Address (uid:037cbbf0-9f33-4044-866e-78367d2805c7)
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
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | DD                                  |
      | status     | Fail                                |
    Then DB Operator verifies transactions record:
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
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION_BEFORE.waypointId} |
      | status | Fail                                |
    And DB Operator verifies waypoints record:
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
  Scenario: Driver Success Delivery of a Rescheduled Parcel Delivery (uid:117cd772-7cdc-4fcb-acaa-fe4e3c5160a6)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Normal                           |
      | status      | SUCCESS                          |
      | shipperName | {filter-shipper-name}            |
    And Operator opens details of reservation "{KEY_CREATED_RESERVATION_ID}" on Shipper Pickups page
    Then Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:
      | timestamp             | {gradle-current-date-yyyy-MM-dd}           |
      | inputOnPod            | 1                                          |
      | scannedAtShipperCount | 1                                          |
      | scannedAtShipperPOD   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator verifies POD details in POD Details dialog on Shipper Pickups page using data below:
      | reservationId  | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | recipientName  | {KEY_CREATED_RESERVATION.name}           |
      | shipperId      | {shipper-v4-legacy-id}                   |
      | shipperName    | {shipper-v4-name}                        |
      | shipperContact | {shipper-v4-contact}                     |
      | status         | SUCCESS                                  |
    And Operator verifies downloaded POD CSV file on Shipper Pickups page using data below:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Driver Starts the route
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
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    When Operator refresh page
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order events on Edit order page using data below:
      | tags            | name                |
      | #l#PICKUP, SCAN | DRIVER PICKUP SCAN  |
      | PICKUP          | PICKUP SUCCESS      |
      | SORT, SCAN      | HUB INBOUND SCAN    |
      | MANUAL ACTION   | ADD TO ROUTE        |
      | SCAN, DELIVERY  | DRIVER INBOUND SCAN |
      | MANUAL ACTION   | DRIVER START ROUTE  |
      | DELIVERY        | DELIVERY FAILURE    |
      | MANUAL ACTION   | RESCHEDULE          |
      | SYSTEM ACTION   | PRICING CHANGE      |
      | DELIVERY        | DELIVERY SUCCESS    |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Delivery - Failure Reason Code Id 13
    Given Operator go to menu Utilities -> QRCode Printing
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
      | failureReasonCodeId    | 13          |
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
    Then DB Operator verify Jaro Scores:
      | waypointId        | archived |
      | {KEY_WAYPOINT_ID} | 1        |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
