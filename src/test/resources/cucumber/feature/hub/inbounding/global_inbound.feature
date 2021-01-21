@OperatorV2 @MiddleMile @Hub @Inbounding @GlobalInbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @ForceSuccessOrder
  Scenario Outline: Inbound Parcel In Shipment with Original Size - <Note> - (<hiptest-uid>)
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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |
    Examples:
      | Note         | hiptest-uid                              |
      | Normal Order | uid:0726feb3-3ca4-444c-8dbf-9863a7f47d74 |
      | Return Order | uid:a0bb7b22-2016-4291-8ffa-eb597e74335a |

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
    And DB Operator verify the last order_events record for the created order for RTS:
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
      | destinationHub | INVALID               |
      | rackInfo       | sync_problem RECOVERY |
      | color          | #e86161               |

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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario Outline: Inbound Parcel In Shipment and Update The Size - <Note> - (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |
    Examples:
      | Note         | orderType | hiptest-uid                              |
      | Normal Order | Normal    | uid:bc3f08ee-09fe-4702-8868-a8afdb4bb79e |
      | Return Order | Return    | uid:6b0c148d-1ba8-4a40-9a80-928f90df8bbf |

  @DeleteShipment @ForceSuccessOrder
  Scenario Outline: Inbound Parcel In Shipment and Update The Weight - <Note> - (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    When Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 1 |
    Examples:
      | Note         | orderType | hiptest-uid                              |
      | Normal Order | Normal    | uid:d8739fde-c84c-4ce4-b9d5-81d610150781 |
      | Return Order | Return    | uid:659feeaa-5040-44ae-a0ac-ebe54c339023 |

  @DeleteShipment @ForceSuccessOrder
  Scenario Outline: Inbound Parcel In Shipment and Update The Dimension - <Note> - (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |
    Examples:
      | Note         | orderType | hiptest-uid                              |
      | Normal Order | Normal    | uid:9c9ae45f-9d00-4e43-9377-4c29e930d51a |
      | Return Order | Return    | uid:d9a9fb22-e758-4c40-beda-126a2d2cfdaa |


  @DeleteShipment @ForceSuccessOrder
  Scenario Outline: Inbound Parcel In Shipment and Update The Size, Weight, and Dimension - <Note> - (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |
    Examples:
      | Note         | orderType | hiptest-uid                              |
      | Normal Order | Normal    | uid:6b24f5b1-5006-4c5c-b61a-383fdb3734db |
      | Return Order | Return    | uid:12ec733f-6592-4ac5-94ec-2a8738099bfa |

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
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Examples:
      | Title  | hiptest-uid                              | priorityLevel | priorityLevelColorAsHex |
      | 1      | uid:3b0b1e13-6d04-42d3-b2df-d922e870f05a | 1             | #f8cf5c                 |
      | 2 - 90 | uid:85ae2e8e-670b-477f-bda2-d4c8e417000c | 50            | #e29d4a                 |
      | > 90   | uid:6639ab15-e238-4451-8611-6616fbe3d49a | 100           | #c65d44                 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound RTS Unrouted Parcel In Shipment (uid:86c65fd5-fa71-47ac-aced-510c828c41b9)
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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Inbound RTS Routed to Today's Route Parcel In Shipment (uid:365bef54-c63d-4319-8e8a-002dc7e25f0c)
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
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Inbound RTS Routed to Not Today's Route Parcel In Shipment (uid:e80f5821-5e75-481d-afeb-d9f3c585345a)
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
      | date            | {gradle-next-2-day-yyyy-MM-dd} |
      | tags            | {route-tag-name}               |
      | zone            | {zone-name}                    |
      | hub             | {hub-name}                     |
      | driverName      | {ninja-driver-name}            |
      | vehicle         | {vehicle-name}                 |
    When API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
      | trackingId | GET_FROM_CREATED_ORDER             |
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel with Missing Ticket In Shipment (uid:2d8f14eb-7b29-4510-9ead-3b7b9a3c6990)
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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel with Non Missing Ticket In Shipment (uid:c80db230-d6e2-425a-9916-b954542ba425)
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
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Shipment with Tag (uid:9c59d268-2a90-4de8-8339-610bb3da3492)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-name} |
      | status          | Pending           |
      | granular status | Pending Pickup    |
    And Operator searches and selects orders created first row on Add Tags to Order page
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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Shipment In Shipment Destination Hub (uid:bc7fbb6a-15a0-43cb-9448-83c658024280)
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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Shipment Not In Shipment Destination Hub (uid:27ebf50b-8ec0-4588-b747-b3fb240d99ba)
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
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment In Shipment Destination Hub (uid:84c66090-e81e-4973-b3c3-63949a165d86)
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
    And Operator filter with following data on Shipment Management Page
      | shipmentStatus | completed                          |
      | lastInboundHub | {KEY_CREATED_ORDER.destinationHub} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment Not In Shipment Destination Hub (uid:2ed03a86-8d75-4f27-83c4-4bb4494ef370)
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
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Transit Shipment In Shipment Destination Hub (uid:8fdf2741-5a8f-456d-b112-cd6cc44f1ff3)
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
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Transit Shipment Not In Shipment Destination Hub (uid:0f212361-e66b-4846-96f2-78db15f900ac)
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
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | TRANSIT                                       |
      | granularStatus | Arrived at Sorting Hub; Arrived at Origin Hub |
      | deliveryStatus | PENDING                                       |
    And DB Operator verify the last order_events record for the created order for RTS:
      | type | 26 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
