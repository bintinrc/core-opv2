@Sort @Inbounding @GlobalInbound @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario Outline: Inbound parcel at hub on Operator v2 - <orderType> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<service>", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify order event on Edit order page using data below:
      | name | HUB INBOUND SCAN |
    Examples:
      | orderType    | service | hiptest-uid                              |
      | Normal order | Parcel  | uid:1b29cfe9-33b6-498d-80d0-ac89b4868f81 |
      | Return order | Return  | uid:2785626f-4012-4a4a-a722-00661a8b4261 |

  @CloseNewWindows
  Scenario Outline: Inbound parcel with changes in size - <size> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-3}                               |
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideSize | <size>                                     |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator make sure size changed to "<size>"
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    Examples:
      | size | hiptest-uid                              |
      | S    | uid:ac575eea-cd24-4daa-a5d2-23e3dbc57b5b |
      | M    | uid:17d8ecb4-414c-4830-a0ee-a3dc9af9e376 |
      | L    | uid:be495115-41c4-4432-8fdc-6c16638eae98 |
      | XL   | uid:9bf35d1f-1f78-4a59-a9c6-c5d99acd2f64 |

  @CloseNewWindows
  Scenario: Inbound parcel with changes in weight - Inbound in SG (uid:60912e81-74bf-4d06-a823-909a40c6b9ce)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 7                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |

  @CloseNewWindows
  Scenario: Global inbounds override the weight and recalculate the price (uid:cc9a0545-0a24-4b7c-ae6d-9ef9aafbdcd6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 7                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When API Operator save current order cost
    When API Operator recalculate order price
    When API Operator verify the order price is updated
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |

  @CloseNewWindows
  Scenario: Global inbounds override dimension (uid:8238be24-a3aa-438b-8403-1f8765373477)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-3}                               |
      | trackingId        | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideDimHeight | 2                                          |
      | overrideDimWidth  | 3                                          |
      | overrideDimLength | 5                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |

  @CloseNewWindows
  Scenario: Global inbounds override size, weight and dimension (uid:a43d0021-86c6-45e7-a375-7c2249ec9183)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-3}                               |
      | trackingId        | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideSize      | L                                          |
      | overrideWeight    | 7                                          |
      | overrideDimHeight | 2                                          |
      | overrideDimWidth  | 3                                          |
      | overrideDimLength | 5                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator should not be able to Global Inbound routed pending delivery (uid:42638dfc-d876-44a5-b5c0-bf9ba42ba342)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator refresh page
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo | ROUTED  |
      | color    | #e86161 |
    And API Operator verify order info after Global Inbound
    And DB Operator verify the order_events record exists for the created order with type:
      | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |

  @CloseNewWindows
  Scenario: Operator should not be able to global inbound parcel with invalid order's status - Returned to Sender (uid:5664ec96-151c-417e-b6aa-2d45a5ca5443)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator refresh created order data
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When API Operator force succeed created order without cod
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | RTS                   |
      | rackInfo       | sync_problem RECOVERY |
      | color          | #e86161               |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Operator should not be able to global inbound parcel with invalid order's status - Transferred to Third Party (uid:bea1c2f2-caea-418a-a471-dfbddcb749a3)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
      | 3plShipperName | {3pl-shipper-name} |
      | 3plShipperId   | {3pl-shipper-id}   |
    When API Operator refresh created order data
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | TRANSFERRED TO 3PL    |
      | rackInfo       | sync_problem RECOVERY |
      | color          | #e86161               |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Operator should not be able to Global Inbound parcel with invalid order's status - Completed Order (uid:9316f5f0-1423-47eb-890d-3916654f545b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force created order status to Completed
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | COMPLETED             |
      | rackInfo       | sync_problem RECOVERY |
      | color          | #e86161               |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Operator should not be able to Global Inbound parcel with invalid order's status - Cancelled Order (uid:de8f3cf0-9aee-4c53-aa7f-9b25f8bf3249)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force created order status to Cancelled
    When Operator go to menu Inbounding -> Global Inbound
    When Operator refresh page
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | CANCELLED             |
      | rackInfo       | sync_problem RECOVERY |
      | color          | #e86161               |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Inbound On Vehicle for Delivery Order (uid:4d0c8a28-ca6a-4bf0-9505-ce656f1a6179)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver collect all his routes
    When API Driver get pickup/delivery waypoint of the created order
    When API Operator Van Inbound parcel
    When API Operator start the route
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo | ROUTED  |
      | color    | #e86161 |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

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
  Scenario Outline: Inbound failed delivery - <Note> (<hiptest-uid>)
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
      | Note                       | hiptest-uid                              | failureReasonCodeId | rackColor |
      | failure_reason_code_id = 1 | uid:cf4d5066-8706-43d4-8eaa-6ff0f6664648 | 1                   | #90EE90   |
      | failure_reason_code_id = 2 | uid:e1e5fc32-05bb-46a3-81e8-b5d6e9235e7f | 2                   | #FFFFED   |
      | failure_reason_code_id = 3 | uid:e0789546-619e-47ef-bcff-8b362da04d80 | 3                   | #D8BFD8   |
      | failure_reason_code_id = 5 | uid:93e4b151-b514-4f4d-8580-bc92f1120319 | 13                  | #90EE90   |
      | failure_reason_code_id = 6 | uid:6f91726d-ba39-462b-ac0e-e7533d00bd5e | 6                   | #9999FF   |

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
  Scenario Outline: Inbound with Priority Level - <Note> (<hiptest-uid>)
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
      | Note   | hiptest-uid                              | priorityLevel | priorityLevelColorAsHex |
      | 1      | uid:b686236c-d123-4def-9d76-4ca59380f820 | 1             | #f8cf5c                 |
      | 2 - 90 | uid:d21927f7-ff4b-4dca-965d-ac3630f24217 | 50            | #e29d4a                 |
      | > 90   | uid:125b3e40-9e7e-41bc-b61a-3b138ba54149 | 100           | #c65d44                 |

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

  @CloseNewWindows
  Scenario: Inbound On Hold Order - DO NOT Resolve NON-MISSING ticket type (uid:e1211ee8-24c0-42f2-bb00-4940d65950da)
    When Operator go to menu Shipper Support -> Blocked Dates
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create recovery ticket using data below:
      | ticketType              | 5                                |
      | subTicketType           | 9                                |
      | entrySource             | 1                                |
      | investigatingParty      | 448                              |
      | investigatingHubId      | 1                                |
      | outcomeName             | ORDER OUTCOME (DUPLICATE PARCEL) |
      | outComeValue            | REPACKED/RELABELLED TO SEND      |
      | comments                | Automation Testing.              |
      | shipperZendeskId        | 1                                |
      | ticketNotes             | Automation Testing.              |
      | issueDescription        | Automation Testing.              |
      | creatorUserId           | 106307852128204474889            |
      | creatorUserName         | Niko Susanto                     |
      | creatorUserEmail        | niko.susanto@ninjavan.co         |
      | TicketCreationSource    | TICKET_MANAGEMENT                |
      | ticketTypeId            | 17                               |
      | subTicketTypeId         | 17                               |
      | entrySourceId           | 13                               |
      | trackingIdFieldId       | 2                                |
      | investigatingPartyId    | 15                               |
      | investigatingHubFieldId | 67                               |
      | outcomeNameId           | 64                               |
      | commentsId              | 26                               |
      | shipperZendeskFieldId   | 36                               |
      | ticketNotesId           | 32                               |
      | issueDescriptionId      | 45                               |
      | creatorUserFieldId      | 30                               |
      | creatorUserNameId       | 39                               |
      | creatorUserEmailId      | 66                               |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | ON HOLD - SHIPPER ISSUE |
      | rackInfo       | sync_problem RECOVERY   |
      | color          | #e86161                 |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator removes all ticket status filters
    And Operator enters the Tracking Id
    Then Operator chooses the ticket status as "PENDING"
    And Operator enters the tracking id and verifies that is exists

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Standard (uid:c43a34d0-b8ba-4e6f-9304-51320543b9ee)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                        |
      | endDate | {gradle-next-3-working-day-yyyy-MM-dd} |

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Express (uid:45b363f0-1fb9-4155-8a7a-c9bd3d46da73)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Express", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                        |
      | endDate | {gradle-next-2-working-day-yyyy-MM-dd} |

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Nextday (uid:69d8cd89-bfd3-4e1a-ad04-ece038974e99)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                        |
      | endDate | {gradle-next-1-working-day-yyyy-MM-dd} |

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Sameday (uid:79a946bb-aa72-4e5e-a063-9656f8826a7b)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                 |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                        |
      | endDate | {gradle-next-2-working-day-yyyy-MM-dd} |

  @CloseNewWindows
  Scenario: Inbound parcel that is intended to be picked up on future date - Standard (uid:d929ec0a-629b-4ab3-beae-47ef1fafc329)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status             | SUCCESS                        |
      | startDate          | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate            | {gradle-next-1-day-yyyy-MM-dd} |
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                                |
      | startDate | {gradle-next-1-day-yyyy-MM-dd}         |
      | endDate   | {gradle-next-3-working-day-yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound parcel that is intended to be picked up on future date - Express (uid:56abc408-a381-4c0d-b431-ed75a0f289d7)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Express", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status             | SUCCESS                        |
      | startDate          | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate            | {gradle-next-1-day-yyyy-MM-dd} |
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-2-working-day-yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound parcel that is intended to be picked up on future date - Nextday (uid:49cbc076-7249-431d-abbb-43771b2ec41a)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status             | SUCCESS                        |
      | startDate          | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate            | {gradle-next-1-day-yyyy-MM-dd} |
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-working-day-yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound parcel that is intended to be picked up on future date - Sameday (uid:964cd5ae-50f2-4ea0-87b4-e36fcfe1b49a)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status             | SUCCESS                        |
      | startDate          | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate            | {gradle-next-1-day-yyyy-MM-dd} |
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound showing max weight limit alert - inbound weight is higher than max weight limit (uid:d56315b8-24df-49ad-8d1f-f02e0cfeb658)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "0" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator set Weight Limit value to "25" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 25                                         |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And DB Operator verify the order_events record exists for the created order with type:
      | 26 |

  @CloseNewWindows
  Scenario: Inbound showing max weight limit alert - inbound weight is equal to max weight limit (uid:fbcb6c61-f744-4bb7-9697-561d32714f9a)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "100" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator set Weight Limit value to "25" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 26                                         |
      | weightWarning  | Weight is exceeding inbound weight limit   |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #e86161                            |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound showing max weight limit alert - inbound weight is lower than max weight limit (uid:533e3e4d-5dd0-4582-a204-2e163620654c)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "100" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator set Weight Limit value to "25" on Global Settings page


    And Operator refresh page
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 24                                         |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound an International order - portation export (uid:a0364582-4f4a-4f8c-90e6-ded25c878348)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"International", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}, "international":{"portation":"export"}} |
      | addressType       | global                                                                                                                                                                                                                                                                |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | INTERNATIONAL                  |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector} |
      | color          | #ffa400                        |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound an International order - portation import (uid:581b7d82-f823-4d56-b6a4-bfffc2b65d8f)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"International", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}, "international":{"portation":"import"}} |
      | addressType       | global                                                                                                                                                                                                                                                                |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Inbound Arrived at Distribution Point Order (uid:6213841e-2cb4-434b-bd6b-020aea8833ba)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with DPMS ID = "{dpms-id}"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator pulled out parcel "DELIVERY" from route
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    When API Operator refresh created order data
    And Operator go to menu Inbounding -> Global Inbound
    And Operator refresh page
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And Operator verifies DP tag is displayed
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound With Device ID (uid:a4df911d-8bf7-43ae-aef0-e791b6e9a664)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | deviceId   | 12345                                      |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    Then Operator verify Delivery "HUB INBOUND SCAN" order event description on Edit order page

  @CloseNewWindows
  Scenario: Order Tagging with Global Inbound - Total tags is less/equal 4 (uid:0e043740-9f44-45ae-94a3-94f6987c45ad)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | tags       | OPV2AUTO1,OPV2AUTO2,OPV2AUTO3              |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    And DB Operator verify order_events record for the created order:
      | type | 48 |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Order Tagging with Global Inbound - Total tags is more than 4 (uid:aecc250f-25a7-49ec-8d19-8634ff2a1d79)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | tags       | OPV2AUTO1,OPV2AUTO2,OPV2AUTO3,SORTAUTO02   |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And Operator verify failed tagging error toast is shown
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | PRIOR |
    And DB Operator verify order_events record for the created order:
      | type | 48 |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound Parcel With Prior Tag (uid:ac8ca197-533b-4e1a-bf13-b429d44bd93c)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verifies prior tag is displayed
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound parcel with changes in dimensions (0 Values) (uid:d2232263-f912-4561-8154-d56327e54ca0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "length":"40", "width":"41", "height":"12", "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-3}                               |
      | trackingId        | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideDimHeight | 0                                          |
      | overrideDimWidth  | 0                                          |
      | overrideDimLength | 0                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    Then Operator verify "HUB INBOUND SCAN" order event description on Edit order page

  @CloseNewWindows
  Scenario: Inbound parcel with changes in dimensions (NULL Values) (uid:83644b40-cd17-4b3a-b6ba-927a8170a4f3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "length":"40", "width":"41", "height":"12", "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    Then Operator verify "HUB INBOUND SCAN" order event description on Edit order page

  @CloseNewWindows
  Scenario: Inbound parcel with changes in dimensions (with volumetric weight)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {KEY_CREATED_ORDER.destinationHub}         |
      | trackingId        | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideDimHeight | {dimension-height}                         |
      | overrideDimWidth  | {dimension-width}                          |
      | overrideDimLength | {dimension-length}                         |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #55a1e8                            |
    Then API Operator verify order info after Global Inbound
    When API Operator get order details by saved Order ID
    And Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify "HUB INBOUND SCAN" order event description on Edit order page
    And Operator verifies order weight is overridden based on the volumetric weight

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op