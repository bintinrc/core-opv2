@OperatorV2 @Core @ShipperSupport @FailedDeliveryManagement
Feature: Failed Delivery Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario Outline: Operator RTS a Single Parcel with Various Reason - <Note> (<hiptest-uid>)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator RTS failed delivery order with following properties:
      | reason        | <reason>                                                                  |
      | internalNotes | Internal notes created by OpV2 automation on {{current-date-yyyy-MM-dd}}. |
      | deliveryDate  | {{next-1-day-yyyy-MM-dd}}                                                 |
      | timeSlot      | <timeslot>                                                                |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify order delivery title is "<deliveryTitle>" on Edit Order page
    And Operator verify order delivery status is "<deliveryStatus>" on Edit Order page
    And Operator verify RTS event displayed on Edit Order page with following properties:
      | eventTags | MANUAL ACTION |
      | reason    | <reason>      |
      | startTime | <startTime>   |
      | endTime   | <endTime>     |
    Examples:
      | Note                                 | hiptest-uid                              | reason                   | timeslot   | status  | granularStatus          | deliveryTitle    | deliveryStatus | startTime                          | endTime                            |
      | Unable to find address, 9AM - 6PM    | uid:90f3d6dd-6fc9-4930-b51d-c14e3009ee02 | Unable to find address   | 9AM - 6PM  | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 09:00:00 | {{next-1-day-yyyy-MM-dd}} 18:00:00 |
      | Item refused at doorstep, 9AM - 10PM | uid:5f49d9c1-02b4-40a5-86a2-043ea4ddb6b9 | Item refused at doorstep | 9AM - 10PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 09:00:00 | {{next-1-day-yyyy-MM-dd}} 22:00:00 |
      | Refused to pay COD, 9AM - 12PM       | uid:f6743880-4ef9-4a68-a4db-21fc7f48cb77 | Refused to pay COD       | 9AM - 12PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 09:00:00 | {{next-1-day-yyyy-MM-dd}} 12:00:00 |
      | Customer delayed beyond, 12PM - 3PM  | uid:1af1d2ef-53ec-44b1-8357-a16be8621c39 | Customer delayed beyond  | 12PM - 3PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 12:00:00 | {{next-1-day-yyyy-MM-dd}} 15:00:00 |
      | Cancelled by shipper, 3PM - 6PM      | uid:666cd095-d643-43ba-8124-dbc1aa07a5b6 | Cancelled by shipper     | 3PM - 6PM  | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 15:00:00 | {{next-1-day-yyyy-MM-dd}} 18:00:00 |
      | Nobody at address, 6PM - 10PM        | uid:21f334f7-8db0-4da4-afd1-be7b81ecd998 | Nobody at address        | 6PM - 10PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 18:00:00 | {{next-1-day-yyyy-MM-dd}} 22:00:00 |
      | Other Reason, 6PM - 10PM             | uid:6e74cf3d-c3fb-45d9-8c85-429b52ace114 | Other Reason             | 6PM - 10PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 18:00:00 | {{next-1-day-yyyy-MM-dd}} 22:00:00 |

  @DeleteOrArchiveRoute
  Scenario: Operator RTS a Single Parcel and Change to New Address - Add New Address (uid:6bb33ad4-07fe-4a7d-8575-688895ef809d)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator RTS failed delivery order with following properties:
      | reason        | Other Reason                                                              |
      | internalNotes | Internal notes created by OpV2 automation on {{current-date-yyyy-MM-dd}}. |
      | deliveryDate  | {{next-1-day-yyyy-MM-dd}}                                                 |
      | timeSlot      | 3PM - 6PM                                                                 |
      | address       | RANDOM                                                                    |
    Then Operator verify failed delivery order RTS-ed successfully
    And API Operator verify order info after failed delivery order RTS-ed on next day

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
      | Normal | uid:99790b22-d971-42df-8391-5fdec5ad0c80 | Normal    | false            |
      | Return | uid:01b82249-78bb-411e-9e20-1a785b343321 | Return    | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Reschedule Failed Delivery Order on Specific Date - <Note> (<hiptest-uid>)
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
    And Operator reschedule failed delivery order on next 2 days
    Then Operator verify failed delivery order rescheduled on next 2 days successfully
    And API Operator verify order info after failed delivery order rescheduled on next 2 days
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:4dcd41dc-8633-4a4b-8928-ad2872bfd140 | Normal    | false            |
      | Return | uid:b68e589b-05ca-421d-9be5-dcc02d6a421b | Return    | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator RTS Selected Failed Delivery Order on Next Day - <Note> (<hiptest-uid>)
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
    And Operator RTS selected failed delivery order on next day
    Then Operator verify failed delivery order RTS-ed successfully
    And API Operator verify order info after failed delivery order RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:adb3d9da-c4e7-4f1b-b782-5677d909e2d2 | Normal    | false            |
      | Return | uid:a4a37f22-cac7-48b7-aa86-9f124d582d2a | Return    | true             |

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
      | Normal | uid:ac5adb88-cf60-44b8-9482-77424c9f88df | Normal    | false            |
      | Return | uid:1c006699-4722-451d-ac6e-f010ec736e90 | Return    | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Download and Verify CSV File of Failed Delivery Order on Failed Delivery Management Page - <Note> (<hiptest-uid>)
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
    And Operator download CSV file of failed delivery order on Failed Delivery orders list
    Then Operator verify CSV file of failed delivery order on Failed Delivery orders list downloaded successfully
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:2fd680b8-4790-4e82-a692-150770a2f37a | Normal    | false            |
      | Return | uid:bde7997d-8de5-4936-9197-d9c93dbaa498 | Return    | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Find Failed Delivery Order on Failed Delivery Management Page (<hiptest-uid>)
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
    Then Operator verify the failed delivery order is listed on Failed Delivery orders list
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:8a5c4ede-96ec-4cb6-98c2-776bbfe1e3c3 | Normal    | false            |
      | Return | uid:13de8904-3423-4f4c-b27d-4d1050873bc4 | Return    | true             |

  @DeleteOrArchiveRoute
  Scenario: Operator RTS Multiple Failed Deliveries (uid:02bc7568-b4d6-48f7-8d69-14bbfc57130d)
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
  Scenario: Operator Reschedule Multiple Failed Deliveries (uid:aec2fa4a-bd14-4541-9820-b3370cbd564a)
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
  Scenario: Operator RTS a Single Parcel and Change to New Address - Search Address by Coordinates (uid:71e309a5-4beb-4add-ac51-44901c36cb50)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator RTS failed delivery order with following properties:
      | reason            | Other Reason                                                                   |
      | internalNotes     | Internal notes created by OpV2 automation on {gradle-current-date-yyyy-MM-dd}. |
      | deliveryDate      | {gradle-next-1-day-yyyy-MM-dd}                                                 |
      | timeSlot          | 3PM - 6PM                                                                      |
      | address.latitude  | 1.3880089                                                                      |
      | address.longitude | 103.8946339                                                                    |
      | address.address1  | 204a Compassvale Drive, Singapore 541204, Singapore                            |
      | address.address2  | 204a                                                                           |
      | address.postcode  | 541204                                                                         |
    Then Operator verify failed delivery order RTS-ed successfully
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

  @DeleteOrArchiveRoute
  Scenario: Operator RTS a Single Parcel and Change to New Address - Search Address by Name (uid:f69825d7-4f2d-439e-94cb-49c78fc2328f)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator RTS failed delivery order with following properties:
      | reason           | Other Reason                                                                   |
      | internalNotes    | Internal notes created by OpV2 automation on {gradle-current-date-yyyy-MM-dd}. |
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd}                                                 |
      | timeSlot         | 3PM - 6PM                                                                      |
      | address.name     | Compassvale Drive                                                              |
      | address.country  | Singapore                                                                      |
      | address.city     | Singapore                                                                      |
      | address.address1 | BLOCK 212A COMPASSVALE DRIVE                                                   |
      | address.postcode | 541212                                                                         |
    Then Operator verify failed delivery order RTS-ed successfully
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

  @DeleteOrArchiveRoute
  Scenario: Operator Reschedule Multiple Failed Deliveries by Upload CSV (uid:7e2f169f-1e30-41a7-8d7c-f87a8a844c79)
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
