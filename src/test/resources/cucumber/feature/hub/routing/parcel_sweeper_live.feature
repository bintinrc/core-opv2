@OperatorV2 @MiddleMile @Hub @Routing @ParcelSweeperLive
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Sweep Parcel In Shipment In Shipment Destination Hub (uid:e4d6fe8e-f39a-4ceb-a8fa-decbbf631c70)
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
  Scenario: Sweep Parcel In Shipmen Not In Shipment Destination Hub (uid:da886f6f-2d71-4eec-add1-1ffbc2af0f21)
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
  Scenario: Sweep Routed to Today's Route Parcel In Shipment In Shipment Destination Hub (uid:5eb117f9-52f7-48c7-890e-22351f834ce9)
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
  Scenario: Sweep Routed to Today's Route Parcel Not  In Shipment In Shipment Destination Hub (uid:707f953f-d977-4756-a8d8-eccae3a032f7)
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
  Scenario: Sweep Routed to Not Today's Route Parcel In Shipment In Shipment Destination Hub (uid:40ba8c22-e800-4391-a821-f1b7c5b9cde4)
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
      | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Sweep Routed to Not Today's Route Parcel In Shipment Not In Shipment Destination Hub (uid:c5cbb7e0-e947-4902-90fe-8123b6a9ae70)
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
      | trackingId | CREATED    |
      | hubId      | {hub-id-2} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name-2}        |
      | hubId     | {hub-id-2}          |
    And Operator verify order status is "Transit" on Edit Order page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Sweep Parcel In Transit Shipment (uid:4556b29f-e5dd-4395-834f-6299b71fcc51)
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
  Scenario Outline: Sweep Parcel In Shipment with Priority Level (<hiptest-uid>) - <scenarioName>
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
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
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
      | priorityLevel           | <priorityLevel>           |
      | priorityLevelColorAsHex | <priorityLevelColorAsHex> |
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
      | Priority 1      | uid:79172574-1375-48fb-ad29-d2212e585d15 | 1             | #f8cf5c                 |
      | Priority 2 - 90 | uid:5ad3c195-9f34-4987-863b-0ceb8e7b09d8 | 50            | #e29d4a                 |
      | Priority >90    | uid:fc7de149-fc0a-48db-993e-f7cbcf57e301 | 100           | #c65d44                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op