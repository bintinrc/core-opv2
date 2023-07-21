#@OperatorV2 @Core @EditOrder @RTS @RTSPart2 @EditOrder4
Feature: RTS

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS Order with Allowed Granular Status - On Vehicle for Delivery
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
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | DRIVER INBOUND SCAN        |
      | UPDATE AV                  |
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
    When DB Operator gets waypoint record
    And API Operator get Addressing Zone from a lat long with type "RTS"
    Then Operator verifies Zone is correct after RTS on Edit Order page
    And Operator verifies waypoints.routing_zone_id is correct

  Scenario: Operator not Allowed to RTS Order Tagged to a DP
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify menu item "Delivery" > "Return to Sender" is disabled on Edit order page

  Scenario Outline: Operator RTS Order with Active PETS Ticket Damaged/Missing - <ticketType>
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | <ticketType>       |
      | orderOutcome            | <orderOutcome>     |
      | ticketNotes             | GENERATED          |
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator RTS order on Edit Order page using data below:
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    And Operator unmask edit order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                    |
      | address | {KEY_CREATED_ORDER.buildFromAddressString} |
    And Operator verify transaction on Edit order page using data below:
      | type               | DELIVERY                                                   |
      | status             | PENDING                                                    |
      | destinationAddress | {KEY_CREATED_ORDER.buildShortFromAddressWithCountryString} |
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    When API Operator get order details
    And Operator save the last DELIVERY transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Pending                            |
      | routeId | null                               |
      | seqNo   | null                               |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verify Jaro Scores:
      | waypointId                         | archived |
      | {KEY_TRANSACTION_AFTER.waypointId} | 1        |
    Examples:
      | ticketType | orderOutcome          |
      | MISSING    | LOST - DECLARED       |
      | DAMAGED    | NV TO REPACK AND SHIP |

  Scenario Outline: Operator RTS Order with On Hold Resolved PETS Ticket Non-Damaged/Missing - <ticketType>
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | <ticketType>       |
      | ticketSubType           | <ticketSubType>    |
      | orderOutcome            | <orderOutcome>     |
      | ticketNotes             | GENERATED          |
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED       |
      | outcome | <orderOutcome> |
    And Operator refresh page
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator RTS order on Edit Order page using data below:
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    When Operator unmask edit order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                    |
      | address | {KEY_CREATED_ORDER.buildFromAddressString} |
    And Operator verify transaction on Edit order page using data below:
      | type               | DELIVERY                                                   |
      | status             | PENDING                                                    |
      | destinationAddress | {KEY_CREATED_ORDER.buildShortFromAddressWithCountryString} |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    When API Operator get order details
    And Operator save the last DELIVERY transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Pending                            |
      | routeId | null                               |
      | seqNo   | null                               |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verify Jaro Scores:
      | waypointId                         | archived |
      | {KEY_TRANSACTION_AFTER.waypointId} | 1        |
    Examples:
      | ticketType       | ticketSubType     | orderOutcome                |
      | SELF COLLECTION  |                   | RE-DELIVER                  |
      | SHIPPER ISSUE    | DUPLICATE PARCEL  | REPACKED/RELABELLED TO SEND |
      | PARCEL EXCEPTION | CUSTOMER REJECTED | RESUME DELIVERY             |
      | PARCEL ON HOLD   | SHIPPER REQUEST   | RESUME DELIVERY             |

  Scenario Outline: Operator Not Allowed to RTS Order With Active PETS Ticket Non-Damaged/Missing - <ticketType>
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | <ticketType>       |
      | ticketSubType           | <ticketSubType>    |
      | orderOutcome            | <orderOutcome>     |
      | ticketNotes             | GENERATED          |
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    When Operator RTS order on Edit Order page using data below:
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                             |
      | bottom | ^.*Error Message: An order with status 'ON_HOLD' can be RTS only when last ticket is of type DAMAGED or MISSING.* |
    And DB Operator verifies orders record using data below:
      | rts | 0 |
    Examples:
      | ticketType       | ticketSubType     | orderOutcome                |
      | SELF COLLECTION  |                   | RE-DELIVER                  |
      | SHIPPER ISSUE    | DUPLICATE PARCEL  | REPACKED/RELABELLED TO SEND |
      | PARCEL EXCEPTION | CUSTOMER REJECTED | RESUME DELIVERY             |
      | PARCEL ON HOLD   | SHIPPER REQUEST   | RESUME DELIVERY             |

  @DeleteOrArchiveRoute
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Routed - Edit Delivery Address - New Address Belongs To Standard Zone
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
      | address1     | 50 Amber Rd                    |
      | postalCode   | 439888                         |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    When API Operator get order details
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
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
      | address1   | 50 Amber Rd                        |
      | postcode   | 439888                             |
      | city       | Singapore                          |
      | country    | Singapore                          |
    And DB Operator verifies transactions after RTS
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    When DB Operator gets waypoint record
    And API Operator get Addressing Zone from a lat long with type "RTS"
    Then Operator verifies Zone is correct after RTS on Edit Order page
    And Operator verifies waypoints.routing_zone_id is correct

  @DeleteOrArchiveRoute
  Scenario: Operator RTS an Order on Edit Order Page - PPNT Tied To DP
    And API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API DP lodge in an order to DP with ID = "{dp-id}" and Shipper Legacy ID = "{shipper-v4-legacy-id}"
    And Operator waits for 10 seconds
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup at Distribution Point" on Edit Order page
    Then DB Operator verify next Pickup transaction values are updated for the created order:
      | distribution_point_id | {dpms-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And Operator refresh page
    And Operator click Delivery -> Return to Sender on Edit Order page
    And Operator verify "Order have DP attached to Pickup Transactions, contact and address details disabled" RTS hint is displayed on Edit Order page
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that info toast displayed:
      | top | 1 order(s) RTS-ed |
    And Operator refresh page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    When API Operator get order details
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}                    |
      | waypointId | {KEY_TRANSACTION.waypointId}              |
      | type       | DD                                        |
      | status     | Pending                                   |
      | routeId    | null                                      |
      | address1   | {KEY_CREATED_ORDER_ORIGINAL.fromAddress1} |
      | address2   | {KEY_CREATED_ORDER_ORIGINAL.fromAddress2} |
      | postcode   | {KEY_CREATED_ORDER_ORIGINAL.fromPostcode} |
      | country    | {KEY_CREATED_ORDER_ORIGINAL.fromCountry}  |
    And DB Operator verifies waypoints record:
      | id       | {KEY_TRANSACTION.waypointId}              |
      | status   | Pending                                   |
      | routeId  | null                                      |
      | seqNo    | null                                      |
      | address1 | {KEY_CREATED_ORDER_ORIGINAL.fromAddress1} |
      | address2 | {KEY_CREATED_ORDER_ORIGINAL.fromAddress2} |
      | postcode | {KEY_CREATED_ORDER_ORIGINAL.fromPostcode} |
      | country  | {KEY_CREATED_ORDER_ORIGINAL.fromCountry}  |
