@OperatorV2 @Core @AllOrders @ForceSuccess @ManualCompletedSelectedPart2
Feature: All Orders - Manually Completed Selected

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority
  Scenario Outline: Operator Force Success Order on All Orders Page - Unrouted Order with COD - Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                        |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cod_amount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                            | collected   |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | <collected> |
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | Complete Order     |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator unmask edit order V2 page
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Pending New Pickup Status: Success Old Delivery Status: Pending New Delivery Status: Success Old Granular Status: Pending Pickup New Granular Status: Completed Old Order Status: Pending New Order Status: Completed Reason: FORCE_SUCCESS |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | collectedSum | <collected_amount>                                         |
    Examples:
      | note        | cod_amount | collected_amount | collected |
      | Collect COD | 23.57      | 23.57            | true      |

  @MediumPriority
  Scenario Outline: Operator Force Success Order on All Orders Page - Unrouted Order with COD - Do not Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                        |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cod_amount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                            | collected   |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | <collected> |
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | Complete Order     |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator unmask edit order V2 page
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Pending New Pickup Status: Success Old Delivery Status: Pending New Delivery Status: Success Old Granular Status: Pending Pickup New Granular Status: Completed Old Order Status: Pending New Order Status: Completed Reason: FORCE_SUCCESS |
    And DB Core - Operator verifies cod_collections record:
      | waypointId   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | collectedSum | <collected_amount>                                         |
    Examples:
      | note        | cod_amount | collected_amount | collected |
      | Collect COD | 23.57      | 0                | false     |

  @MediumPriority
  Scenario: Operator Force Success Partial Orders on All Orders Page - RTS with COD - Collect COD
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | numberOfOrder       | 4                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                            | collected |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | true      |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | false     |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | true      |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | false     |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} \| Order id = {KEY_LIST_OF_CREATED_ORDERS[3].id}not allowed to collect cod! |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[4].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Returned to Sender" on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | FORCED SUCCESS |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                               |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Pending New Delivery Status: Success Old Granular Status: Arrived at Sorting Hub New Granular Status: Returned to Sender Old Order Status: Transit New Order Status: Completed Reason: FORCE_SUCCESS |

  @MediumPriority
  Scenario: Show Force Success Order Event Details for Manual Complete All Orders Page  - With RTS Normal Parcel
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success single order on All Orders page:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Returned to Sender" on Edit Order V2 page
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | FORCED SUCCESS                                                                                                                                                                                                                                                               |
      | description | Reason: Others - Force success from automated test RTS: true Old Order Status: Transit New Order Status: Completed Old Order Granular Status: Arrived at Sorting Hub New Order Granular Status: Returned to Sender Old Delivery Status: Pending New Delivery Status: Success |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                               |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Pending New Delivery Status: Success Old Granular Status: Arrived at Sorting Hub New Granular Status: Returned to Sender Old Order Status: Transit New Order Status: Completed Reason: FORCE_SUCCESS |

  @MediumPriority
  Scenario: Show Force Success Order Event Details for Manual Complete All Orders Page  - Without RTS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator Force Success multiple orders on All Orders page:
      | trackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | FORCED SUCCESS                                                                                                                                                                                                                                               |
      | description | Reason: Others - Force success from automated test RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |

  @MediumPriority
  Scenario: Shows Error Message on Force Success On Hold Order with Active PETS Ticket on All Orders Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Hold                            |
    When Operator go to menu Order -> All Orders
    And Operator Manually Complete orders on All Orders page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} \| Order id={KEY_LIST_OF_CREATED_ORDERS[1].id} has active PETS ticket. Please resolve PETS ticket to update status. |

  @MediumPriority
  Scenario Outline: Operator Force Success Order by Select Reason on All Orders Page - <reason>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator Force Success single order on All Orders page:
      | reason     | <reason>                            |
      | trackingId | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | status   | Success                                                    |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status   | Success                                                    |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | FORCED SUCCESS |
      | description | <description>  |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Pending New Pickup Status: Success Old Delivery Status: Pending New Delivery Status: Success Old Granular Status: Pending Pickup New Granular Status: Completed Old Order Status: Pending New Order Status: Completed Reason: FORCE_SUCCESS |
    Examples:
      | reason                                | description                                                                                                                                                                                                                                             |
      | 3PL completed delivery                | Reason: 3PL completed delivery RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                |
      | Fraudulent parcels / Prohibited items | Reason: Fraudulent parcels / Prohibited items RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |
      | Requested by shipper                  | Reason: Requested by shipper RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                  |
      | Lazada returns                        | Reason: Lazada returns RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                        |
      | XB fulfilment storage                 | Reason: XB fulfilment storage RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                 |

  @MediumPriority
  Scenario: Operator Force Success Order by Input Reason on All Orders Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator Force Success single order on All Orders page:
      | reason            | Others (fill in below)              |
      | reasonDescription | Force success by TA                 |
      | trackingId        | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Completed" on Edit Order V2 page
    And Operator verify order granular status is "Completed" on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | status   | Success                                                    |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status   | Success                                                    |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | FORCED SUCCESS                                                                                                                                                                                                                                 |
      | description | Reason: Others - Force success by TA RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
