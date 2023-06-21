@OperatorV2 @Core @AllOrders @ForceSuccess @ManualCompletedSelectedPart2
Feature: All Orders - Manually Completed Selected

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Force Success Order on All Orders Page - Unrouted Order with COD - Collect COD
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cod_amount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                      | collected   |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <collected> |
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | Complete Order     |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | DELIVERY           |
      | expectedCodAmount | <collected_amount> |
    Examples:
      | note        | cod_amount | collected_amount | collected |
      | Collect COD | 23.57      | 23.57            | true      |

  Scenario Outline: Operator Force Success Order on All Orders Page - Unrouted Order with COD - Do not Collect COD
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cod_amount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                      | collected   |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <collected> |
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | Complete Order     |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | DELIVERY           |
      | expectedCodAmount | <collected_amount> |

    Examples:
      | note               | cod_amount | collected_amount | collected |
      | Do not Collect COD | 23.57      | 0                | false     |

  Scenario: Operator Force Success Partial Orders on All Orders Page - RTS with COD - Collect COD
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 4                                                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS orders:
      | orderId                           | rtsRequest                                                                                                 |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                                 | collected |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | true      |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | false     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | true      |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | false     |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} \| Order id = {KEY_LIST_OF_CREATED_ORDER_ID[3]}not allowed to collect cod! |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                            |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub New Granular Status: Completed Old Order Status: Transit New Order Status: Completed Reason: FORCE_SUCCESS |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[3]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[4]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub New Granular Status: Returned to Sender\n\nOld Order Status: Transit New Order Status: Completed\n\nReason: FORCE_SUCCESS |

  Scenario: Show Force Success Order Event Details for Manual Complete All Orders Page  - With RTS Normal Parcel
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success single order on All Orders page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name        | FORCED SUCCESS                                                                                                                                                                                                                                                       |
      | description | Reason: Others - {KEY_ORDER_CHANGE_REASON} RTS: true Old Order Status: Transit New Order Status: Completed Old Order Granular Status: Arrived at Sorting Hub New Order Granular Status: Returned to Sender Old Delivery Status: Pending New Delivery Status: Success |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Arrived at Sorting Hub New Granular Status: Returned to Sender\n\nOld Order Status: Transit New Order Status: Completed\n\nReason: FORCE_SUCCESS |

  Scenario: Show Force Success Order Event Details for Manual Complete All Orders Page  - Without RTS
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success single order on All Orders page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name        | FORCED SUCCESS                                                                                                                                                                                                                                       |
      | description | Reason: Others - {KEY_ORDER_CHANGE_REASON} RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |

  Scenario: Shows Error Message on Force Success On Hold Order with Active PETS Ticket on All Orders Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | On Hold                           |
    When Operator go to menu Order -> All Orders
    And Operator Manually Complete orders on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} \| Order id={KEY_LIST_OF_CREATED_ORDER_ID[1]} has active PETS ticket. Please resolve PETS ticket to update status. |

  Scenario Outline: Operator Force Success Order by Select Reason on All Orders Page - <reason>
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success single order on All Orders page:
      | changeReason | <reason> |
    Then API Operator verify order info after Force Successed
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    When Operator get "Pickup" transaction with status "Success"
    Then DB Operator verifies waypoint status is "Success"
    When Operator get "Delivery" transaction with status "Success"
    Then DB Operator verifies waypoint status is "Success"
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name        | FORCED SUCCESS |
      | description | <description>  |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup New Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: FORCE_SUCCESS |
    Examples:
      | reason                                | description                                                                                                                                                                                                                                             |
      | 3PL completed delivery                | Reason: 3PL completed delivery RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                |
      | Fraudulent parcels / Prohibited items | Reason: Fraudulent parcels / Prohibited items RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |
      | Requested by shipper                  | Reason: Requested by shipper RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                  |
      | Lazada returns                        | Reason: Lazada returns RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                        |
      | XB fulfilment storage                 | Reason: XB fulfilment storage RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                 |

  Scenario: Operator Force Success Order by Input Reason on All Orders Page
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success single order on All Orders page:
      | changeReason    | Others (fill in below) |
      | reasonForChange | Force success by TA    |
    Then API Operator verify order info after Force Successed
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    When Operator get "Pickup" transaction with status "Success"
    Then DB Operator verifies waypoint status is "Success"
    When Operator get "Delivery" transaction with status "Success"
    Then DB Operator verifies waypoint status is "Success"
    And Operator verify order event on Edit order page using data below:
      | name        | FORCED SUCCESS                                                                                                                                                                                                                                 |
      | description | Reason: Others - Force success by TA RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE STATUS |
