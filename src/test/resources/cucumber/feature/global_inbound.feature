@OperatorV2 @GlobalInbound @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator global inbounds the created order with valid tracking ID (uid:50b27d44-6f86-44e7-b9b8-f9f0cd8178c2)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  Scenario: Operator global inbounds the created order and override the size (uid:68e2827e-93e7-4407-9726-503b3e9966b9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                              |
      | v2OrderRequest    | { "parcels":[{"parcel_size_id": 0, "volume": 1, "weight": 4}], "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name}             |
      | trackingId   | GET_FROM_CREATED_ORDER |
      | overrideSize | L                      |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  Scenario: Operator global inbounds the created order and override the weight (uid:7a93ddec-359a-4e66-b50a-0044a92b8d70)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                              |
      | v2OrderRequest    | { "parcels":[{"parcel_size_id": 0, "volume": 1, "weight": 4}], "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name}             |
      | trackingId     | GET_FROM_CREATED_ORDER |
      | overrideWeight | 7                      |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  Scenario: Operator global inbounds the created order, override the weight and recalculate the price (uid:f1ae23d0-1c04-4312-99fc-1c24733e9cc1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                              |
      | v2OrderRequest    | { "parcels":[{"parcel_size_id": 0, "volume": 1, "weight": 4}], "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name}             |
      | trackingId     | GET_FROM_CREATED_ORDER |
      | overrideWeight | 7                      |
    Then API Operator verify order info after Global Inbound
    When API Operator save current order cost
    When API Operator recalculate order price
    When API Operator verify the order price is updated
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  Scenario: Operator global inbounds the created order and override dimension (uid:f40ec594-d63f-44c8-9298-54cd3553b081)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                              |
      | v2OrderRequest    | { "parcels":[{"parcel_size_id": 0, "volume": 1, "weight": 4}], "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name}             |
      | trackingId        | GET_FROM_CREATED_ORDER |
      | overrideDimHeight | 2                      |
      | overrideDimWidth  | 3                      |
      | overrideDimLength | 5                      |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  Scenario: Operator global inbounds the created order and override size, weight and dimension (uid:234173e8-0d85-4f22-a729-437f8799fc72)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                              |
      | v2OrderRequest    | { "parcels":[{"parcel_size_id": 0, "volume": 1, "weight": 4}], "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name}             |
      | trackingId        | GET_FROM_CREATED_ORDER |
      | overrideSize      | L                      |
      | overrideWeight    | 7                      |
      | overrideDimHeight | 2                      |
      | overrideDimWidth  | 3                      |
      | overrideDimLength | 5                      |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  @ArchiveRouteViaDb
  Scenario: Operator should not be able to Global Inbound routed pending delivery (uid:f56aada4-dbed-4688-b4eb-a3126d0b4981)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                              |
      | v2OrderRequest    | { "parcels":[{"parcel_size_id": 0, "volume": 1, "weight": 4}], "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below and check alert:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | toastText  | CMI Condition          |
      | rackInfo   | ALERT                  |
    And API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |

  Scenario Outline: Operator should not be able to Global Inbound parcel with invalid order's status (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                              |
      | v2OrderRequest    | { "parcels":[{"parcel_size_id": 0, "volume": 1, "weight": 4}], "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator force created order status to <status>
    When Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below and check alert:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | toastText  | <message>              |
    Examples:
      | Note      | hiptest-uid                              | status    | message         |
      | Completed | uid:cd293abb-cceb-44f2-a58c-ee89c1a8ba67 | Completed | ORDER_COMPLETED |
      | Cancelled | uid:2b1af9c8-e582-434a-aee6-76fb06aadf95 | Cancelled | ORDER_CANCELLED |

  @ArchiveRouteViaDb
  Scenario Outline: Operator should be able to Global Inbound failed delivery order on Global Inbound page (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver failed the delivery of the created parcel with following parameters:
      | failureReasonCodeId | <failureReasonCodeId> |
    When Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below and check alert:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | rackColor  | <rackColor>            |
    And API Operator verify order info after delivery "DELIVERY_FAILED"
    And DB Operator verify transaction_failure_reason record for the created order
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId | {hub-id} |
      | type  | 2        |
    And DB Operator verify the last order_events record for the created order:
      | type | 26 |
    When Operator go to menu Order -> All Orders
    Then Operator verify following order info parameters after Global Inbound
      | orderStatus    | Delivery fail      |
      | granularStatus | Pending Reschedule |
      | deliveryStatus | FAIL               |

    Examples:
      | failureReasonCodeId | rackColor |
      | 1                   | #90EE90   |
      | 2                   | #FFFFED   |
      | 3                   | #D8BFD8   |
      | 5                   | #FF9999   |
      | 6                   | #9999FF   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
