@OperatorV2 @Core @AllOrders @RoutingModules @RoutingModulesAllOrders
Feature: All Orders - Order Status Report

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority
  Scenario: Generate Order Statuses Report With Various Order Statuses
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 4                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[4]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Pending Pickup                     |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | Arrived at Sorting Hub             |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | granularStatus | Pending Reschedule                 |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[4].id} |
      | granularStatus | Completed                          |

    And Operator go to menu Order -> All Orders
    And Operator generates order statuses report on All Orders page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    Then Operator verifies that success toast displayed:
      | top | Downloaded CSV |
    Then Operator verifies order statuses report file contains following data:
      | trackingId                            | status                 | size    | inboundDate | orderCreationDate                   | estimatedDeliveryDate                  | firstDeliveryAttempt                | lastDeliveryAttempt                 | deliveryAttempts | secondDeliveryAttempt | thirdDeliveryAttempt | lastUpdateScan                      | failureReason |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Pending Pickup         | XXLARGE | NA          | ^{gradle-current-date-yyyy-MM-dd}.* | {gradle-next-3-working-day-yyyy-MM-dd} | NA                                  | NA                                  | 0                | NA                    | NA                   | NA                                  | NA            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | XXLARGE | NA          | ^{gradle-current-date-yyyy-MM-dd}.* | {gradle-next-3-working-day-yyyy-MM-dd} | NA                                  | NA                                  | 0                | NA                    | NA                   | ^{gradle-current-date-yyyy-MM-dd}.* | NA            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | Pending Reschedule     | XXLARGE | NA          | ^{gradle-current-date-yyyy-MM-dd}.* | {gradle-next-3-working-day-yyyy-MM-dd} | ^{gradle-current-date-yyyy-MM-dd}.* | ^{gradle-current-date-yyyy-MM-dd}.* | 1                | NA                    | NA                   | ^{gradle-current-date-yyyy-MM-dd}.* | NA            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | Completed              | XXLARGE | NA          | ^{gradle-current-date-yyyy-MM-dd}.* | {gradle-next-3-working-day-yyyy-MM-dd} | ^{gradle-current-date-yyyy-MM-dd}.* | ^{gradle-current-date-yyyy-MM-dd}.* | 1                | NA                    | NA                   | ^{gradle-current-date-yyyy-MM-dd}.* | NA            |

  @HighPriority
  Scenario: Download Sample CSV file for Generate Order Statuses Report
    And Operator go to menu Order -> All Orders
    And Operator downloads order statuses report sample CSV on All Orders page
    And Operator verify order statuses report sample CSV file downloaded successfully
