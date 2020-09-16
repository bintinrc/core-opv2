@ShipmentGlobalInbound @InterHub @Shipment @MiddleMile
Feature: Shipment Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Shipment with Original Size <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |
    Examples:
      | Note         | hiptest-uid                              |
      | Normal Order | uid:982a0967-7636-4415-8ed6-857e626c3de3 |
      | Return Order | uid:2406175f-4338-4f9b-b639-4e23d6506dd7 |

  @DeleteShipment @ForceSuccessOrder
  Scenario Outline: Operator shouldn't be able to scan <Note> Order in Shipment Global Inbound Page (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    And API Operator put created parcel to shipment
    And API Operator force created order status to <status>
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name}                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | <message>             |
      | rackInfo       | sync_problem RECOVERY |
      | color          | #e86161               |
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |
    Examples:
      | Note      | hiptest-uid                              | status    | message   |
      | Completed | uid:9ba2d3f4-c559-44d0-b052-a55eca91f579 | Completed | COMPLETED |
      | Cancelled | uid:9a8c7c5f-38e2-472d-8d1a-db9f1c3ff47c | Cancelled | CANCELLED |

  @DeleteShipment
  Scenario: Operator shouldn't be able to scan Invalid Order in Shipment Global Inbound Page (uid:ad39bc1d-0ef6-4cc1-8ef0-4003b6bef546)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-2}        |
      | trackingId | {AUTOMATIONTESTING} |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo | INVALID |
      | color    | #f45050 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Operator Inbound Parcel in Shipment - Size, Weight, and Dimension - Return Order - Original Size (uid:7dd3c726-fb0d-4acd-98d4-2d67b03dee47)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Operator Inbound Parcel in Shipment - Size, Weight, and Dimension - Return Order - Update Size (uid:f193dde1-90eb-4a13-bdd3-a1d0b493f0c5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId   | GET_FROM_CREATED_ORDER             |
      | overrideSize | L                                  |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Operator Inbound Parcel in Shipment - Size, Weight, and Dimension - Return Order - Update Weight (uid:78e2c37d-4bbc-4ba1-b81a-2a8bd4d0b1dd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId     | GET_FROM_CREATED_ORDER             |
      | overrideWeight | 7                                  |
    Then API Operator verify order info after Global Inbound
    When API Operator save current order cost
    When API Operator recalculate order price
    When API Operator verify the order price is updated
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 1 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Operator Inbound Parcel in Shipment - Size, Weight, and Dimension - Return Order - Update Dimension (uid:73eb512e-c31b-4142-9270-dc225bad61ff)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId        | GET_FROM_CREATED_ORDER             |
      | overrideDimHeight | 2                                  |
      | overrideDimWidth  | 3                                  |
      | overrideDimLength | 5                                  |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Operator Inbound Parcel in Shipment - Size, Weight, and Dimension - Return Order - Update Size, Weight and Dimension (uid:bbb9a65e-167b-4f0b-ab51-f72c71b4f78b)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId        | GET_FROM_CREATED_ORDER             |
      | overrideSize      | L                                  |
      | overrideWeight    | 7                                  |
      | overrideDimHeight | 2                                  |
      | overrideDimWidth  | 3                                  |
      | overrideDimLength | 5                                  |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario Outline: Inbound Parcel In Shipment with Priority Level - <scenarioName> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    When Operator change Priority Level to "<priorityLevel>" on Edit Order page
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub}         |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verifies priority level info is correct using data below:
      | priorityLevel           | <priorityLevel>           |
      | priorityLevelColorAsHex | <priorityLevelColorAsHex> |
    Then API Operator verify order info after Global Inbound
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Examples:
      | Title  | hiptest-uid                              | priorityLevel | priorityLevelColorAsHex |
#      | 0      | uid:c6215ea5-b3d3-43b8-b976-2c56a77dae8b | 0             | #808080                 |
      | 1      | uid:1a303888-7fb7-4a7a-ac7e-9bf1c65453a6 | 1             | #f8cf5c                 |
      | 2 - 90 | uid:f11eae19-dfc8-4369-aac2-ad3d7f451306 | 50            | #e29d4a                 |
      | > 90   | uid:4bd56e07-bc29-45aa-b0b3-4d81309cb215 | 100           | #c65d44                 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound RTS Unrouted Parcel In Shipment (uid:96781128-86d9-4951-8ecc-72ea4e055f8c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    Then API Operator verify order info after delivery "DELIVERY_FAILED"
    When API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Inbound RTS Routed to Today's Route Parcel In Shipment (uid:897ca4d7-1afd-47b3-9cc5-0fd14ab30513)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    Then API Operator verify order info after delivery "DELIVERY_FAILED"
    When API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Inbound RTS Routed to Not Today's Route Parcel In Shipment (uid:8336e34e-5b65-47df-b5e3-30a26cbacb5f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    Then API Operator verify order info after delivery "DELIVERY_FAILED"
    When API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Routing -> Route Logs
    When Operator create new route using data below:
      | routeDate       | {gradle-next-2-day-yyyy-MM-dd} |
      | routeTags       | [{route-tag-name}]             |
      | zoneName        | {zone-name}                    |
      | hubName         | {hub-name}                     |
      | ninjaDriverName | {ninja-driver-name}            |
      | vehicleName     | {vehicle-name}                 |
    When API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel with Missing Ticket In Shipment (uid:58508a32-34c9-40bb-a8a5-2b4408dad4eb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    Then Operator verify ticket is created successfully on page Recovery Tickets
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel with Non Missing Ticket In Shipment (uid:cf1e0e1e-ba7f-424e-8ebe-4e6e66db1b72)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | DAMAGED            |
      | ticketSubType           | IMPROPER PACKAGING |
      | parcelLocation          | DAMAGED RACK       |
      | liability               | NV DRIVER          |
      | damageDescription       | GENERATED          |
      | orderOutcomeDamaged     | NV LIABLE - FULL   |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    Then Operator verify ticket is created successfully on page Recovery Tickets
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | ON HOLD - DAMAGED     |
      | rackInfo       | sync_problem RECOVERY |
      | color          | #e86161               |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id}               |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Shipment with Tag (uid:b407fe16-ff98-4fd7-a4d5-e2200a9912eb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-name} |
      | status          | Pending           |
      | granular status | Pending Pickup    |
    And Operator searches and selects orders created on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1 |
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1 |
    And DB Operator verify order_events record for the created order:
      | type | 48 |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Shipment In Shipment Destination Hub (uid:8beff617-48d6-45f0-a92e-92ccbb1ebe14)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Shipment Not In Shipment Destination Hub (uid:dd5790f2-e259-455f-a1a7-264037102fb9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-2}           |
      | trackingId | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment In Shipment Destination Hub (uid:cb14b67b-2a08-46a0-a62e-bd51196f8ffb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {KEY_CREATED_ORDER.destinationHub} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment Not In Shipment Destination Hub (uid:02307f55-e837-4e5d-affb-e09e03c1a619)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-2}           |
      | trackingId | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Transit Shipment In Shipment Destination Hub (uid:8754f863-dae1-4781-b8ed-f006fa7d8b08)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Transit Shipment Not In Shipment Destination Hub (uid:62272e8c-6504-43eb-bd3f-519b6598d701)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
