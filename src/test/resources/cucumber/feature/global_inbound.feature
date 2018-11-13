@OperatorV2 @OperatorV2Part1 @GlobalInbound @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator global inbounds the created order with valid tracking ID (uid:50b27d44-6f86-44e7-b9b8-f9f0cd8178c2)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound
    When Operator go to menu Order -> All Orders
    Then Operator verify order info after Global Inbound

  Scenario: Operator global inbounds the created order and override the size (uid:68e2827e-93e7-4407-9726-503b3e9966b9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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

  @DeleteOrArchiveRoute
  Scenario: Operator should not be able to Global Inbound routed pending delivery (uid:f56aada4-dbed-4688-b4eb-a3126d0b4981)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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

  @DeleteOrArchiveRoute
  Scenario Outline: Operator should be able to Global Inbound failed delivery order on Global Inbound page (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
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
      | Note                       | hiptest-uid                              | failureReasonCodeId | rackColor |
      | Failure Reason Code ID = 1 | uid:53f3925a-a618-41f2-8adc-4b853d8e412d | 1                   | #90EE90   |
      | Failure Reason Code ID = 2 | uid:d1236bef-2762-4927-9f97-b07d81b7a8a4 | 2                   | #FFFFED   |
      | Failure Reason Code ID = 3 | uid:b10f6e85-5a72-44d4-b2ee-38bfc7ddb85a | 3                   | #D8BFD8   |
      | Failure Reason Code ID = 5 | uid:13495ba0-9a2d-47a2-8b0c-0718c1120487 | 5                   | #FF9999   |
      | Failure Reason Code ID = 6 | uid:4cb215bb-c094-419c-8708-a741b476a43e | 6                   | #9999FF   |

  Scenario: Inbound showing Weight Discrepancy - Weight Tolerance to not Taking Affect on Global Inbound (uid:bafa05c9-ad25-417e-9270-7b7ae23581ed)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound

  Scenario: Inbound showing Weight Discrepancy - Global Inbound with Higher Weight (uid:a8ee166c-7c3b-4b75-bc8d-b8cd916fef77)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "2" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name}                             |
      | trackingId     | GET_FROM_CREATED_ORDER                 |
      | overrideWeight | 7                                      |
      | weightWarning  | Weight is Higher than original by 3 kg |
    Then API Operator verify order info after Global Inbound

  Scenario: Inbound showing Weight Discrepancy - Global Inbound with Lower Weight (uid:0eee9227-d369-4fe8-b69e-5ed5586c2705)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "2" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name}                            |
      | trackingId     | GET_FROM_CREATED_ORDER                |
      | overrideWeight | 1                                     |
      | weightWarning  | Weight is Lower than original by 3 kg |
    Then API Operator verify order info after Global Inbound

  @CloseNewWindows
  Scenario: Check delivery dates after Global Inbound (uid:4390f3d5-a70b-4a59-b724-39da79efbbfe)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
    When Operator go to menu Order -> All Orders
    When Operator open page of the created order from All Orders page
    And Operator verify Delivery dates:
      | startDateTime | {{next-2-working-days-yyyy-MM-dd}} 09:00:00 |
      | endDateTime   | {{next-4-working-days-yyyy-MM-dd}} 22:00:00 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
