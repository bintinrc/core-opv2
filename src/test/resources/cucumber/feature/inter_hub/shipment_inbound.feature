@ShipmentInbound @InterHub @Shipment @MiddleMile
Feature: Shipment Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Operator Sweep Parcel in Shipment - Same Destination - Not Routed (uid:d4f2dd69-e61b-4945-9e5c-900ace78bf4a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | CREATED                            |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | -       |
      | driverName |         |
      | color      | #55a1e8 |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #55a1e8            |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Operator Sweep Parcel in Shipment - Different Destination - Not Routed (uid:201f763d-d927-4676-b7a5-56a177698884)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name-2} |
      | trackingId | CREATED      |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | -       |
      | driverName |         |
      | color      | #55a1e8 |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED    |
      | hubId      | {hub-id-2} |

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Operator Sweep Parcel in Shipment - Same Destination - Routed to Today (uid:dcde6c29-1ea1-4219-bded-3cbf6aee10d3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | CREATED                            |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | {ninja-driver-name}    |
      | color      | #55a1e8                |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #55a1e8            |

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Operator Sweep Parcel in Shipment - Different Destination - Routed to Today (uid:79495eee-3095-491e-be98-0dec4124d6a0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name-2} |
      | trackingId | CREATED      |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | {ninja-driver-name}    |
      | color      | #55a1e8                |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #55a1e8            |

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Operator Sweep Parcel in Shipment - Same Destination - Routed to NOT Today (uid:cd5e3a48-cd68-4d87-a992-c437ebf53386)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-1-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-1-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | NOT ROUTED TODAY       |
      | color      | #e86161                |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #e86161            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 27    |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Operator Sweep Parcel in Shipment - Different Destination - Routed to NOT Today (uid:cfe3d8c9-6f01-4761-9f99-645cd2fb2c07)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-1-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-1-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name-2} |
      | trackingId | CREATED      |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | NOT ROUTED TODAY       |
      | color      | #e86161                |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #e86161            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id-2} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 27    |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN   |
      | hubName   | {hub-name-2}          |
      | hubId     | {hub-id-2}            |
    And Operator verify order status is "Transit" on Edit Order page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Operator Sweep Parcel in Shipment - Incomplete Process (uid:c4e5146f-618e-45eb-bf9b-22e7f7dd6a17)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-2}           |
      | trackingId | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name-2} |
      | trackingId | CREATED      |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | -       |
      | driverName |         |
      | color      | #55a1e8 |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED    |
      | hubId      | {hub-id-2} |

  @DeleteShipment @ForceSuccessOrder
  Scenario Outline: Operator Sweep Parcel in Shipment - Priority Level - <scenarioName>
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
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
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | CREATED                            |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | -       |
      | driverName |         |
      | color      | #55a1e8 |
    Then Operator verifies priority level dialog box shows correct priority level info using data below:
      | priorityLevel           | <priorityLevel>             |
      | priorityLevelColorAsHex | <priorityLevelColorAsHex>   |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #55a1e8            |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED               |
      | hubId      | {KEY_DESTINATION_HUB} |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN                |
      | hubName   | {KEY_CREATED_ORDER.destinationHub} |
      | hubId     | {KEY_DESTINATION_HUB}              |
    And Operator verify order status is "Transit" on Edit Order page

    Examples:
      | scenarioName    | hiptest-uid                              | priorityLevel | priorityLevelColorAsHex |
      | Priority 1      | uid:86b7953d-a6d6-4cc7-912a-c720ab746f3d | 1             | #f8cf5c                 |
      | Priority 2 - 90 | uid:7b214f67-e3d7-41b3-879a-db9359b88ac4 | 50            | #e29d4a                 |
      | Priority >90    | uid:e2ff802e-3332-4386-90e8-41d69c3c03c4 | 100           | #c65d44                 |

  @DeleteShipment
  Scenario: Operator Sweep Parcel in Shipment - Parcel with Tags (uid:c1b3f5d5-e5b5-440d-bb33-587e748429f8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-name} |
      | status          | Pending           |
      | granular status | Pending Pickup    |
    And Operator searches and selects orders created on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1   |
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1   |
    And DB Operator verify order_events record for the created order:
      | type | 48 |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given API Operator put created parcel to shipment
    When Operator go to menu Order -> All Orders
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | CREATED                            |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | -       |
      | driverName |         |
      | color      | #55a1e8 |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED               |
      | hubId      | {KEY_DESTINATION_HUB} |

  @DeleteShipment
  Scenario: Operator Sweep Parcel in Shipment - RTS (uid:16feea05-7a9b-4e92-91c0-afa8f4ee78e3)
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
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | CREATED                            |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | -       |
      | driverName |         |
      | color      | #55a1e8 |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED               |
      | hubId      | {KEY_DESTINATION_HUB} |

  @DeleteShipment
  Scenario: Operator Sweep Parcel in Shipment - On Hold Missing Ticket (uid:9e1ae748-064a-4aa2-a312-b1aa65f1810d)
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
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | CREATED                            |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | {KEY_CREATED_ROUTE_ID} |
      | driverName | {ninja-driver-name}    |
      | color      | #55a1e8                |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #55a1e8            |

  @DeleteShipment
  Scenario: Operator Sweep Parcel in Shipment - On Hold Non Missing Ticket (Shipper issue, Damaged, Parcel Exception) (uid:68d540f4-88af-4be7-82b1-8af9a95ebe0b)
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
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | CREATED                            |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId    | sync_problem RECOVERY |
      | driverName | ON HOLD               |
      | color      | #e86161               |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName |         |
      | color    | #e86161 |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED               |
      | hubId      | {KEY_DESTINATION_HUB} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 27    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
