@Sort @Inbounding @GlobalInbound @GlobalInboundPart2 @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Inbound invalid tracking ID (uid:af756fa4-6695-40e2-8632-6de0055c0083)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3} |
      | trackingId | INVALID      |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | INVALID               |
      | rackInfo       | sync_problem RECOVERY |
      | color          | #e86161               |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Inbound failed delivery - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance           |
      | failureReasonCodeId    | <failureReasonCodeId> |
      | failureReasonIndexMode | FIRST                 |
    When Operator go to menu Inbounding -> Global Inbound
    And Operator refresh page
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId | {hub-id-3} |
      | type  | 2          |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    Examples:
      | Note                       | hiptest-uid                              | failureReasonCodeId | rackColor | dataset_name               |
      | failure_reason_code_id = 1 | uid:cf4d5066-8706-43d4-8eaa-6ff0f6664648 | 1                   | #90EE90   | failure_reason_code_id = 1 |
      | failure_reason_code_id = 2 | uid:e1e5fc32-05bb-46a3-81e8-b5d6e9235e7f | 2                   | #FFFFED   | failure_reason_code_id = 2 |
      | failure_reason_code_id = 3 | uid:e0789546-619e-47ef-bcff-8b362da04d80 | 3                   | #D8BFD8   | failure_reason_code_id = 3 |
      | failure_reason_code_id = 5 | uid:93e4b151-b514-4f4d-8580-bc92f1120319 | 13                  | #90EE90   | failure_reason_code_id = 5 |
      | failure_reason_code_id = 6 | uid:6f91726d-ba39-462b-ac0e-e7533d00bd5e | 6                   | #9999FF   | failure_reason_code_id = 6 |

  @CloseNewWindows
  Scenario: Inbound showing weight discrepancy alert - weight tolerance is not set, lower weight (uid:272f52ce-9443-4510-a7fd-10ff40c28c4c)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound

  @CloseNewWindows
  Scenario: Inbound showing Weight Discrepancy Alert - weight tolerance is set, higher weigh (uid:6fd8c798-b6b4-4920-bbc8-891bd6355eae)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "2" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator refresh page
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 10                                         |
      | weightWarning  | Weight is higher than original by 6.0 kg   |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound

  @CloseNewWindows
  Scenario: Inbound showing Weight Discrepancy Alert - weight tolerance is set, lower weight (uid:ccae0c7e-cee9-45e4-adfe-024b8334e6a6)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "2" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And API Operator update order weight to 10
    And Operator refresh page
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 2                                          |
      | weightWarning  | Weight is lower than original by 8.0 kg    |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound

  @CloseNewWindows
  Scenario: Inbound parcel picked up from DP - Pickup Pending (uid:9ed6ad00-9a3c-4bc8-b4ab-3f67d6238d58)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API DP lodge in an order to DP with ID = "{dp-id}" and Shipper Legacy ID = "{shipper-v4-legacy-id}"
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId   | {hub-id-3}                                 |
      | orderId | {KEY_CREATED_ORDER_ID}                     |
      | scan    | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | type    | 2                                          |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    And DB Operator verify dp_qa_gl.dp_job_orders record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | SUCCESS                                    |
    And DB Operator verify dp_qa_gl.dp_jobs record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | COMPLETED                                  |
    And DB Operator verify dp_qa_gl.dp_reservations record using data below:
      | trackingId  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | barcode     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status      | RELEASED                                   |
      | releasedTo  | DRIVER                                     |
      | collectedAt | {gradle-current-date-yyyy-MM-dd}           |
      | releasedAt  | {gradle-current-date-yyyy-MM-dd}           |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound parcel picked up from DP - Pickup Successed (uid:7c40f1b0-f27e-4699-b9ca-839b7923eddb)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API DP lodge in an order to DP with ID = "{dp-id}" and Shipper Legacy ID = "{shipper-v4-legacy-id}"
    Given DB Operator gets the Order ID by Tracking ID
    Given DB Operator gets Reservation ID based on Order ID from order pickups table
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add pickup reservation based on Address ID to route
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get Reservation Job
    Given DB Operator get DP job id
    And API Operator do the DP Success for To Driver Flow
    And API Driver success Reservation by scanning created parcel
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    And DB Operator verify dp_qa_gl.dp_job_orders record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | SUCCESS                                    |
    And DB Operator verify dp_qa_gl.dp_jobs record using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status     | COMPLETED                                  |
    And DB Operator verify dp_qa_gl.dp_reservations record using data below:
      | trackingId  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | barcode     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status      | RELEASED                                   |
      | releasedTo  | DRIVER                                     |
      | collectedAt | {gradle-current-date-yyyy-MM-dd}           |
      | releasedAt  | {gradle-current-date-yyyy-MM-dd}           |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario Outline: Inbound with Priority Level - <dataset_name> (<hiptest-uid>)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update priority level of an order:
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | priorityLevel | <priorityLevel>                   |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then Operator verifies priority level info is correct using data below:
      | priorityLevel           | <priorityLevel>           |
      | priorityLevelColorAsHex | <priorityLevelColorAsHex> |
    Then API Operator verify order info after Global Inbound
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | type       | 2                                          |
    Then DB Operator verify next Pickup transaction values are updated for the created order:
      | status         | Success                     |
      | serviceEndTime | {{current-date-yyyy-MM-dd}} |
      | priorityLevel  | 0                           |
    And DB Operator verify next Delivery transaction values are updated for the created order:
      | priorityLevel | <priorityLevel> |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Examples:
      | Note   | hiptest-uid                              | priorityLevel | priorityLevelColorAsHex | dataset_name |
      | 1      | uid:b686236c-d123-4def-9d76-4ca59380f820 | 1             | #f8cf5c                 | 1            |
      | 2 - 90 | uid:d21927f7-ff4b-4dca-965d-ac3630f24217 | 50            | #e29d4a                 | 2 - 90       |
      | > 90   | uid:125b3e40-9e7e-41bc-b61a-3b138ba54149 | 100           | #c65d44                 | > 90         |

  @CloseNewWindows
  Scenario: Inbound Fully Integrated DP Order (uid:8a855ffd-2b50-4aea-a358-53cff150ad98)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-fully-integrated-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-fully-integrated-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"standard","reference":{"merchant_order_number":"ship-123"},"to":{"name":"Latika Jamnal","phone_number":"+6588923644","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address1":"30 Jalan Kilang Barat","address2":"NVQA V4 HQ","postcode":"628586"}, "collection_point": "{dp-short-name}"},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_address_slot_id":1,"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"weight":2},"allow_self_collection":true}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And Operator verifies DP tag is displayed
    And API Operator verify order info after Global Inbound
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | type       | 2                                          |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When API DP get the DP Details by DP ID = "{dp-id}"
    Then DB Operator gets all details for ninja collect confirmed status
    And Ninja Collect Operator verifies that all the details for Confirmed Status via "Fully Integrated" are right

  @CloseNewWindows
  Scenario: Inbound Semi Integrated DP Order (uid:d846ee76-cf66-4b14-8e91-88f3f8f3999f)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-semi-integrated-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-semi-integrated-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"standard","reference":{"merchant_order_number":"ship-123"},"to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"SIANG LIM SIAN LI BUDDHIST TEMPLE","address1":"184E JALAN TOA PAYOH #1-1","postcode":"319941"}},"parcel_job":{"allow_doorstep_dropoff": true,"enforce_delivery_verification": false,"delivery_verification_mode": "SIGNATURE","is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_address_slot_id":1,"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"weight":1},"allow_self_collection":true}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | type       | 2                                          |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When API DP get the DP Details by DP ID = "{dp-id}"
    And DB Operator gets all details for ninja collect confirmed status
    And Ninja Collect Operator verifies that all the details for Confirmed Status via "Semi Integrated" are right

  @CloseNewWindows
  Scenario: Inbound Parcel with Order Tags (uid:3f95f6e9-4e6a-4599-b438-7b1b74330c33)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-name} |
      | status          | Pending           |
      | granular status | Pending Pickup    |
    And Operator searches and selects orders created first row on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then Operator verifies tags on Global Inbound page
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    Then API Operator verify order info after Global Inbound
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | type       | 2                                          |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound On Hold Order - Resolve PENDING MISSING ticket type (uid:e1211ee8-24c0-42f2-bb00-4940d65950da)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create recovery ticket using data below:
      | ticketType              | 2                           |
      | entrySource             | 1                           |
      | investigatingParty      | 448                         |
      | investigatingHubId      | 1                           |
      | outcomeName             | ORDER OUTCOME (MISSING)     |
      | outComeValue            | REPACKED/RELABELLED TO SEND |
      | comments                | Automation Testing.         |
      | shipperZendeskId        | 1                           |
      | ticketNotes             | Automation Testing.         |
      | issueDescription        | Automation Testing.         |
      | creatorUserId           | 106307852128204474889       |
      | creatorUserName         | Niko Susanto                |
      | creatorUserEmail        | niko.susanto@ninjavan.co    |
      | TicketCreationSource    | TICKET_MANAGEMENT           |
      | ticketTypeId            | 17                          |
      | entrySourceId           | 13                          |
      | trackingIdFieldId       | 2                           |
      | investigatingPartyId    | 15                          |
      | investigatingHubFieldId | 67                          |
      | outcomeNameId           | 64                          |
      | commentsId              | 26                          |
      | shipperZendeskFieldId   | 36                          |
      | ticketNotesId           | 32                          |
      | issueDescriptionId      | 45                          |
      | creatorUserFieldId      | 30                          |
      | creatorUserNameId       | 39                          |
      | creatorUserEmailId      | 66                          |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator removes all ticket status filters
    And Operator enters the Tracking Id
    Then Operator chooses the ticket status as "RESOLVED"
    And Operator enters the tracking id and verifies that is exists
    Then API Operator make sure "TICKET_RESOLVED" event is exist
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op