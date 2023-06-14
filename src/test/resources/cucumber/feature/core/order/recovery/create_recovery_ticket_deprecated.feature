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
#    And API Operator start the route
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
#    And API Operator start the route
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
