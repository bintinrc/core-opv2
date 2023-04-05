@OperatorV2 @DpAdministration @DistributionPointPartnersReact @OperatorV2Part1 @DpAdministrationV2 @EnableClearCache @DP
Feature: DP Administration - Distribution Point Partners

  @LaunchBrowser @ForceSuccessOrder @CompleteDpJob @CompleteDpReservations
  Scenario: Regular pickup - Shipper drop off - Parcel status CONFIRMED - Success create new reservation
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-send-order-client-id}                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-send-order-client-secret}                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API DP - DP user authenticate with username "{dp-user-send-order-username}" password "{dp-user-send-order-password}" and dp id "{dp-send-order-id}"
    Then API DP - DP lodge in order:
      | lodgeInRequest | {"dp_id":{dp-send-order-id},"reservations":[{"shipper_id":{dp-user-shipper-send-order-id},"tracking_id":"{KEY_CREATED_ORDER_TRACKING_ID}"}]} |
    Then DB Operator gets all details for dp reservations from Hibernate
    And DB Operator gets all details for dp reservation events from Hibernate
      | searchParameter | reservationId                             |
      | reservations    | KEY_DATABASE_CHECKING_NINJA_COLLECT_ORDER |
      | eventsName      | DP_RECEIVED_FROM_SHIPPER                  |
    And DB Operator gets all details of dp job orders from Hibernate
      | searchParameter | trackingId                                             |
      | barcode         | {KEY_DATABASE_CHECKING_NINJA_COLLECT_ORDER[1].barcode} |
    And DB Operator gets all details of dp jobs from Hibernate
      | searchParameter | id                                         |
      | value           | {KEY_DATABASE_GET_DP_JOB_ORDER[1].dpJobId} |
    And Ninja Point V3 verifies that the data from newly created order with DB table is right
      | condition                 | creating_send_order                       |
      | dataChecking              | RESERVATION                               |
      | dataCheckFromDb           | KEY_DATABASE_CHECKING_NINJA_COLLECT_ORDER |
      | dpReservationEventsFromDb | KEY_DATABASE_GET_DP_RESERVATION_EVENTS    |
      | dpJobOrderFromDb          | KEY_DATABASE_GET_DP_JOB_ORDER             |
      | dpJobFromDb               | KEY_DATABASE_GET_DP_JOBS                  |
    And DB Operator gets all details of lodge in order from Hibernate
      | keyCreatedOrder | KEY_LIST_OF_CREATED_ORDER |
    And Ninja Point V3 verifies that the data from newly created order with DB table is right
      | dataCheckFromDb | KEY_DATABASE_CHECKING_LODGE_IN_ORDER_DATA |
      | condition       | creating_send_order                       |
      | dataChecking    | LODGE_IN_ORDER                            |
    Then DB Operator gets all details of lodge in status from Hibernate
      | keyLodgeInOrderData | KEY_DATABASE_CHECKING_LODGE_IN_ORDER_DATA |
    And Ninja Point V3 verifies that the data from newly created order with DB table is right
      | dataCheckFromDb | KEY_DATABASE_CHECKING_LODGE_IN_STATUS_DATA |
      | condition       | creating_send_order                        |
      | dataChecking    | LODGE_IN_STATUS                            |
    Then DB DP - DP user get Order Details
      | searchParameter | TRACKING_ID                                |
      | value           | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then DB DP Analytics - DP user get Order Analytic Details
      | orderId | {KEY_LIST_OF_CREATED_ORDER[1].id} |
    And Ninja Point V3 verifies that the data from newly created order with DB table is right
      | condition             | creating_send_order                   |
      | dataChecking          | ORDER_DETAILS                         |
      | dataCheckFromDb       | KEY_LIST_DP_ORDER_DETAILS[1]          |
      | dpOrderAnalyticFromDb | KEY_LIST_DP_ORDER_ANALYTIC_DETAILS[1] |
      | order                 | KEY_CREATED_ORDER                     |
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Order -> All Orders
    And Operator waits for 5 seconds
    When Operator disable granular status filter for "Pending Pickup"
    And Operator waits for 5 seconds
    And Operator press load selection button
    Then Operator fill the tracking id filter with "{KEY_CREATED_ORDER_TRACKING_ID}"
    Then Operator check the checkbox from created order
    Then Operator press Apply Action button
    Then Operator apply action for "Regular Pickup"
    Then Operator set the pickup date for regular pickup at "{date: 0 days next, YYYY-MM-dd}"
    Then Operator press submit regular pickup button
    Then Operator verified the order data is based on the data below:
      | orderList  | KEY_CREATED_ORDER_TRACKING_ID |
      | reasonList | Pickup Reservation Created    |

  @LaunchBrowser @CompleteDpJob @CompleteDpReservations @DeleteOrArchiveRoute
  Scenario: Regular pickup - Driver drop off - Parcel status CONFIRMED - Success create new reservation
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-send-order-client-id}                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-send-order-client-secret}                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_CREATED_ORDER.trackingId}" with granular status "PENDING_PICKUP"
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_CREATED_ORDER.id},"dp_id":{dp-send-order-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-drop-off-customer-collect-driver-id} } |
    Then API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-drop-off-customer-collect-driver-username}" and "{ninja-driver-drop-off-customer-collect-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-drop-off-customer-collect-driver-id} |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                 |
    Given DB Operator gets all details for dp reservations by barcode from Hibernate
      | orderTrackingId | {KEY_CREATED_ORDER.trackingId} |
    And DB Operator gets all details for dp reservation events from Hibernate
      | searchParameter | reservationId                             |
      | reservations    | KEY_DATABASE_CHECKING_NINJA_COLLECT_ORDER |
    And DB Operator gets all details of dp job orders from Hibernate
      | searchParameter | trackingId                     |
      | barcode         | {KEY_CREATED_ORDER.trackingId} |
    And DB Operator gets all details of dp jobs from Hibernate
      | searchParameter | id                                         |
      | value           | {KEY_DATABASE_GET_DP_JOB_ORDER[1].dpJobId} |
    When API DP - DP user authenticate with username "{dp-user-send-order-username}" password "{dp-user-send-order-password}" and dp id "{dp-send-order-id}"
    Then API DP - DP success parcel:
      | request | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "job_id": {KEY_DATABASE_GET_DP_JOBS[1].id}, "received_from": "DRIVER" }] |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_DRIVER_ROUTES[1].waypoints[1].id}                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
      | jobType    | TRANSACTION                                                                           |
      | jobAction  | SUCCESS                                                                               |
      | jobMode    | DELIVERY                                                                              |
      | dpId       | {dp-send-order-id}                                                                    |
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Order -> All Orders
    And Operator waits for 5 seconds
    When Operator disable granular status filter for "Pending Pickup"
    And Operator waits for 5 seconds
    And Operator press load selection button
    Then Operator fill the tracking id filter with "{KEY_CREATED_ORDER_TRACKING_ID}"
    Then Operator check the checkbox from created order
    Then Operator press Apply Action button
    Then Operator apply action for "Regular Pickup"
    Then Operator set the pickup date for regular pickup at "{date: 0 days next, YYYY-MM-dd}"
    Then Operator press submit regular pickup button
    Then Operator verified the order data is based on the data below:
      | orderList  | KEY_CREATED_ORDER_TRACKING_ID |
      | reasonList | Pickup Reservation Created    |