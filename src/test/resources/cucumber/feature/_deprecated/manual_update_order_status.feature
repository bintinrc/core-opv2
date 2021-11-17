@OperatorV2Deprecated @OperatorV2Part1Deprecated
Feature: Manual Update Order Status

   # THIS FEATURE HAS BEEN DEPRECATED

  Scenario Outline: Operator Manually Update Order Granular Status - Returned to Sender (<uuid>)
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
      | granularStatus     | status    | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                                   | uuid                                     |
      | Returned to Sender | Completed | SUCCESS      | SUCCESS        | SUCCESS        | SUCCESS          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Delivery Status: Pending\nNew Delivery Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Returned to Sender\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: Status updated for testing purposes | uid:f7e8a05f-ece3-4508-9bc4-58c6f25a2640 |

  Scenario Outline: Operator Manually Update Order Granular Status - Completed (<uuid>)
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
      | granularStatus | status    | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                          | uuid                                     |
      | Completed      | Completed | SUCCESS      | SUCCESS        | SUCCESS        | SUCCESS          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Delivery Status: Pending\nNew Delivery Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Completed\n\nOld Order Status: Pending\nNew Order Status: Completed\n\nReason: Status updated for testing purposes | uid:d19a41e3-4aa6-4d6a-ba24-b60ada7c2c0b |

  Scenario Outline: Operator Manually Update Order Granular Status - Cancelled (<uuid>)
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
      | granularStatus | status    | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                                                                                              | uuid                                     |
      | Cancelled      | Cancelled | CANCELLED    | CANCELLED      | PENDING        | PENDING          | Old Pickup Status: Pending\nNew Pickup Status: Cancelled\n\nOld Delivery Status: Pending\nNew Delivery Status: Cancelled\n\nOld Granular Status: Pending Pickup\nNew Granular Status: Cancelled\n\nOld Order Status: Pending\nNew Order Status: Cancelled\n\nReason: Status updated for testing purposes | uid:00d39d92-c30b-468b-b2e7-56435bbcabff |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
