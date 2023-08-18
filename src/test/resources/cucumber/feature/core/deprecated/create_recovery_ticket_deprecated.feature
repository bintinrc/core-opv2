Feature: Create Recovery Ticket Deprecated
#  @DeleteOrArchiveRoute
#  Scenario: Operator Create Recovery Ticket For On Vehicle for Delivery
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    And API Driver collect all his routes
#    And API Driver get pickup/delivery waypoint of the created order
#    And API Operator Van Inbound parcel
#    And API Operator start the route with following data:
#      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
#      | driverId | {ninja-driver-id}                                                                                                                     |
#      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
#    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "On Vehicle For Delivery" on Edit Order page
#    And Operator verify Delivery transaction on Edit order page using data below:
#      | status | PENDING |
#    When Operator create new recovery ticket on Edit Order page:
#      | entrySource             | CUSTOMER COMPLAINT |
#      | investigatingDepartment | Recovery           |
#      | investigatingHub        | {hub-name}         |
#      | ticketType              | MISSING            |
#      | orderOutcomeMissing     | LOST - DECLARED    |
#      | parcelDescription       | GENERATED          |
#      | custZendeskId           | 1                  |
#      | shipperZendeskId        | 1                  |
#      | ticketNotes             | GENERATED          |
#    And API Operator get order details
#    And Operator refresh page
#    Then Operator verify order status is "On Hold" on Edit Order page
#    And Operator verify order granular status is "On Hold" on Edit Order page
#    And Operator verify order events on Edit order page using data below:
#      | name              |
#      | TICKET CREATED    |
#      | UPDATE STATUS     |
#      | PULL OUT OF ROUTE |
#    And Operator verify transaction on Edit order page using data below:
#      | type   | DELIVERY |
#      | status | PENDING  |
#    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
#    Then DB Operator verifies transactions record:
#      | orderId    | {KEY_CREATED_ORDER_ID}             |
#      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
#      | type       | DD                                 |
#      | status     | Pending                            |
#      | routeId    | null                               |
#    When API Recovery - Operator search recovery ticket:
#      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |
#
#
#  @DeleteOrArchiveRoute
#  Scenario: Operator Create Recovery Ticket For On Vehicle for Delivery
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    And API Driver collect all his routes
#    And API Driver get pickup/delivery waypoint of the created order
#    And API Operator Van Inbound parcel
#    And API Operator start the route with following data:
#      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
#      | driverId | {ninja-driver-id}                                                                                                                     |
#      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
#    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "On Vehicle For Delivery" on Edit Order page
#    And Operator verify Delivery transaction on Edit order page using data below:
#      | status | PENDING |
#    When Operator create new recovery ticket on Edit Order page:
#      | entrySource             | CUSTOMER COMPLAINT |
#      | investigatingDepartment | Recovery           |
#      | investigatingHub        | {hub-name}         |
#      | ticketType              | MISSING            |
#      | orderOutcomeMissing     | LOST - DECLARED    |
#      | parcelDescription       | GENERATED          |
#      | custZendeskId           | 1                  |
#      | shipperZendeskId        | 1                  |
#      | ticketNotes             | GENERATED          |
#    And API Operator get order details
#    And Operator refresh page
#    Then Operator verify order status is "On Hold" on Edit Order page
#    And Operator verify order granular status is "On Hold" on Edit Order page
#    And Operator verify order events on Edit order page using data below:
#      | name              |
#      | TICKET CREATED    |
#      | UPDATE STATUS     |
#      | PULL OUT OF ROUTE |
#    And Operator verify transaction on Edit order page using data below:
#      | type   | DELIVERY |
#      | status | PENDING  |
#    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
#    Then DB Operator verifies transactions record:
#      | orderId    | {KEY_CREATED_ORDER_ID}             |
#      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
#      | type       | DD                                 |
#      | status     | Pending                            |
#      | routeId    | null                               |
#    When API Recovery - Operator search recovery ticket:
#      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |

# Deprecated:
# this feature is not valid due https://jira.ninjavan.co/browse/ROUTE-901
#  @DeleteOrArchiveRoute
#  Scenario: Operator Create and Search Recovery Ticket For Driver Inbound Scan
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    Given API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    Given DB Operator gets Hub ID by Hub Name of created parcel
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_DESTINATION_HUB_ID}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    And API Operator sweep parcel:
#      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
#      | hubId | {KEY_DESTINATION_HUB_ID}        |
#    When Operator go to menu Inbounding -> Van Inbound
#    And Operator fill the route ID on Van Inbound Page then click enter
#    And Operator fill the tracking ID on Van Inbound Page then click enter
#    Then Operator verify the van inbound process is succeed
#    And Operator click on start route after van inbounding
#    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
#    And Operator verify order event on Edit order page using data below:
#      | name    | DRIVER INBOUND SCAN  |
#      | routeId | KEY_CREATED_ROUTE_ID |
#    And Operator verify order event on Edit order page using data below:
#      | name    | DRIVER START ROUTE   |
#      | routeId | KEY_CREATED_ROUTE_ID |
#    When Operator create new recovery ticket on Edit Order page:
#      | entrySource             | CUSTOMER COMPLAINT |
#      | investigatingDepartment | Recovery           |
#      | investigatingHub        | {hub-name}         |
#      | ticketType              | MISSING            |
#      | orderOutcomeMissing     | FOUND - INBOUND    |
#      | parcelDescription       | GENERATED          |
#      | custZendeskId           | 1                  |
#      | shipperZendeskId        | 1                  |
#      | ticketNotes             | GENERATED          |
#    When Operator refresh page
#    Then Operator verify order status is "On Hold" on Edit Order page
#    And Operator verify order granular status is "On Hold" on Edit Order page
#    And Operator verify order events on Edit order page using data below:
#      | name           |
#      | TICKET CREATED |
#    When API Operator get order details
#    Then Operator verify Delivery transaction on Edit order page using data below:
#      | routeId |  |
#    And Operator verify order event on Edit order page using data below:
#      | name    | PULL OUT OF ROUTE    |
#      | routeId | KEY_CREATED_ROUTE_ID |
#    And Operator verify order events on Edit order page using data below:
#      | tags          | name          | description                                                                                                              |
#      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Vehicle for Delivery\nNew Granular Status: Arrived at Sorting Hub\nReason: PULLED_OUT_FROM_ROUTE |
#    Then DB Operator verify next Delivery transaction values are updated for the created order:
#      | routeId | 0 |
#    And DB Operator verify Delivery waypoint of the created order using data below:
#      | status | PENDING |
#
#    And DB Operator verifies transaction route id is null
#    And DB Operator verifies waypoint status is "PENDING"
#    And DB Operator verifies waypoints.route_id & seq_no is NULL
#
#    And DB Operator verifies route_monitoring_data is hard-deleted
#    When API Recovery - Operator search recovery ticket:
#      | request | {"tracking_ids":["{KEY_CREATED_ORDER_TRACKING_ID}"]} |