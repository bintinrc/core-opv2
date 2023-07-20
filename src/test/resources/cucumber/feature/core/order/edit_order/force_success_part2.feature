@OperatorV2 @Core @EditOrder @ForceSuccess @ForceSuccessPart2 @EditOrder2
Feature: Force Success

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Show Force Success Order Event Details for Manual Complete Edit Order Page - Resolved PETS Ticket
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT                  |
      | investigatingDepartment | Recovery                            |
      | investigatingHub        | {hub-name}                          |
      | ticketType              | DAMAGED                             |
      | ticketSubType           | IMPROPER PACKAGING                  |
      | parcelLocation          | DAMAGED RACK                        |
      | liability               | Shipper                             |
      | damageDescription       | GENERATED                           |
      | orderOutcomeDamaged     | NV LIABLE - FULL - PARCEL DELIVERED |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status                  | RESOLVED |
      | keepCurrentOrderOutcome | Yes      |
    Then Operator verifies that success toast displayed:
      | top                | ^Ticket ID : .* updated |
      | waitUntilInvisible | true                    |
    When Operator refresh page
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name        | FORCED SUCCESS                                                                                                                                                                                                                              |
      | description | Reason: TICKET_RESOLUTION RTS: false Old Order Status: Transit New Order Status: Completed Old Order Granular Status: Arrived at Sorting Hub New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description                                                                                                                                                  |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: On Hold New Granular Status: Arrived at Sorting Hub\n\nOld Order Status: On Hold New Order Status: Transit\n\nReason: TICKET_RESOLUTION |

  Scenario: Show Force Success Order Event Details for Manual Complete Edit Order Page - With RTS PETS Ticket
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | PARCEL ON HOLD     |
      | ticketSubType           | SHIPPER REQUEST    |
      | orderOutcome            | RTS                |
      | rtsReason               | Nobody at address  |
      | exceptionReason         | GENERATED          |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status                  | RESOLVED          |
      | keepCurrentOrderOutcome | Yes               |
      | outcome                 | RTS               |
      | rtsReason               | Nobody at address |
    Then Operator verifies that success toast displayed:
      | top                | ^Ticket ID : .* updated |
      | waitUntilInvisible | true                    |
    When Operator refresh page
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator confirm manually complete order on Edit Order page
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

  Scenario: Show Force Success Order Event Details for Manual Complete Edit Order Page - Without RTS
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator confirm manually complete order on Edit Order page
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name        | FORCED SUCCESS                                                                                                                                                                                                                                       |
      | description | Reason: Others - {KEY_ORDER_CHANGE_REASON} RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |

  Scenario: Show Force Success Order Event Details for Manual Complete Edit Order Page  - With RTS Normal Parcel
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator confirm manually complete order on Edit Order page
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

  Scenario: Disable Force Success On Hold Order with Active PETS Ticket
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | On Hold                           |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify menu item "Order Settings" > "Manually Complete Order" is disabled on Edit order page

  Scenario Outline: Operator Force Success Order by Select Reason on Edit Order Page - <reason>
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator confirm manually complete order on Edit Order page:
      | changeReason | <reason> |
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
      | name | UPDATE STATUS |
    And Operator verify order event on Edit order page using data below:
      | name        | FORCED SUCCESS |
      | description | <description>  |
    Examples:
      | reason                                | description                                                                                                                                                                                                                                             |
      | 3PL completed delivery                | Reason: 3PL completed delivery RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                |
      | Fraudulent parcels / Prohibited items | Reason: Fraudulent parcels / Prohibited items RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success |
      | Requested by shipper                  | Reason: Requested by shipper RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                  |
      | Lazada returns                        | Reason: Lazada returns RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                        |
      | XB fulfilment storage                 | Reason: XB fulfilment storage RTS: false Old Order Status: Pending New Order Status: Completed Old Order Granular Status: Pending Pickup New Order Granular Status: Completed Old Delivery Status: Pending New Delivery Status: Success                 |

  Scenario: Operator Force Success Order by Input Reason on Edit Order Page
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator confirm manually complete order on Edit Order page:
      | changeReason    | Others (fill in below) |
      | reasonForChange | Force success by TA    |
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
