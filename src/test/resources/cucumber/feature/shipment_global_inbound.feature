@ShipmentGlobalInbound @Shipment @MiddleMile
Feature: Shipment Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Scan Parcel in Shipment in Shipment Global Inbound Page (uid:39caab3c-faa2-4db8-962c-d24341cd4c77)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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

  @DeleteShipment
  Scenario Outline: Operator shouldn't be able to scan <Note> Order in Shipment Global Inbound Page (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator put created parcel to shipment
    And API Operator force created order status to <status>
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below and check alert:
      | hubName    | {hub-name-2}           |
      | trackingId | GET_FROM_CREATED_ORDER |
      | toastText  | <message>              |
    Examples:
      | Note      | hiptest-uid                              | status    | message         |
      | Completed | uid:9ba2d3f4-c559-44d0-b052-a55eca91f579 | Completed | ORDER_COMPLETED |
      | Cancelled | uid:9a8c7c5f-38e2-472d-8d1a-db9f1c3ff47c | Cancelled | ORDER_CANCELLED |

  @DeleteShipment
  Scenario: Operator shouldn't be able to scan Invalid Order in Shipment Global Inbound Page (uid:ad39bc1d-0ef6-4cc1-8ef0-4003b6bef546)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below and check alert:
      | hubName    | {hub-name-2}           |
      | trackingId | AUTOMATIONTESTING      |
      | toastText  | Invalid Tracking ID    |

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Size (uid:de2394ad-48f8-49a7-b243-b92abf4461c7)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}           |
      | trackingId   | GET_FROM_CREATED_ORDER |
      | overrideSize | L                      |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Weight (uid:3f772f29-0c66-4f43-8775-bca698bd99d1)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-2}           |
      | trackingId     | GET_FROM_CREATED_ORDER |
      | overrideWeight | 7                      |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Weight and recalculate the price (uid:e8fac24e-f492-4dda-9ff4-850c97aee69e)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-2}           |
      | trackingId     | GET_FROM_CREATED_ORDER |
      | overrideWeight | 7                      |
    Then API Operator verify order info after Global Inbound
    When API Operator save current order cost
    When API Operator recalculate order price
    When API Operator verify the order price is updated
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Dimension (uid:492a25c2-3687-4774-bd6d-98ef63e512b3)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-2}           |
      | trackingId        | GET_FROM_CREATED_ORDER |
      | overrideDimHeight | 2                      |
      | overrideDimWidth  | 3                      |
      | overrideDimLength | 5                      |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Size, Weight, and Dimension (uid:16365f1f-98d1-4a78-9f7b-e3dedcfa6107)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-2}           |
      | trackingId        | GET_FROM_CREATED_ORDER |
      | overrideSize      | L                      |
      | overrideWeight    | 7                      |
      | overrideDimHeight | 2                      |
      | overrideDimWidth  | 3                      |
      | overrideDimLength | 5                      |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  @DeleteShipment
  Scenario: Operator shouldn't be able to scan Routed Order in Shipment Global Inbound Page (uid:2df317bd-ccb1-4c2f-9f10-112373767baa)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below and check alert:
      | hubName    | {hub-name-2}           |
      | trackingId | GET_FROM_CREATED_ORDER |
      | toastText  | CMI Condition          |
      | rackInfo   | ALERT                  |
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  @DeleteShipment
  Scenario Outline: Shipment Global Inbound with Priority Level - <scenarioName> (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    When Operator change Priority Level to "<priorityLevel>" on Edit Order page
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name-2}           |
      | trackingId     | GET_FROM_CREATED_ORDER |
      | rackSector     | GET_FROM_CREATED_ORDER |
      | destinationHub | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound
    Examples:
      | Title  | hiptest-uid                              | priorityLevel | priorityLevelColorAsHex |
      | 0      | uid:36826dfd-6a1b-45d8-873f-8005b77ea4b6 | 0             | #e8e8e8                 |
      | 1      | uid:9004241a-7037-40c6-8f83-b8f67f717847 | 1             | #ffff00                 |
      | 2 - 90 | uid:6e523c1e-1aa8-4eed-9032-42642067b4d1 | 50            | #ffa500                 |
      | > 90   | uid:ffdb3be9-171d-4edc-af85-20e479704862 | 100           | #ff0000                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
