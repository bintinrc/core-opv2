@Sort @Inbounding @GlobalInbound @GlobalInboundPart1 @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @happy-path
  Scenario Outline: Inbound parcel with changes in size - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-3}                               |
      | parcelType   | {parcel-type-bulky}                                      |
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideSize | <size>                                     |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
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
      | size | hiptest-uid                              | dataset_name |
      | S    | uid:ac575eea-cd24-4daa-a5d2-23e3dbc57b5b | S            |
      | M    | uid:17d8ecb4-414c-4830-a0ee-a3dc9af9e376 | M            |
      | L    | uid:be495115-41c4-4432-8fdc-6c16638eae98 | L            |
      | XL   | uid:9bf35d1f-1f78-4a59-a9c6-c5d99acd2f64 | XL           |

  @CloseNewWindows @happy-path
  Scenario: Inbound parcel with changes in weight - Inbound in SG (uid:60912e81-74bf-4d06-a823-909a40c6b9ce)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | parcelType     | {parcel-type-bulky}                                     |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 7                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 7 |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |

  @CloseNewWindows @happy-path
  Scenario: Global inbounds override dimension (uid:8238be24-a3aa-438b-8403-1f8765373477)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-3}                               |
      | parcelType        | {parcel-type-bulky}                                      |
      | trackingId        | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideDimHeight | 2                                          |
      | overrideDimWidth  | 3                                          |
      | overrideDimLength | 5                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |

  @CloseNewWindows @happy-path
  Scenario: Global inbounds override size, weight and dimension (uid:a43d0021-86c6-45e7-a375-7c2249ec9183)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-3}                               |
      | parcelType        | {parcel-type-bulky}                                      |
      | trackingId        | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideSize      | L                                          |
      | overrideWeight    | 7                                          |
      | overrideDimHeight | 2                                          |
      | overrideDimWidth  | 3                                          |
      | overrideDimLength | 5                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |

  @CloseNewWindows @happy-path
  Scenario: Operator should not be able to global inbound parcel with invalid order's status - Returned to Sender (uid:5664ec96-151c-417e-b6aa-2d45a5ca5443)
    Given Operator go to menu Utilities -> QRCode Printing
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
      | parcelType | {parcel-type-bulky}                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | RTS      |
      | rackInfo       | RECOVERY |
      | color          | #fa002c  |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows @happy-path
  Scenario: Operator should not be able to global inbound parcel with invalid order's status - Transferred to Third Party (uid:bea1c2f2-caea-418a-a471-dfbddcb749a3)
    Given Operator go to menu Utilities -> QRCode Printing
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
      | parcelType | {parcel-type-bulky}                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | TRANSFERRED TO 3PL |
      | rackInfo       | RECOVERY           |
      | color          | #fa002c            |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows @happy-path
  Scenario: Operator should not be able to Global Inbound parcel with invalid order's status - Completed Order (uid:9316f5f0-1423-47eb-890d-3916654f545b)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force created order status to Completed
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | parcelType | {parcel-type-bulky}                                      |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | COMPLETED |
      | rackInfo       | RECOVERY  |
      | color          | #fa002c   |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows @happy-path
  Scenario: Operator should not be able to Global Inbound parcel with invalid order's status - Cancelled Order (uid:de8f3cf0-9aee-4c53-aa7f-9b25f8bf3249)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force created order status to Cancelled
    When Operator go to menu Inbounding -> Global Inbound
    When Operator refresh page
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | parcelType | {parcel-type-bulky}                                      |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | CANCELLED |
      | rackInfo       | RECOVERY  |
      | color          | #fa002c   |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op