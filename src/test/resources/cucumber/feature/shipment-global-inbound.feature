@OperatorV2 @ShipmentGlobalInbound
Feature: Shipment Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Scan Parcel in Shipment in Shipment Global Inbound Page
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub {hub-name-2} of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator input the scanned Tracking ID inside the shipment
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
    And API Operator force created order status to <status>
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub {hub-name-2} of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator input the Invalid Tracking ID Status inside the shipment
    Then Operator will get the alert of <message> shown
    Examples:
      | Note      | hiptest-uid                              | status    | message         |
      | Completed |                                          | Completed | ORDER_COMPLETED |
      | Cancelled |                                          | Cancelled | ORDER_CANCELLED |

  @DeleteShipment
  Scenario: Operator shouldn't be able to scan Invalid Order in Shipment Global Inbound Page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub {hub-name-2} of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator input the Invalid Tracking ID inside the shipment
    Then Operator will get the alert of Invalid Tracking ID shown

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Size
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub {hub-name-2} of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator change the data of the created Tracking ID with this data:
      | hubName      | {hub-name-2}           |
      | trackingId   | GET_FROM_CREATED_ORDER |
      | overrideSize | L                      |
    And Operator input the scanned Tracking ID inside the shipment
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Weight
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub {hub-name-2} of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator change the data of the created Tracking ID with this data:
      | hubName        | {hub-name-2}           |
      | trackingId     | GET_FROM_CREATED_ORDER |
      | overrideWeight | 10                     |
    And Operator input the scanned Tracking ID inside the shipment
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Weight and recalculate the price
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub {hub-name-2} of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator change the data of the created Tracking ID with this data:
      | hubName        | {hub-name-2}           |
      | trackingId     | GET_FROM_CREATED_ORDER |
      | overrideWeight | 10                     |
    And Operator input the scanned Tracking ID inside the shipment
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    Then API Operator verify order info after Global Inbound
    When API Operator save current order cost
    When API Operator recalculate order price
    When API Operator verify the order price is updated
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Dimension
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub {hub-name-2} of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator change the data of the created Tracking ID with this data:
      | hubName           | {hub-name-2}             |
      | trackingId        | GET_FROM_CREATED_ORDER |
      | overrideDimHeight | 5                      |
      | overrideDimWidth  | 7                      |
      | overrideDimLength | 9                      |
    And Operator input the scanned Tracking ID inside the shipment
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  @DeleteShipment
  Scenario: Scan the order in Shipment Global Inbound by Overriding the Size, Weight, and Dimension
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub {hub-name-2} of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator change the data of the created Tracking ID with this data:
      | hubName           | {hub-name-2}           |
      | trackingId        | GET_FROM_CREATED_ORDER |
      | overrideSize      | L                      |
      | overrideWeight    | 10                     |
      | overrideDimHeight | 5                      |
      | overrideDimWidth  | 7                      |
      | overrideDimLength | 9                      |
    And Operator input the scanned Tracking ID inside the shipment
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Shipment Status = Completed on Shipment Management page
    And Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  @DeleteShipment
  Scenario: Operator shouldn't be able to scan Routed Order in Shipment Global Inbound Page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub {hub-name-2} of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator input the Invalid Tracking ID Status inside the shipment
    Then Operator will get the alert of CMI Condition shown

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
