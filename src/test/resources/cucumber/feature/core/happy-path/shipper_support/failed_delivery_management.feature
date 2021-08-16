@OperatorV2 @Core @ShipperSupport @FailedDeliveryManagement @happy-path
Feature: Failed Delivery Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator RTS Multiple Failed Deliveries (uid:3d3d7420-29b5-4072-9ebe-c5870756c8c5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels
    And Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator RTS failed delivery orders with following properties:
      | reason        | Nobody at address                                                         |
      | internalNotes | Internal notes created by OpV2 automation on {{current-date-yyyy-MM-dd}}. |
      | deliveryDate  | {{next-1-day-yyyy-MM-dd}}                                                 |
      | timeSlot      | 6PM - 10PM                                                                |
    Then Operator verifies that info toast displayed:
      | top    | 2 order(s) updated               |
      | bottom | Set Selected to Return to Sender |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RTS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE CONTACT INFORMATION |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | RESCHEDULING                          |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                                      |
      | status | PENDING                                       |
      | dnr    | NORMAL                                        |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} (RTS) |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RTS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE CONTACT INFORMATION |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | RESCHEDULING                          |
      | name    | {KEY_LIST_OF_CREATED_ORDER[2].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                                      |
      | status | PENDING                                       |
      | dnr    | NORMAL                                        |
      | name   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} (RTS) |
    And DB Operator verifies orders record using data below:
      | rts | 1 |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Reschedule Failed Delivery Order on Next Day - <Note> (<hiptest-uid>)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver failed the delivery of the created parcel
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator reschedule failed delivery order on next day
    Then Operator verify failed delivery order rescheduled on next day successfully
    And API Operator verify order info after failed delivery order rescheduled on next day
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:5e0902e9-5bcc-4993-810d-caea0781b772 | Normal    | false            |
      | Return | uid:c51d01b9-7f03-462f-ae1d-b685b739ce0e | Return    | true             |

  @DeleteOrArchiveRoute
  Scenario: Operator Reschedule Multiple Failed Deliveries (uid:6cba01c9-2685-457e-b4d1-5e08db86fdfe)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels
    And Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator reschedule failed delivery orders using data below:
      | date | {gradle-next-2-day-yyyy-MM-dd} |
    Then Operator verifies that success toast displayed:
      | top    | Order Rescheduling Success     |
      | bottom | Success to reschedule 2 orders |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[2].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[2].toName} |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator RTS Failed Delivery Order on Next Day - <Note> (<hiptest-uid>)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver failed the delivery of the created parcel
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator RTS failed delivery order on next day
    Then Operator verify failed delivery order RTS-ed successfully
    And API Operator verify order info after failed delivery order RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:e2336c49-a955-4f55-a44a-4757a2ce5386 | Normal    | false            |
      | Return | uid:03b0e991-9bb1-4eae-9f2c-944b2856948a | Return    | true             |

  @DeleteOrArchiveRoute
  Scenario: Operator Reschedule Multiple Failed Deliveries by Upload CSV (uid:a57d82d5-1ac1-48a9-9f21-ad5a136a69ea)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels
    And Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator reschedule failed delivery orders using CSV:
      | date | {gradle-next-2-day-yyyy-MM-dd} |
    Then Operator verifies that info toast displayed:
      | top    | 2 order(s) updated |
      | bottom | CSV Reschedule     |
    Then csv-reschedule-result CSV file is successfully downloaded
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[2].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[2].toName} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op