@OperatorV2 @ShipperSupport @FailedDeliveryManagement @Saas @Inbound
Feature: Failed Delivery Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario Outline: Operator find failed delivery order on Failed Delivery orders list (<hiptest-uid>)
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
      | Normal | uid:01c6c399-c7b8-417b-bbc1-4f716b7b5f67 | Normal    | false            |
      | Return | uid:8d0c07a5-1801-409d-a454-487c32481cd0 | Return    | true             |
#      | C2C    | uid:e814f4c6-51fa-4173-bcdd-2367374ca992 | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator download and verify CSV file of failed delivery order on Failed Delivery orders list (<hiptest-uid>)
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
      | Normal | uid:a70d0a54-5ce8-4c4e-b892-2074476c8131 | Normal    | false            |
      | Return | uid:e5dba9b6-059e-4701-9981-0a8e02da35c0 | Return    | true             |
#      | C2C    | uid:8b9dfe3a-9f70-47e4-82b9-ab596f207ad1 | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator reschedule failed delivery order on next day (<hiptest-uid>)
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
      | Normal | uid:24a27638-888c-4283-8110-dbb04b8b8abd | Normal    | false            |
      | Return | uid:214ce346-60d9-41bd-a657-6e79b7f7f35b | Return    | true             |
#      | C2C    | uid:64319e55-cd97-44d4-bed7-5ff3486e9744 | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator reschedule failed delivery order on specific date (<hiptest-uid>)
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
      | Normal | uid:88e1c317-20e4-4ef5-9ed5-905888f35b69 | Normal    | false            |
      | Return | uid:e5c1e60c-24d1-4b98-9454-db3efe876006 | Return    | true             |
#      | C2C    | uid:29039bb4-431e-4af2-b5c8-14c94771433d | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator RTS failed delivery order on next day (<hiptest-uid>)
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
      | Normal | uid:3e01ecc1-4e17-4b26-bc30-65711dd73133 | Normal    | false            |
      | Return | uid:f298d342-ebb3-4a49-ab04-0b7f13c004d3 | Return    | true             |
#      | C2C    | uid:a9db815b-1187-4cee-81fd-c5f4ccec8d56 | C2C       | true             |
#
  @DeleteOrArchiveRoute
  Scenario Outline: Operator RTS selected failed delivery order on next day (<hiptest-uid>)
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
      | Normal | uid:247a00f4-ddfd-408f-b3be-bb524997c5b7 | Normal    | false            |
      | Return | uid:fe1c3969-5bf0-4cad-b94e-a9363fe8e3fa | Return    | true             |
#      | C2C    | uid:d58e4b07-fe50-43ac-8816-7aa53203bab3 | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Return to sender one parcel and change to new address (<hiptest-uid>)
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
    And Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator RTS failed delivery order with following properties:
      | reason        | Other Reason                                                              |
      | internalNotes | Internal notes created by OpV2 automation on {{current-date-yyyy-MM-dd}}. |
      | deliveryDate  | {{next-1-day-yyyy-MM-dd}}                                                 |
      | timeSlot      | 3PM - 6PM                                                                 |
    Then Operator verify failed delivery order RTS-ed successfully
    And API Operator verify order info after failed delivery order RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:3e01ecc1-4e17-4b26-bc30-65711dd73133 | Normal    | false            |

  @DeleteOrArchiveRoute
  Scenario Outline: Return to sender one parcel - <reason>, <timeslot> (<hiptest-uid>)
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
    And Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
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
      | hiptest-uid                              | reason                   | timeslot   | status  | granularStatus          | deliveryTitle    | deliveryStatus | startTime                          | endTime                            |
      | uid:0d252b42-2157-4eec-adab-c0c27e9d82bd | Unable to find address   | 9AM - 6PM  | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 09:00:00 | {{next-1-day-yyyy-MM-dd}} 18:00:00 |
      | uid:c0a682fa-de75-458d-8253-630321b926fc | Item refused at doorstep | 9AM - 10PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 09:00:00 | {{next-1-day-yyyy-MM-dd}} 22:00:00 |
      | uid:d557fa51-2bd4-46b2-9046-d90b241e2f32 | Refused to pay COD       | 9AM - 12PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 09:00:00 | {{next-1-day-yyyy-MM-dd}} 12:00:00 |
      | uid:42a986e9-53fc-4f46-8da1-4e4e4cbc28ad | Customer delayed beyond  | 12PM - 3PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 12:00:00 | {{next-1-day-yyyy-MM-dd}} 15:00:00 |
      | uid:6179f485-cdd8-4ec5-bdf9-671040ecb1e8 | Cancelled by shipper     | 3PM - 6PM  | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 15:00:00 | {{next-1-day-yyyy-MM-dd}} 18:00:00 |
      | uid:1a22bef5-2081-4e75-8ba2-101ea269ea55 | Nobody at address        | 6PM - 10PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 18:00:00 | {{next-1-day-yyyy-MM-dd}} 22:00:00 |
      | uid:ca740d8c-8660-40c1-bb2e-f206d8e9e363 | Other Reason             | 6PM - 10PM | Transit | En-route to Sorting Hub | Return to Sender | PENDING        | {{next-1-day-yyyy-MM-dd}} 18:00:00 | {{next-1-day-yyyy-MM-dd}} 22:00:00 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
