@OperatorV2 @Core @NewFeatures @OrderParcelSizeUpdate
Feature: Order Parcel Size Update

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator download sample CSV file for Order Parcel Size Update
    Given Operator go to menu New Features -> Order Parcel Size Update
    When Operator download sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page
    Then sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page is downloaded successfully

  @HighPriority
  Scenario: Operator update order parcel size by upload CSV file with Multiple Orders
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                            |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator go to menu New Features -> Order Parcel Size Update
    And Operator upload Multiple Order Parcel Size update CSV on Order Parcel Size Update page:
      | trackingId                                 | size   |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | MEDIUM |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | LARGE  |
    Then Operator verifies that success react notification displayed:
      | top | Matches with file shown in table |
    When Operator clicks Upload button on Order Parcel Size Update page
    Then Operator verifies that success react notification displayed:
      | top | Parcel size update success |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | size | MEDIUM |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE DIMENSION |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | size | LARGE |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE DIMENSION |
