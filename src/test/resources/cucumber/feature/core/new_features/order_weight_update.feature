@OperatorV2 @Core @NewFeatures @OrderWeightUpdate
Feature: Order Weight Update V2

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator Download Sample CSV file for Order Weight Update
    Given Operator go to menu New Features -> Order Weight Update
    When Operator download sample CSV file for 'Find Orders with CSV' on Order Weight Update page
    Then Operator verify sample CSV file is downloaded successfully on Order Weight Update page

  @HighPriority
  Scenario: Operator Update Order Weight by Upload CSV - Single Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":5.0}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu New Features -> Order Weight Update
    When Operator upload Order Weight update CSV on Order Weight Update page:
      | trackingId                            | weight |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | 4.5    |
    Then Operator verifies that success react notification displayed:
      | top | Matches with file shown in table |
    And Operator verify table records on Order Weight Update page:
      | id                                 | trackingId                            | stampId | status  | newWeight | isValid |
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | Pending | 4.5       | Valid   |
    Then Operator click Upload button on Order Weight Update page
    Then Operator verifies that success react notification displayed:
      | top | Weight update success |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | weight     | 4.5                                |
      | dimensions | ^.*"weight":4\.5.*                 |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | type    | 16                                                                                                         |
      | data    | ^.*"weight":\{"old_value":5\.0,"new_value":4\.5\},"pricing_weight":\{"old_value":5\.0,"new_value":4\.5\}.* |

  @HighPriority
  Scenario: Operator Update Order Weight by Upload CSV - Multiple Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":5.0}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given Operator go to menu New Features -> Order Weight Update
    When Operator upload Order Weight update CSV on Order Weight Update page:
      | trackingId                            | weight |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | 4.5    |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | 3.5    |
    Then Operator verifies that success react notification displayed:
      | top | Matches with file shown in table |
    And Operator verify table records on Order Weight Update page:
      | id                                 | trackingId                            | stampId | status  | newWeight | isValid |
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |         | Pending | 4.5       | Valid   |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |         | Pending | 3.5       | Valid   |
    Then Operator click Upload button on Order Weight Update page
    Then Operator verifies that success react notification displayed:
      | top | Weight update success |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | weight     | 4.5                                |
      | dimensions | ^.*"weight":4\.5.*                 |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | type    | 16                                                                                                         |
      | data    | ^.*"weight":\{"old_value":5\.0,"new_value":4\.5\},"pricing_weight":\{"old_value":5\.0,"new_value":4\.5\}.* |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | weight     | 3.5                                |
      | dimensions | ^.*"weight":3\.5.*                 |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                         |
      | type    | 16                                                                                                         |
      | data    | ^.*"weight":\{"old_value":5\.0,"new_value":3\.5\},"pricing_weight":\{"old_value":5\.0,"new_value":3\.5\}.* |
