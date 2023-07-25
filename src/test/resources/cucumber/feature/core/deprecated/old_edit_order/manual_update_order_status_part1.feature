#@OperatorV2 @Core @EditOrder @ManualUpdateOrderStatus @ManualUpdateOrderStatusPart1
Feature: Manual Update Order Status

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Manually Update Order Granular Status - Van en-route to pickup
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus         | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                             |
      | Van en-route to pickup | Transit | PENDING      | PENDING        | PENDING        | PENDING          | Old Granular Status: Pending Pickup\nNew Granular Status: Van en-route to pickup\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - En-route to Sorting Hub
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus          | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                        |
      | En-route to Sorting Hub | Transit | SUCCESS      | PENDING        | SUCCESS        | PENDING          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: En-route to Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Arrived at Sorting Hub
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus         | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                       |
      | Arrived at Sorting Hub | Transit | SUCCESS      | PENDING        | SUCCESS        | PENDING          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Arrived at Sorting Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Arrived at Origin Hub
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus        | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                      |
      | Arrived at Origin Hub | Transit | SUCCESS      | PENDING        | SUCCESS        | PENDING          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Arrived at Origin Hub\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Staging
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                      |
      | Staging        | Staging | STAGING      | STAGING        | PENDING        | PENDING          | Old Pickup Status: Pending\nNew Pickup Status: Staging\n\nOld Delivery Status: Pending\nNew Delivery Status: Staging\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Staging\n\nOld Order Status: Pending\nNew Order Status: Staging\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Pickup fail
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus | status      | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                             |
      | Pickup fail    | Pickup fail | FAIL         | PENDING        | FAIL           | PENDING          | Old Pickup Status: Pending\nNew Pickup Status: Fail\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Pickup fail\n\nOld Order Status: Pending\nNew Order Status: Pickup fail\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Pending Reschedule
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus     | status        | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                                    |
      | Pending Reschedule | Delivery Fail | SUCCESS      | FAIL           | SUCCESS        | FAIL             | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Delivery Status: Pending\nNew Delivery Status: Fail\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Pending Reschedule\n\nOld Order Status: Pending\nNew Order Status: Delivery fail\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Transferred to 3PL
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus     | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                     |
      | Transferred to 3PL | Transit | SUCCESS      | PENDING        | SUCCESS        | PENDING          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Transferred to 3PL\n\nOld Order Status: Pending\n\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Arrived at Distribution Point
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus                | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                                            |
      | Arrived at Distribution Point | Transit | SUCCESS      | SUCCESS        | SUCCESS        | SUCCESS          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Delivery Status: Pending\nNew Delivery Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Arrived at Distribution Point\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |

  Scenario Outline: Operator Manually Update Order Granular Status - Cross Border Transit
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus       | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                           |
      | Cross Border Transit | Transit | PENDING      | PENDING        | PENDING        | PENDING          | Old Granular Status: Pending Pickup\nNew Granular Status: Cross Border Transit\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: Status updated for testing purposes |
